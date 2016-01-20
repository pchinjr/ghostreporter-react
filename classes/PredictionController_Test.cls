@isTest
public class PredictionController_Test {
	static testMethod void runPositiveTestCases()
    {
        //single case test 
        List<Case> casesTobeTested = new List<Case>();
        casesTobeTested.add(new case(GoogleLabel__c = '"Medium"'));
        PredictionController.organizeCases(casesTobeTested); 
        
        //bulk cases 
        List<case> testCases = new List<case>();
        String[] levels = new String[4]; levels[0] = '"Low"'; levels[1] = '"Medium"'; levels[2] = '"High"';  levels[3] = '"Extreme"';
        for(Integer i = 0; i < 200; i++)
        {
           testCases.add(new case(GoogleLabel__c = levels[(Math.mod(i, levels.size()))])); 
        }
        PredictionController.organizeCases(testCases);
    }
}