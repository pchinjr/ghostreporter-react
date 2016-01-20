trigger CaseTest3_Mike on Case (after insert) {
    
    // This set will be needed to check if the "duplicate" is the exact same object
    Set<Id> newlyInsertedIds = new Set<Id>();
    
    // This will be used to check against objects in database.
    Map<String, Case> newlyInsertedAccountIds = new Map<String, Case>();
    
    //Add new ID's and account_id's to sets. 
    for (Case newCase: Trigger.new) {
        newlyInsertedIds.add(newCase.Id);
        newlyInsertedAccountIds.put(newCase.Account_ID__c, newCase);
    }
    
    // Now select all cases that are currently in the db who's account Id's
    // Are also in the newlyInsertedAccountIds set, but are not the exact same 
    // object
    List<Case> duplicateList = [SELECT Id, Account_ID__c FROM Case 
                                WHERE Account_Id__c IN :newlyInsertedAccountIds.keySet() 
                                AND Id NOT IN :newlyInsertedIds];
    // This list should now include all cases that have the same Account_Id but
    // are not the exact same object.
    
    //List to hold the cases that will be marked system cancelled.
    List<Case> consolidatedCases = new List<Case>();
    
    // Now we can loop through duplicateList perform logic
    for (Case c: duplicateList) {
        // Each of the cases in this list should be a duplicate.
        Case duplicateCase = newlyInsertedAccountIds.get(c.Account_ID__c);
        // Perform logic on duplicate case and c
        c.Description += duplicateCase.Description;
        duplicateCase.Status = 'System Cancelled';
        
        //Probably need to add duplicateCase to list in order for changes to 
        //take effect. 
        consolidatedCases.add(duplicateCase);
    }
    
    
    // Perform updates here.
    update duplicateList;
    update consolidatedCases;
}