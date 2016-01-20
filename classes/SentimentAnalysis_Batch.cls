global class SentimentAnalysis_Batch implements Database.Batchable<sObject>{
	
    public String query;
    public Map<String, double> valueMap; 
    
    global SentimentAnalysis_Batch(String query, Map<String, double> valueMap){
     	// Batch Constructor
        this.query = query;
        this.valueMap = valueMap; 
     }
     
     // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
     	return Database.getQueryLocator(query);
     }
    
   // Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope){
    	// Logic to be Executed batch wise
        SentimentAnalysis_B analyzer = new SentimentAnalysis_B();
		analyzer.mapBuilder2();  
        
        List<Case> caseList = new List<Case>();
        
   		for(sObject c : scope)
        {
			Map<String, double> affectiveWordMap = new Map<String, double>();

            Case curCase = (Case)c;
            double score = analyzer.scoreTextWithMap(curCase.Description, affectiveWordMap);
            system.debug('Score for case: '+curCase.Id+' = '+score);
            //add score to case or move case based on level of score 
            curCase.SentimentScore__c = score; 
            curCase.isAnalyzed__c = true; 
            
            caseList.add(curCase);
            
            //Build string of affective words to add to AffectiveWords__c
                String affective = ''; 
                for(String word : affectiveWordMap.keySet())
                {
                    String temp = '"' + word + ' , ' + affectiveWordMap.get(word)+'"'; 
                    affective += temp;
                    
                }
                
                curCase.Affective_Words__c = affective;
        }			
        try{
           update caseList; 
        }catch(SObjectException e){}
         
    }
   
    global void finish(Database.BatchableContext BC){
         // Logic to be Executed at finish
          AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      						TotalJobItems, CreatedBy.Email
      						FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
         
         System.debug('Exited batch job with status of '+ a.Status);
    }
    
}