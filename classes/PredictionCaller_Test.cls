/**
 * PredicitonController_Test: Test for PredicitonCaller
 *  
 */

@isTest
global class PredictionCaller_Test {
    
    public PredictionCaller_Test(){
        runPositiveTestCases();
    }
    
	static testMethod void runPositiveTestCases() {              
        
        
       // PredictionCaller.mock = new WebServiceMockImpl();
        PredictionCaller.predictionCall();
        
        String testResponse = '{"access_token" : "ya29.yQAfgx8GxUHetwtPD021O6iZtrhBKAM72z26mV2XtLzLzS3d8pSVwJ7B65-JUzF3rKYN6iPZw9Mfww","token_type" : "Bearer","expires_in" : 3600}';
        String answer = PredictionCaller.parseResponse(testResponse); 
        System.debug(answer);
        System.assertEquals('ya29.yQAfgx8GxUHetwtPD021O6iZtrhBKAM72z26mV2XtLzLzS3d8pSVwJ7B65-JUzF3rKYN6iPZw9Mfww', answer);
        
     /*   String testStrig = '{
                                "kind": "prediction#output",
                                "id": "testModel2",
                                "selfLink": "https://www.googleapis.com/prediction/v1.6/projects/39155115276/trainedmodels/testModel2/predict",
                                "outputLabel": "\"High\"",
                                "outputMulti": [
                                {
                                "label": "\"High\"",
                                "score": "0.250000"
                                },
                                {
                                "label": "\"Extreme\"",
                                "score": "0.250000"
                                },
                                {
                                "label": "\"Low\"",
                                "score": "0.250000"
                                },
                                {
                                "label": "\"Medium\"",
                                "score": "0.250000"
                                }
                                ]
                                }';
        */
        
        String testDescription = '{"kind": "prediction#output","id": "testModel2","selfLink": "https://www.googleapis.com/prediction/v1.6/projects/39155115276/trainedmodels/testModel2/predict","outputLabel": "\\"High\\"","outputMulti": [{"label": "\\"High\\"","score": "0.250000"},{"label": "\\"Extreme\\"","score": "0.250000"},{"label": "\\"Low\\"","score": "0.250000"},{"label": "\\"Medium\\"","score": "0.250000"}]}'; 
        String result = PredictionCaller.parseData(testDescription);
        System.debug(result);
        
        //negative test for parseRespnse
        String negString = PredictionCaller.parseResponse('');
        System.assertEquals(null, negString);
        
        
    }

    
}