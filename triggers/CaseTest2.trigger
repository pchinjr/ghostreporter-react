//Use-case: A new case is generated for a contact with an active case.
//          The new case should be cancelled and the description of the
//          new cases added as a note to the original active case.

//Todo: find dup customer case, add task to existing case owner
//      escalate priority of original active case to high


trigger CaseTest2 on Case (before insert) {
    
    Set<String> accountKeys = new Set<String>();
    Set<String> caseKeysDups = new Set<String>();
    
    for(Case c: trigger.new){
        accountKeys.add(c.account_id__c);
    }
    
    
  //Get first active case
    List<Case> ucase = [select id, ownerid, account_id__c, status, contactId, description, createddate 
                        from case where status = 'In Progress'   
                        and account_id__c in :accountKeys order by createddate asc];
   for(Integer x = 0; x < trigger.new.size(); x++){ 
         for(Integer y = 0; y < ucase.size(); y++){
             
             
             
             
         }
    
    }

}