trigger EmailMessageTrigger_Mikes on EmailMessage (before insert, after insert) {
   List<User> users = [select Id, Lastlogindate from User where profile.name = 'CRT Member' and available__c = true];
    
    String test = UserInfo.getProfileId();
    
        Map<String, Case> suppliedEmails = new Map<String, Case>(); 
        List<Id> parentIdList = new List<Id>(); 
        List<EmailMessage> toAddComment = new List<EmailMessage>();
    
        //Since this list will get all cases in trigger.new the SuppliedEmail will have to be in the list twice if 
        //there is already a case open for this email. 
        List<Case> cases = [SELECT SuppliedEmail, Id, CaseNumber, Subject FROM Case WHERE Origin = 'Email'];
        system.debug('Case List '+cases);
    
    //Before insert check if a case already exists with the specified web-email
    if(trigger.isBefore){
        
        //Start by putting first case into set. Then continue looping through the set. If you find
        //a case with a supplied email that already exists then a case was already opened for that 
        //email address. Place these emails in a map so that the parentID can be retrieved also later. 
        //Using a set here because it has the contains method
        Set<String> caseHolder = new set<String>();
        for(Case c : cases)
        {
            if(caseHolder.contains(c.SuppliedEmail))
            {
                //If there are two cases then it already existed, place in suppliedEmails map 
                //so that the parentID can be used to append a comment to the appropriate case. 
               suppliedEmails.put(c.SuppliedEmail, c);
            }
            else 
                caseHolder.add(c.SuppliedEmail);
        }
        
        system.debug('Supplied email list '+suppliedEmails);
        system.debug('Trigger.new size = '+Trigger.new.size()+'In trigger.new '+trigger.new);
        /**
         * If the email.fromAddress is in the supplied email list 
         * than that sender already has a case open and 
         * the TextBody of the email should be appended to its parent case 
         * as a comment. 
         */
        try{
            for(EmailMessage email : trigger.new)
            {
                System.debug('Email that came in sent by '+email.FromAddress
                            +' Checking against '+suppliedEmails.get(email.FromAddress).suppliedEmail);
                
                /**
                 * check if the supplied email is in the supplied email list than a case already exists with that email. 
                 * check if the sunbject of the email contains a case Id and that case Id is the Id of one of the open cases.
                 * both conditions must be true to append a comment, if not then create a new case like normal for the message. 
                 */ 
                if( (suppliedEmails.get(email.FromAddress) != null) && (subjectContainsId(email)) )
                {
                                        
                    
                    Case needsComment = suppliedEmails.remove(email.FromAddress);
                    system.debug('Case already existed ' + needsComment.Id);
                    //add comment to the case. 
                    CaseComment newComment = new CaseComment();
                    newComment.CommentBody = 'Email Comment: \n'+email.TextBody;  
                    system.debug('Comment body will be '+ email.TextBody);
                    newComment.IsPublished = true; 
                    newComment.ParentId = needsComment.Id; 
                    insert newComment;
                    
                    //prevent email message from being inserted. 
                    //                    //Delete the new case that was inserted. 
                    Id caseId = email.ParentId; 
                    Case toDelete = [SELECT Id from Case WHERE Id = :caseId];
                    toDelete.DuplicateEmail__c = true;
                    update toDelete;  
                }
            }
        } 
        catch(NullPointerException e){}
       
    } 
    else if (Trigger.isAfter){
        
        List<Id> parentId = new List<Id>();
        for(EmailMessage email : trigger.new)
        {
            parentId.add(email.ParentId);
        }
        
        //Delete all cases where there was a duplicate email. 
        List<Case> parentList = [SELECT Id, DuplicateEmail__c FROM Case WHERE Id IN :(parentId)];
        for(Case c : parentList)
        {
            if(c.DuplicateEmail__c)
            {
                delete c; 
            }
        }
        
        String id = [select Id from Profile where Name = 'CRT Member' limit 1].id;
        //Just need to call reshuffleEamilCases method from caseAllocator 
        Case_Allocator ca = new Case_Allocator();
        ca.reshuffleEmailCases();
    }
    
    /**
    * Loops through all emails attached to cases in case list and checks 
    * for a caseID matching the subject line of the new email message, returns true if one is found
    * @author Mike McGee 
    * @param email  the message in trigger.new that is being checked for a current open case
    * @return boolean   true if a case contains an Id located in the EmailMessage subject line returns fals otherwise
    */
    public boolean subjectContainsId(EmailMessage email)
    {
        system.debug('-------------SuppliedEmailsCases---------------\n'+suppliedEmails.values()+'\n-------------------------------');
        for(Case c : cases)
        {
            if ( email.Subject.contains(String.valueOf(c.CaseNumber)) )
            {
                system.debug('Found case with Id '+c.CaseNumber);
                  return true;                  
            }
        }
        system.debug('Could not find case with ID '+email.Subject);
        return false; 
    }

 
}