/**
 * This class contains unit tests for validating the behavior of Apex class
 * CloseCaseController.
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
private class CloseCaseController_Test {

	/**
	 * Inserts all data needed to properly test.
	 * Set's all data values to their initial configurations.
	 * All values set in this method will persist throughout
	 * all test methods to be executed in the running context. 
	 */
	@testSetup static void setup() {
		// Need a case to test the email off of
		Case testCase = new Case();
		testCase.Subject = 'Test Subject' ;
		testCase.Customer_Name__c = 'Test Customer Name';
		insert testCase;
	}
	

	/**
	 * Tests the controller with expected input
	 */
	@isTest static void positveTest() {
		Case onlyCase = [SELECT Id, CaseNumber FROM Case limit 1];

		// Set the current page to Close case page
		PageReference pref = Page.CloseCaseLayout;

		// Set the retURL and related_case page parameters
		ApexPages.currentPage().getParameters()
				 .put('retURL', String.valueOf(Page.CloseCaseLayout));
		ApexPages.currentPage().getParameters()
				 .put('related_case', String.valueOf(onlyCase.CaseNumber));


		// Instatiate the new controller
		ApexPages.StandardController sc = new ApexPages.StandardController(onlyCase);
		CaseCloseController controller = new CaseCloseController(sc);

		// Set the controller fields
		controller.internalComment = 'Test internal comment';
		controller.relatedCase.Status = 'Closed';

		// Save the case
		controller.save();


	}
	

	/** 
	 * Tests the controller with unexpected or missing input.
	 */
	@isTest static void negativeTest() {
		Case onlyCase = [SELECT Id, CaseNumber FROM Case limit 1];

		// Set the current page to Close case page
		PageReference pref = Page.CloseCaseLayout;

		// Set the retURL and related_case page parameters
		ApexPages.currentPage().getParameters()
				 .put('retURL', String.valueOf(Page.CloseCaseLayout));
		ApexPages.currentPage().getParameters()
				 .put('related_case', String.valueOf(onlyCase.CaseNumber));


		// Instatiate the new controller
		ApexPages.StandardController sc = new ApexPages.StandardController(onlyCase);
		CaseCloseController controller = new CaseCloseController(sc);

		// Save without an internal comment or any changes to the case fields.
		controller.save();


	}


	/**
	 * Tests the cancel funtionality of the controller.
	 */
	@isTest static void cancelTest() {
		Case onlyCase = [SELECT Id, CaseNumber FROM Case limit 1];

		// Set the current page to Close case page
		PageReference pref = Page.CloseCaseLayout;

		// Set the retURL and related_case page parameters
		ApexPages.currentPage().getParameters()
				 .put('retURL', String.valueOf(Page.CloseCaseLayout));
		ApexPages.currentPage().getParameters()
				 .put('related_case', String.valueOf(onlyCase.CaseNumber));


		// Instatiate the new controller
		ApexPages.StandardController sc = new ApexPages.StandardController(onlyCase);
		CaseCloseController controller = new CaseCloseController(sc);

		controller.cancel();
	}
	
}