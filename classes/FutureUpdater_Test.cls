/**
 * This class contains unit tests for validating the behavior of class
 * FutureUpdater
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
private class FutureUpdater_Test {
	
	/**
	 * tests FutureUpdater with expected values. 
	 */
	@isTest static void positiveTest() {
		//Insert object to be tested
		Case randObject = new Case(); 
		randObject.Account_ID__c = 'randId'; 
		insert randObject; 

		//Do a soql to find newly inserted case an
		//assert that the Acoount Id is 'randId'
		Case selectedCase = [SELECT Account_ID__c FROM Case limit 1]; 
		system.assertEquals(selectedCase.Account_ID__c, randObject.Account_ID__c);

		//update the case using future updater must surround future call with startTest() 
		//and stopTest(). This will force the method to execute, so that values can be asserted. 
		selectedCase.Account_ID__c = 'updatedId'; 
		
		Test.startTest(); 
		FutureUpdater.setToUpdate(selectedCase);
		FutureUpdater.updateObject();
		Test.stopTest(); 

		//assert that values were updated. 
		Case updatedCase = [SELECT Account_ID__c FROM Case limit 1];
		system.assertEquals('updatedId', updatedCase.Account_ID__c);

	}


	/**
	 * Tesh method for list test coverage
	 */ 
	static testMethod void listTest() {
		List<Account> oList = new List<Account>();
		for (integer i = 0; i < 100; ++i) {
			oList.add(new Account(Account_ID__c = 'A'+i, Name = 'A'+i));
		}

		insert oList;

		List<Account> sList  = [SELECT Id FROM Account];
		Account raceAccount = [SELECT Account_ID__c, Id FROM Account WHERE Account_ID__c = 'A1'];
		raceAccount.Account_ID__c = 'B';
		update raceAccount;

		FutureUpdater.setListToUpdate(sList);
		FutureUpdater.updateList();
	}

	/**
	 * Tests future updater with null object value. 
	 */
	static testMethod void negativeTest() {
		//attempt to call future updater without setting update value. 
		FutureUpdater.updateObject();

		Case randObject = new Case(); 
		randObject.Account_ID__c = 'randId'; 
		insert randObject; 

		//Do a soql to find newly inserted case an
		//assert that the Acoount Id is 'randId'
		Case selectedCase = [SELECT Account_ID__c FROM Case limit 1]; 
		system.assertEquals(selectedCase.Account_ID__c, randObject.Account_ID__c);

		//update the case using future updater must surround future call with startTest() 
		//and stopTest(). This will force the method to execute, so that values can be asserted. 
		selectedCase.Account_ID__c = 'updatedId'; 
		Test.startTest(); 
		//Query for the object in the middle of the update 
		Case attemptRace = [SELECT  Account_ID__c FROM Case limit 1 FOR UPDATE];
		system.assertEquals('randId', attemptRace.Account_Id__c);
		// Dont use future updater this time
		try {
			update selectedCase;
		} catch (System.DmlException e) {
			system.debug('Worked');
		}
	}


	/**
	 * Atempts to update object while quering for same object.
	 * <p>
	 * Trying to simulate a race condition where a user is updating 
	 * the same object as another agent. 
	 */
	static testMethod void concurentTest() {
		//Insert object to be tested
		Case randObject = new Case(); 
		randObject.Account_ID__c = 'randId'; 
		insert randObject; 

		//Do a soql to find newly inserted case an
		//assert that the Acoount Id is 'randId'
		Case selectedCase = [SELECT Account_ID__c FROM Case limit 1]; 
		system.assertEquals(selectedCase.Account_ID__c, randObject.Account_ID__c);

		//update the case using future updater must surround future call with startTest() 
		//and stopTest(). This will force the method to execute, so that values can be asserted. 
		selectedCase.Account_ID__c = 'updatedId'; 
		Test.startTest(); 
		FutureUpdater.setToUpdate(selectedCase);
		//Query for the object in the middle of the update 
		Case attemptRace = [SELECT  Account_ID__c FROM Case limit 1 FOR UPDATE];
		FutureUpdater.updateObject();
		system.assertEquals('randId', attemptRace.Account_Id__c);


		// Will hopefully unlock row
		attemptRace = null;

		Test.stopTest(); 

		//assert that value was updated properly. 
		Case updatedCase = [SELECT Account_ID__c FROM Case limit 1];
		system.assertEquals('updatedId', updatedCase.Account_ID__c);

	}
	
}