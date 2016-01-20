global class AgentRankerBatch implements Database.Batchable<sObject> {

    private String query; 
    
    public AgentRankerBatch(String query) {
        this.query = query; 
    }
    
    // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
     }
    
    //Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope) {
    	List<Agent__c> agentList = new List<Agent__c>(); 
    	for (sObject s: scope) {
    		agentList.add((Agent__c) s); 
    	}
    	
    	/*for (Agent__c a: agentList) {
    		AgentRanker ranker = new AgentRanker(a); 
            ranker.rankStats();
    	}*/
    }
    
    global void finish(Database.BatchableContext BC) {
         // Logic to be Executed at finish
          AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
         
         System.debug('Exited batch job with status of '+ a.Status);
    }

}