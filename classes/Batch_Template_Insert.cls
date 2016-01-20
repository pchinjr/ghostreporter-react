/**
 * Batch Template Class to help you get going
 */
global class Batch_Template_Insert implements Database.Batchable<sObject>{

    private String query; 
    private Integer inserts;
    private  List<AgentRankStarter__c> ars;
    
    public Batch_Template_Insert( List<AgentRankStarter__c> ars )
    {
        this.ars = ars;
        this.inserts = inserts;
        this.query = 'select id from AgentRankStarter__c'; 
    }
    
    // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
     }
    
    //Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        
        
        insert this.ars;
        
        
    }
    
    global void finish(Database.BatchableContext BC){
         // Logic to be Executed at finish
          AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
         
         System.debug('Exited batch job with status of '+ a.Status);
    }
}