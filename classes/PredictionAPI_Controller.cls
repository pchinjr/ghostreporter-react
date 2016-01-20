public with sharing class PredictionAPI_Controller {
	
	public List<String> sentiments {get; set;}
	public String Sent_Description {get; set;}
	public String Sent_Analysis {get; set;}
	
	public PredictionAPI_Controller() {
		//constructor
		sentiments = new List<String>();

		List<Sentiment__c> sentiment_Objs = [select Id, Description__c from Sentiment__c where isAnalyzed__c = false];
		
		for (Sentiment__c iter: sentiment_Objs) {
			sentiments.add('\''+iter.Description__c+'\'');
		}
		
	}
	 
	public void Sentiment_Update() {
		
		// Sent_Description contains the note/description of the report
		// Sent_Analysis contains the analysis returned from the Google Prediction API
		//System.debug(Sent_Analysis);
		//System.debug(Sent_Description);
		
		// Find the particular sentiment object this description came from
		try {
			Sentiment__c sentiment = [select Id, Description__c, Analysis__c, isAnalyzed__c from Sentiment__c where Description__c = :Sent_Description limit 1];
			
			// Update the sentiment with the analysis and set isAnalyzed to true
			sentiment.Analysis__c = Sent_Analysis;
			sentiment.isAnalyzed__c = true;
			
			update sentiment;
			
		} catch(QueryException e) {
			// no sentiment found
			System.debug('Nothing found');
		}
		
	}
	public void Sentiment_Description_Update() {
		
	}
}