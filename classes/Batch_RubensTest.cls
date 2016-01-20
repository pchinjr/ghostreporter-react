/**
 * Batch Class for CaseConsolidator Used to consolidate all current cases
 */
global class Batch_RubensTest implements Database.Batchable<sObject>{

    private String query; 
    
    public Batch_RubensTest(String query)
    {
        this.query = query; 
    }
    
    // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
     }
    
    //Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        //cast all sOjbects in scope to cases in order to consolidate. 
        List<AgentRankStarter__c> ars = new List<AgentRankStarter__c>();
        
        //Casting all sobjects to AgentRankStarter__c
        for(sObject s : scope){
            ars.add((AgentRankStarter__c)s);
        }
        
        //Now we can do something
        for(Integer x=0; x < scope.size(); x++){
            ars[x].rankkey__c = x + '44443';
            
        }
        
        update ars;
    }
    
    global void finish(Database.BatchableContext BC){
         // Logic to be Executed at finish
          AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
         
         System.debug('Exited batch job with status of '+ a.Status);
    }
}