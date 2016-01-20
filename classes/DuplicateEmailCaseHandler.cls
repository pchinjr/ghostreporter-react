public class DuplicateEmailCaseHandler {
  /*
     * Member variables necessary for algorithm
     */
  private static Map<String, Case> suppliedEmails = new Map<String, Case>(); 
    private static List<Id> parentIdList = new List<Id>(); 
    private static List<EmailMessage> toAddComment = new List<EmailMessage>();
    
    //Since this list will get all cases in trigger.new the SuppliedEmail will have to be in the list twice if 
    //there is already a case open for this email. 
    private static List<Case> cases = [SELECT SuppliedEmail, Id, CaseNumber, Subject FROM Case WHERE Origin = 'Email'];
    
    
    
    
    /**
     * Gets all cases that have been created, that should not have been and sets their DuplicateEmail field to true. 
     * <p>
     * Finds duplicate cases by checking for case with same EmailMessage.FromAddress as Case.SuppliedEmail 
     * in list of cases. Then checks the subject line of the EmailMessage the cause trigger for the 
     * case number that matches the case with the matching email address. 
     * Both of these conditions must be met in order for a comment to be added to existing case, otherwise
     * a new case will be created
     * 
     * @author  Mike McGee
     * @param  triggerNew    all EmailMessages that exist including those created that caused trigger
     * @param  triggerContext  the context of the current trigger. 
     */
    public static void getDuplicateCasesGenerated(List<EmailMessage> triggerNew, ContextEnum triggerContext)
    {
        system.debug('CaseList ==== '+cases);
        //Start by putting first case into set. Then continue looping through the set. If you find
        //a case with a supplied email that already exists then a case was already opened for that 
        //email address. Place these emails in a map so that the parentID can be retrieved also later. 
        //Using a set here because it has the contains method
        Set<String> caseHolder = new set<String>();
        for(Case c : cases)
        {
            c.TestedForDuplicate__c = true; 
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
    system.debug('Trigger.new size = '+triggerNew.size()+'In trigger.new '+triggerNew);
        /**
         * If the email.fromAddress is in the supplied email list 
         * than that sender already has a case open and 
         * the TextBody of the email should be appended to its parent case 
         * as a comment. 
         */
        try{
            boolean insertComment = false; 
            CaseComment newComment = new CaseComment();
            
            for(EmailMessage email : triggerNew)
            {
                System.debug('Email that came in sent by '+email.FromAddress
                            +' Checking against '+suppliedEmails.get(email.FromAddress).suppliedEmail);
                
                /**
                 * check if the supplied email is in the supplied email list than a case already exists with that email. 
                 * check if the sunbject of the email contains a case Id and that case Id is the Id of one of the open cases.
                 * both conditions must be true to append a comment, if not then create a new case like normal for the message. 
                 */ 
            
             if(!isNotDupEmail(email)){
                if( (suppliedEmails.get(email.FromAddress) != null) && (subjectContainsId(email) != null) )
                {
                                        
                    
                    Id needsComment = subjectContainsId(email);
                    system.debug('Case already existed ' + needsComment);
                    //add comment to the case. 
                    newComment.CommentBody = 'Email Comment: \n'+email.TextBody;  
                    system.debug('Comment body will be '+ email.TextBody);
                    newComment.IsPublished = true; 
                    newComment.ParentId = needsComment; 
                    //insert newComment;
                    insertComment = true; 
                    
                    //prevent email message from being inserted. 
                    //                    //Delete the new case that was inserted. 
                    Id caseId = email.ParentId; 
                    Case toDelete = [SELECT Id from Case WHERE Id = :caseId];
                    toDelete.DuplicateEmail__c = true;
                    toDelete.TestedForDuplicate__c = true; 
                    update toDelete;  
                    
                    /*//If new case has a higher priority than old case. 
                    //change old case priority to new higher level. 
                    Case originalCase = [SELECT Priority, Id FROM Case WHERE Id = :needsComment];
                    //originalCase.Priority = CaseConsolidator.getPriorityCase(originalCase, toDelete).Priority;
                    originalCase.TestedForDuplicate__c = true;
                    update originalCase; */
                }
             }
            }
            
            //Have to update the case to Have the value of TestedForDuplicate = true. 
            update cases; 
            if (insertComment) {
                insert newComment; 
            }
            
        } catch(NullPointerException e){}
        
    }
    
    
    /**
    * Loops through all emails attached to cases in case list and checks 
    * for a CaseNumber matching the subject line of the new email message, returns true if one is found
    * @author  Mike McGee 
    * @param   email  the message in trigger.new that is being checked for a current open case
    * @return   Id    returns Id of case with case number matching email message subject line. Null if one is not found
    */
    public static Id subjectContainsId(EmailMessage email)
    {
        system.debug('-------------SuppliedEmailsCases---------------\n'+suppliedEmails.values()+'\n-------------------------------');
        for(Case c : cases)
        {
            if ( email.Subject.contains(String.valueOf(c.CaseNumber)) )
            {
                system.debug('Found case with Id '+c.Id);
                  return c.Id;                  
            }
        }
        system.debug('Could not find case with ID '+email.Subject);
        return null; 
    }
    
        public static Boolean isNotDupEmail(EmailMessage email){
        
        if(email.textBody.contains('^'))
          return true;
        else
          return false;
      
        
    }
    
    
    /**
     * Removes all cases with DuplicateEmail flag set to true. Then reshuffles cases
     * <p>
     * Builds list of all case Id in trigger.new. Loops through this list and deletes any case that 
     * has the DuplicateEmail flag set to true. Then uses CaseAllocator class to reshuffle cases. 
     * 
     * @author  Mike McGee
     * @param  triggerNew    list of all EmailMessages including those created that activated trigger
     * @param  triggerContext  current context of the trigger. 
     */ 
    public static void removeDuplicatesAndReshuffle(List<EmailMessage> triggerNew, ContextEnum triggerContext)
    {
        List<Id> parentId = new List<Id>();
        for(EmailMessage email : triggerNew)
        {
            parentId.add(email.ParentId);
        }
        
        //Delete all cases where there was a duplicate email. 
        List<Case> parentList = [SELECT Id, DuplicateEmail__c FROM Case WHERE Id IN :(parentId) AND DuplicateEmail__c = TRUE];
        delete parentList; 
        
        /*for(Case c : parentList)
        {
            if(c.DuplicateEmail__c)
            {
                delete c; 
            }
        } */
       
        //Just need to call reshuffleEamilCases method from caseAllocator 
        Case_Allocator ca = new Case_Allocator();
        ca.reshuffleEmailCases();
    }
}