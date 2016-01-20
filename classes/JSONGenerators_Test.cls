/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class JSONGenerators_Test {

	static testMethod void testDashGenerator() {
		
		List<String> Priorities = new List<String> { 'Low', 'Medium', 'High' };
		List<String> Statuses = new List<String> {'In Progress', 'Unassigned', 'Promoted' };
		List<Case> caseList = new List<Case>();
		
		for (Integer i = 0; i < Priorities.size(); i++) {
			for (Integer j = 0; j < Statuses.size(); j++) {
				Case testCase = new Case();
				testCase.Priority = Priorities.get(i);
				testCase.Status = Statuses.get(j);
				caseList.add(testCase);
			}	
		}
		
		System.test.startTest();
		insert caseList;
		System.test.stopTest();
		
		Dash_JSON_Generator dJG = new Dash_JSON_Generator();
		
		String testString = dJG.gen_Dash_JSON_Pivoted();
		
		if (testString == null) 
			System.assert(false);
			
		else System.assert(true);
	}

	static testMethod void testCaseGenerator() {
		Case testCase = new Case();
		
		Case testCase2 = new Case();
		testCase.Priority = 'low';
		testCase.Status = 'Unassigned';
		testCase.CRDate__c = Date.today();
		testCase.Customer_Name__c = 'test';
		testCase.Note_Type__c = 'test';
		testCase.Origin = 'Sentiment';
		testCase.Source__c = 'test';
		testCase.CC_ID__c = 'test';
		testCase.Description = 'test';
		testCase.Case_Age_In_Business_Hours__c = 24;
		testCase.Account_ID__c = '100';
		
		System.test.startTest();
		insert testCase;
		insert testCase2;
		System.test.stopTest();
		
		Case_JSON_Generator cJG = new Case_JSON_Generator();
		String testString = cJG.gen_JSON();
	
		if (testString == null) 
			System.assert(false);
			
		else System.assert(true);
		
	}

    static testMethod void testActivitiesGenerator() {
    	Event testEvent = new Event();
    	testEvent.Subject = 'Call';
		testEvent.ActivityDateTime = DateTime.now();
		testEvent.DurationInMinutes = 10;
	
        Event testEvent2 = new Event();
		testEvent2.ActivityDateTime = DateTime.now();
		testEvent2.Location = 'test';
		testEvent2.Subject = 'Call';
		testEvent2.Description = 'test';
		testEvent2.Type = 'test';
		testEvent2.DurationInMinutes = 10;
		
		Task testTask = new Task();
		testTask.Subject = 'Call';
		testTask.ActivityDate = Date.today();
		
        Task testTask2 = new Task();
		testTask2.ActivityDate = Date.today();
		testTask2.Subject = 'Call';
		testTask2.Description = 'test';
		testTask2.Priority = 'test';
		testTask2.Status = 'test';
		testTask2.Type = 'test';
		
		System.test.startTest();
		insert testTask;
		insert testTask2;
		insert testEvent;
		insert testEvent2;
		System.test.stopTest();
        
        Activities_JSON_Generator aJG = new Activities_JSON_Generator();
        
        String testString = aJG.retrieveActivitiesData();
        
        if (testString == null)
        	System.assert(false);
        	
        else System.assert(true);
    }

	
}