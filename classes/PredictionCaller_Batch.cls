/**
 * Batch class for prediciton caller
 * Used when cases to be analyzed exceeds 200
 * @author Mike McGee
 */
global class PredictionCaller_Batch implements Database.Batchable<sObject>{
	
    public String query; 
    
    public PredictionCaller_Batch(String query)
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
        //cast all sOjbects in scope to cases in order to score with PredicitonCaller. 
        List<Case> caseList = new List<Case>();
        for(sObject s : scope)
        {
            caseList.add((Case)s);
        }
        
        //Remove is analyzed cases from list to be scored. 
        for (integer i = 0; i < caseList.size(); i++) {
            if (caseList[i].isAnalyzed__c == true) {
                caseList.remove(i); 
            }
        }
        
        //Static variable should last for entire run context
        if (PredictionCaller.predicitonToken == null) {
            PredictionCaller.getPredictionToken();
        }
        PredictionCaller.scoreCases(caseList);
    }
    
    global void finish(Database.BatchableContext BC){
         // Logic to be Executed at finish
          AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      						TotalJobItems, CreatedBy.Email
      						FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
         
         System.debug('Exited batch job with status of '+ a.Status);
    }
}