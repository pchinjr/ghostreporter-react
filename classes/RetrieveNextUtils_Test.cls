/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RetrieveNextUtils_Test {

	/**
	 * testCaseByPriority
	 * Test Objective:  To test that the RetrieveNextUtils class can find an unassigned Case of low priority.
	 * Test Description: Tests that retrieveNextCase function in RetrieveNextUtils can return a low priority Case.
	 * Test Conditions: Create one unassigned Case with its priority set to low. Insert the Case into the database. Call the retrieveNextCase function and store the returned Case in a temporary storage object.
	 * Expected Results: The temporary object should be the same as the Case that was inserted.
	 * @author: Matthew Bald
	 */
    static testMethod void testCaseByPriority() {
        String userid = [select id from user where name = 'Alex Rivera'].id;
        System.debug('User Id is: '+userid);
        Case testCase = new Case(description = 'nononull', priority = 'Low', status = 'Unassigned');
        testCase.Status = 'Unassigned';
        testCase.priority = 'Low';
        testCase.description = 'bad null';
        testCase.account_id__c = '123333';
        testCase.ownerid = userid;

		
		System.Test.startTest();
		
	 		insert testCase;
		
		System.Test.stopTest();
		
		testCase = [select Id, CaseNumber from Case where account_id__c = '123333'];
		Id testId = RetrieveNextUtils.retrieveNextCase(userid, testCase.CaseNumber);
		System.debug('testid:'+ testId + ', testCase.id:' + testCase.id);
		System.assertEquals(testId, testCase.Id);
		
    }
    
    /**
     * testCaseByPriorityMed
	 * Test Objective:  To test that the RetrieveNextUtils class can find an unassigned Case of medium priority.
 	 * Test Description: Tests that retrieveNextCase function in RetrieveNextUtils can return a medium priority Case.
	 * Test Conditions: Create one unassigned Case with its priority set to medium. Insert the Case into the database. Call the retrieveNextCase function and store the returned Case in a temporary storage object.
	 * Expected Results: The temporary object should be the same as the Case that was inserted.
     @ author: Matthew Bald
     */
    static testMethod void testCaseByPriorityMed() {
        String userid = [select id from user where name = 'Alex Rivera'].id;
        
        Case testCase = new Case(description = 'nononull', priority = 'Medium', status = 'Unassigned');
        testCase.ownerid = userid;
		      testCase.account_id__c = '123333';
		System.Test.startTest();
		
		insert testCase;
		
		System.Test.stopTest();
		
		testCase = [select Id, CaseNumber from Case];
		Id testId = RetrieveNextUtils.retrieveNextCase(userid, testCase.CaseNumber);
		
		System.assertEquals(testId, testCase.Id);
		
    }
    
    /**
     * testCaseByPriorityHigh
	 * Test Objective:  To test that the RetrieveNextUtils class can find an unassigned Case of high priority.
	 * Test Description: Tests that retrieveNextCase function in RetrieveNextUtils can return a high priority Case.
	 * Test Conditions: Create one unassigned Case with its priority set to high. Insert the Case into the database. Call the retrieveNextCase function and store the returned Case in a temporary storage object.
	 * Expected Results: The temporary object should be the same as the Case that was inserted.
     * author: Matthew Bald
     */    
    static testMethod void testCaseByPriorityHigh() {
        String userid = [select id from user where name = 'Alex Rivera'].id;
         
        Case testCase = new Case(description = 'nononull', priority = 'High', status = 'Unassigned');
        testCase.ownerid = userid;
		System.Test.startTest();
		
		insert testCase;
		
		System.Test.stopTest();
		
		testCase = [select Id, CaseNumber from Case];
		Id testId = RetrieveNextUtils.retrieveNextCase(userid, testCase.CaseNumber);
		
		System.assertEquals(testId, testCase.Id);
		
    }
    
    /**
     * testCaseByPriorityNull
 	 * Test Objective:  To test that the RetrieveNextUtils class will return null when there are no unassigned cases left.
 	 * Test Description: Tests that retrieveNextCase function in RetrieveNextUtils returns null when no cases are unassigned.
 	 * Test Conditions: Create one unassigned Case with its status set to ‘In Progress.’ Insert the Case into the database. Call the retrieveNextCase function and store the returned Case in a temporary storage object.
 	 * Expected Results: The function should return null.
     * author: Matthew Bald
     */
    static testMethod void testCaseByPriorityNull() {
		Case testCase = TestDataFactory.createOneParentObject();
        testCase.Status = 'In Progress';
        testCase.priority = 'High';
		testCase.description = 'nonononnull';
		System.Test.startTest();
		
		insert testCase;
		
		System.Test.stopTest();
		
		testCase = [select Id, CaseNumber from Case];
		Id testId = RetrieveNextUtils.retrieveNextCase('', testCase.CaseNumber);
		
		System.assertEquals(testId, null);
		
    }  
}