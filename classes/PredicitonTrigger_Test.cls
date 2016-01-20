@isTest
public class PredicitonTrigger_Test {
	static testMethod void runTest()
    {
        Case testCase = new Case(Description = 'Test description for the test of the trigger'); 
        insert testCase; 
        
        if(testCase.isAnalyzed__c == true){
            System.debug('True');
        }
        else 
            System.debug('False');
    }
}