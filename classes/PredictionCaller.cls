/**
 * PredictionCaller: sends all unanlyzed cases to be analyzed by the google prediciton api.
 * Uses Http requests to do this. 
 * main run method should be marked @future (unmarked for testing)
 * @Author Mike McGee 
 */
global class PredictionCaller {
    //for testing purposes 
    public static WebServiceMock mock = null;
 	
    //Constants (Must obtain from Google developer console)
    private static final String CLIENT_SECRET = 'rR_fhCdwOioZhzPHd4D920Jp';
    private static final String REFRESH_TOKEN = '1/EN-o1McHJ43d96sYpqozEr9AOALI6zeQrYFzk93-KskMEudVrK5jSpoR30zcRFq6';
    private static final String CLIENT_ID = '458913242271-am6t00t5f7u5v379lebvhl2ldhiopb4e.apps.googleusercontent.com';
    private static final String API_KEY = 'AIzaSyBMpcQUAjTh9Uxfvuy5mI4XdT94116b4Ik';
    private static final String SCOPE = 'https://www.googleapis.com/auth/prediction';
   	//URL used to score cases.  Change name from practiceModel1 to whatever model is used.
    //public static final String url = 'https://www.googleapis.com/prediction/v1.6/projects/458913242271/trainedmodels/formattedSentiment/predict';
    private static final String url = 'https://www.googleapis.com/prediction/v1.6/projects/458913242271/trainedmodels/mikesModel/predict?key='+API_KEY;
    //Can use API explorer to train models http://developers.google.com/apis-explorer/?&_ga=1.167007736.795360099.1426169337#p/prediction/v1.6/
    
    //String that will be used for prediction access 
    public static String predicitonToken; 
    
    /**
     * Does the bulk of the work, sends Http Requests for a new access token
     * then sends an Http request for every case to google prediciton api using description as body.
     * 
     */ 
	@future (callout=true) //comment out when testing
    public static void predictionCall()
    { 
         List<Case> casesToAnalyze = [SELECT Description, Id FROM Case WHERE isAnalyzed__c = null];  
         //List<Case> casesToAnalyze = [SELECT Description, Note_Type__c, Id FROM Case where Id = :'500e0000005wJlgAAE'];     
         /*List<Case> casesToAnalyze = [SELECT Description, Id FROM Case WHERE isAnalyzed__c = null AND Status != 'Closed'
                                     AND Status != 'Resolved' AND Status != 'Cancelled' AND Status != 'Prevented'];*/
        
        /*If error during refresh of token is invalid_grant must go to https://developers.google.com/oauthplayground/
		 *in order to manually obtain new refresh token
		 */
        getPredictionToken();
        
        /**
         * If size of casesToAnalyze list is bigger than 200 it will cause governeor limits 
         * to hit. Use batch apex in that case. If not score normally. 
         */
        if(casesToAnalyze.size() > 99)
        {
            startBatchPreditcion(); 
        }
        else {
            //Score all cases in list. 
            system.debug('Scoring cases');
        	scoreCases(casesToAnalyze);
        }
        
        System.debug('inside predicitonCall...');
		System.debug('List of cases: '+ casesToAnalyze);
        
        
    } 
    
    public static void startBatchPreditcion() {
        //send to batch class. 
        String query = 'SELECT Id, Description FROM Case WHERE isAnalyzed__c = null';
        Id batchInstanceId = Database.executeBatch(new PredictionCaller_Batch(query));
    }
    
    /**
     * Uses permanant refresh token to get session token from google.
     *  
     * <p> Uses HTTP requests to obtain token form google. Refresh token should always work. 
     *	   but can be revoked on the Google developer console. 
     * 
     * @author Mike McGee 
     */
    public static void getPredictionToken(){
        
        /* Send http request for new access token
         * 
         * //Refresh token (Never expires): 1/wykkwojkxb1enNVKuxOtENMivaob0IViRvvHwyPAGx590RDknAdJa_sgfheVM0XT
         * 
         */ 
        Http start = new Http();
        HttpRequest refresh = new HttpRequest();
        refresh.setMethod('POST'); 
        //refresh.setEndpoint('https://accounts.google.com/o/oauth2/token'); //must set authorized endpoints in salesforce
        refresh.setEndpoint('https://www.googleapis.com/oauth2/v3/token'); //must set authorized endpoints in salesforce
        refresh.setHeader('Host', 'www.googleapis.com');
        refresh.setHeader('Content-type', 'application/x-www-form-urlencoded');
        //body: client_secret=************&grant_type=refresh_token&refresh_token=1%2FcpB9OhT0bEBDCpYwraA9cnlVViO9b8tuPUVVssq7S5o&client_id=407408718192.apps.googleusercontent.com
        String refreshBody = 'client_secret='+CLIENT_SECRET+'&grant_type=refresh_token&refresh_token='+REFRESH_TOKEN+'&client_id='+CLIENT_ID;
        //String refreshBody = 'client_secret=lAMVZCk195QV4QQmA2xrMcCy&grant_type=refresh_token&refresh_token=1%2Fvk8hY1OYBUaHxpe1Npk1LqoXOInCLNfy7nSExZ9SRVY&client_id=39155115276-k3lkg04usma17a79o0a5cc7t4se2uhdu.apps.googleusercontent.com';
        refresh.setBody(refreshBody);
        //System.debug(refresh.getBody());
            
        try{
            HttpResponse token = new HttpResponse(); 
            //token.setHeader('Content-type', 'application/x-www-form-urlencoded'); 
            if (Test.isRunningTest() && (mock!=null)) {
                System.debug('Test is running');
                //casesToAnalyze.add(new Case(Description = 'This is a test description for test cases'));
                    
            }
            else{
                token = start.send(refresh);
                
                
                //handle response 
                //Helpful debug messages
                System.debug(token.toString());
                System.debug('STATUS:'+token.getStatus());
                System.debug('STATUS_CODE:'+token.getStatusCode());
                System.debug(token.getBody());
                    
                //get access token from respnse body
                predicitonToken = parseResponse(token.getBody());
             }
         }
         catch (System.CalloutException e){
             System.debug(e);
         }
            
    }
    
    /**
     * Scores all cases in passed in list using Google prediiction API. 
     * 
     * <p> a trained model is needed in order to score the cases.
     * 	   If a case comes in that has already been scored this will 
     * 	   overwrite the previous score. 
     * 
     * @author Mike McGee
     * @param	casesToAnalyze cases that need to be scored. 
     */
    public static void scoreCases(List<Case> casesToAnalyze)
    {
        /*
         * Send descriptions to be analyzed
         * 
         */

        
        //Analyze every case that is in the list 
        for(Case c : casesToAnalyze)
        {
            if(c.Description == null) continue; //Don't want to pass an empty description to api
            System.debug('Entered for loop');
            
            //label that is returned by api 
            String googLabel; 
            
            //System.debug('Description: '+c.Description);
            //for testing pupses add "note type" and "sentiment word"
            String noteType = c.Note_Type__c, sentimentWord = getSentimentWord(c.Affective_Words__c), testDesc = 'Testing the prediciton model';
            if (noteType == null ) {
                noteType = 'MISC';
            }
            String testBody = '{"input":{ "csvInstance":['+'\''+noteType+'\','+'\''+c.Description+'\','+'\''+sentimentWord+'\''+']}}';
        	String body = '{"input":{ "csvInstance":[\''+ c.Description +'\' ]}}';

            system.debug('Test Body = : '+testBody);
            
           	Http h = new Http(); 
            HttpRequest req = new HttpRequest(); 
            req.setEndpoint(url);
            req.setMethod('POST');
            
            
            //Use this to request a token form header lilke the one below
            //Authorization: Bearer ya29.uwD9GB4iWWa6A0TgOejlabvV2iAuTjvmrRKscVn9weNAj2kpA2eGK8-1sBIjIibng6Vcy1eHRLz8-w
            req.setHeader('Authorization', 'Bearer '+predicitonToken);
            //req.setHeader('Authorization', 'Bearer ya29.OAEykNwsCiaYDoSy5fmm85JY_pjUdLR77apw8_2SkeQyUJOZ23LwZxpjreHMn_OXuXxRRdTqzVyPYA');
            req.setHeader('Content-type', 'application/json');
            req.setBody(body);
            //req.setBody(testBody);
            
            try {
                
                if (Test.isRunningTest() && (mock!=null)) {
                	System.debug('Test is running');
        		}
                else{                
                    //Execute web service call here      
                    HTTPResponse res = h.send(req);   
             
                    //Helpful debug messages
                    System.debug(req.getBody());
                    System.debug(res.toString());
                    System.debug('STATUS:'+res.getStatus());
                    System.debug('STATUS_CODE:'+res.getStatusCode());
                    System.debug(res.getHeaderKeys());
                    System.debug(res.getBody());
                    //get label from response 
                    googLabel = parseData(res.getBody());
                }   
	 		} catch(System.CalloutException e) {
	        	//Exception handling goes here....
	        	System.debug(e);
	 		} 
            
            
            //update case 
            System.debug('Label that should be applied to case: '+googLabel);
            c.GoogleLabel__c = googLabel; 
            c.isAnalyzed__c = true; 
        }
        
       
        
        if(Test.isRunningTest() && (mock!=null)){
                System.debug('Still running test Case');
     	}
        else {
             update casesToAnalyze;
            
            /*
             * Send updated list of cases to controller class to 
             * so that the cases can be reorganized accordingly
             */
            PredictionController.organizeCases(casesToAnalyze); 
        }
        
        System.debug('exiting predicitonCall...'); 
    }
    
    
    /**
     * Retieves access token from refresh token respose 
     * @params: String returned from refresh method
     * @returns: String that can be used as access token
     */
    public static String parseResponse(String response){
        JSONParser parser = JSON.createParser(response);
        String accessToken;
        
        while(parser.nextToken() != null)
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'access_token')){
                    parser.nextToken();
                    accessToken = parser.getText();
                    System.debug('token: ' + accessToken);
                    return accessToken;
                }
        }
        
         return null; 
    }
    
    /**
     * Pulls output label from description analysis response 
     * @params: Sting Body that was returned from http response
     * @return	google label that was returned from http call. 	
     * 
     */
    public static String parseData(String description)
    {
     	JSONParser parser = JSON.createParser(description);
        parser.nextToken(); //Starts on null so must advance one before entering while loop 
    	String label; 
        
        System.debug(description);
        while(parser.nextToken() != null)
        { 
            //This will get the output label
            if(parser.getCurrentToken() != null && parser.getText()== 'outputLabel')
            {
                parser.nextToken();
                label = parser.getText();
                System.debug('Output Label = '+ label);
            }
            
            //This will get all of the labels
            if(parser.getCurrentToken() != null && parser.getText() == 'label')
            {
                parser.nextToken();
                for(Integer i = 0; i < 3; i++){
                    System.debug(parser.getText());
                    parser.nextToken();
                }
            }
        }
        
        return label;    
   	}
    
    /**
     * Returns the first word in the list of affective words. 
     * @param	affectiveWords	List of words
     * @return	first string in list
     */
    public static String getSentimentWord (String affectiveWords) {
        affectiveWords = affectiveWords.toLowerCase(); 
        if (affectiveWords.contains('upset')) {
            return 'Upset';
        } else if (affectiveWords.contains('irate')) {
            return 'Irate';
        } else if (affectiveWords.contains('error')) {
            return 'Error'; 
        } else if (affectiveWords.contains('channel')) {
            return 'Channel';
        } else if (affectiveWords.contains('angry')) {
            return 'Angry'; 
        } else {
            return ''; 
        }
    }
     
}