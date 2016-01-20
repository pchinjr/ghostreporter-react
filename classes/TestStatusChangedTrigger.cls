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
private class TestStatusChangedTrigger {
	
	/**
	 * TestStatusChanged
	 * Test Objective:  Test the statusChangeHistory trigger.
	 * Test Description: To test that the StatusChangeHistory trigger adds a Status object to the database when a Case status is updated.
 	 * Test Conditions: Create a Case object and insert it into the database. Modify the Case object’s status and update the object in the database.
 	 * Expected Results: There should be a Status object in the database.
	 * author: Matthew Bald
	 */
	static testmethod void TestStatusChanged() {
		
		Case testParent = TestDataFactory.createOneParentObject();
		
		insert testParent;
		
		testParent.Status = 'modified';
		
		System.Test.startTest();
		
		update testParent;
		
		System.Test.stopTest();
		
		//testParent = [select Id, Status from Case where Status = 'modified'];
		try {
			Status__c testStatus = [select Id from Status__c];
			System.assert(true);
		}
		catch (System.QueryException e) {
			System.assert(false);
		}
		//System.assertEquals(testParent.Status, 'modified');
		
	}
	
	/**
	 * TestUpdatedlmod
	 * Test Objective:  Test the statusChangeHistory trigger.
	 * Test Description: To test that the StatusChangeHistory trigger adds a Status object, which holds the same lmod value as the parent Case object, to the database when a Case status is updated.
	 * Test Conditions: Create a Case object and a status object then insert them into the database. Modify the Case object’s status and update the object in the database.
	 * Expected Results: There should be a second Status object in the database with an lmod value equal to the parent Case’s value. 
	 * @author: Matthew Bald	 
	 */
	static testmethod void TestUpdatedlmod() {
		
		Case testParent = TestDataFactory.createOneParentObject();
		
		insert testParent;
	 
		List<Status__c> status2 = null;
	 
		testParent.Status = 'modified';
		
	 	System.Test.startTest();
	 	
	 	update testParent;
	 	
	 	System.Test.stopTest();
	 	
		// grab the list of statuses, should have another from trigger 
		status2 = [select Id, lmod__c, createDT__c, Status__c from Status__c];
		testParent = [select Id, LastModifiedDate from Case];
		// confirm the status is updated
		System.assertEquals(testParent.LastModifiedDate, status2.get(0).lmod__c);
	}
	
	/**
	 * TestUpdatedCreateDT
	 * Test Objective:  Test the statusChangeHistory trigger.
	 * Test Description: To test that the StatusChangeHistory trigger adds a Status object, which holds a Creation Date that is generated from the current time.
	 * Test Conditions: Create a Case object and a status object then insert them into the database. Modify the Case object’s status and update the Case object in the database.
	 * Expected Results: There should be a second Status object in the database with a CreateDT value that is different from the previous Status object.
	 * author: Matthew Bald
	 */
	static testmethod void TestUpdatedCreateDT() {
		
		Case testParent = TestDataFactory.createOneParentObject();
		Status__c testStatus = TestDataFactory.createOneStatus2Object(testParent);
		
		insert testParent;
		insert testStatus;
		
		List<Status__c> status2 = null;
	 	
		testParent.Status = 'modified';
		
		for (Integer i = 1000000; i > 0; i--) { /* force time to pass with a long delay loop */ }
		
	 	System.Test.startTest();
	 	
	 	update testParent;
	 	
	 	System.Test.stopTest();
	 	
		// grab the list of statuses, should have another from trigger 
		status2 = [select Id, lmod__c, createDT__c, Status__c from Status__c];
		
		// confirm the status is updated
		System.assertNotEquals(status2.get(0).CreateDT__c, status2.get(1).CreateDT__c);
	}
}