/**
 * Batch Class for CaseConsolidator Used to consolidate all current cases
 */
global class CaseConsolidator_Batch implements Database.Batchable<sObject>{

    private String query; 
    
    public CaseConsolidator_Batch(String query)
    {
        this.query = query; 
    }
    
    // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
     }
    
    //Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope)
    {
        //cast all sOjbects in scope to cases in order to consolidate. 
        List<Case> caseList = new List<Case>();
        for(sObject s : scope)
        {
            caseList.add((Case)s);
        }
        
        //remove all cases where is origin is email here in order to 
        //not send them in to be tested.
        for (integer i = 0; i < caseList.size(); i++) {
            if ((caseList[i].origin == 'Email') || (caseList[i].Account_ID__c == null)) {
                caseList.remove(i);
            }
        }
        
        boolean isBatch = true;  
        //Use the isIdTested to avoid sending in the cases with the same AccountID more than once.
        Map<String, boolean> isIdTested = new Map<String, boolean>(); 
        for (Case c : caseList) {
            system.debug('Status : '+c.Status+' Origin '+c.Origin);
            if ( (c.Status == 'Unassigned') && (c.origin != 'Email') && ( isIdTested.get(c.Account_ID__c) == null ) && (c.Account_ID__c != null) ) {
                isIdTested.put(c.Account_ID__c, true); 
                isIdTested.put(c.casenumber, true); 
                system.debug('Case will be consolidated');
                new CaseConsolidator(c, isBatch);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
         // Logic to be Executed at finish
          AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
         
         System.debug('Exited batch job with status of '+ a.Status);
    }
}