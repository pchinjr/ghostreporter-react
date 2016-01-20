/**
 * This class contains unit tests for validating the behavior of Apex class
 * Sorter.
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
 *
 * @author Mike McGee
 */
@isTest
private class Sorter_Test {

	/**
	 * Sets up data that can be used in all test methods. 
	 * Any data that is changed in one test method will be 
	 * reset to its original data in the next test mehtod. 
	 */
	@testSetup static void setup() {
		//Put in some agent and case objects to be sorted
		List<Agent__c> agentList = new List<Agent__c>(); 
		List<Case> caseList = new List<Case>(); 
		for (integer i = 0; i < 26; ++i) {
			Agent__c tempAgent = new Agent__c();
			tempAgent.Contacts_Per_Day__c = Math.random() * 10;
			tempAgent.Other_Time__c = Math.random() * 10;
			tempAgent.Comments_notFormatted__c = 'Test'; 
			agentList.add(tempAgent);

			List<String> alphaList = new String[]{'a', 'b', 'c', 'd', 'e', 'f', 'g',
			 	'h', 'i', 'j', 'k', 'l', 'm', 'n' , 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};

			Case tempCase = new Case(); 
			tempCase.Hours_Until_InProgress__c = Math.random() * 10; 
			tempCase.Time_With_Customer__c = Math.random() *10; 
			tempCase.Customer_Name__c = alphaList[Math.mod(Math.round(Math.random() *100), 26)];
			caseList.add(tempCase);
		}

		insert caseList; 
		insert agentList;

	}
	
	/**
	 * Tests Sorter given expected input
	 */
	@isTest static void positiveTest() {
		List<Agent__c> unorderdList = [SELECT Contacts_Per_Day__c, Other_Time__c, Id from Agent__c]; 
		List<Case> unorderedCaseList = [SELECT Customer_Name__c from Case];
		List<Agent__c> cpdAscSoql = [SELECT Contacts_Per_Day__c, Other_Time__c, Id from Agent__c ORDER BY Contacts_Per_Day__c ASC]; 
		List<Agent__c> otAscSoql = [SELECT Contacts_Per_Day__c, Other_Time__c, Id from Agent__c ORDER BY Other_Time__c ASC]; 
		List<Agent__c> cpdDescSoql = [SELECT Contacts_Per_Day__c, Other_Time__c, Id from Agent__c ORDER BY Contacts_Per_Day__c DESC]; 
		List<Agent__c> otDescSoql = [SELECT Contacts_Per_Day__c, Other_Time__c, Id from Agent__c ORDER BY Other_Time__c DESC]; 

		Test.startTest();
		//Sort unorderList by contacts per day asc and desc
		List<sObject> cpdAsc = Sorter.sortAsc(unorderdList, 'Contacts_Per_Day__c');
		List<sObject> cpdDesc = Sorter.sortDsc(unorderdList, 'Contacts_Per_Day__c');
		//sort unorderlist by other time asc and desc 
		List<sObject> otAsc = Sorter.sortAsc(unorderdlist, 'Other_Time__c'); 
		List<sObject> otDesc = Sorter.sortDsc(unorderdlist, 'Other_Time__c'); 
		//Sort by alphabet
		List<sObject> alphaSort = Sorter.sortAlpha(unorderedCaseList, 'Customer_Name__c');

		//compare lists
		system.assertEquals(cpdAsc, cpdAscSoql);
		system.assertEquals(cpdDesc, cpdDescSoql);
		system.assertEquals(otAsc, otAscSoql);
		system.assertEquals(otDesc, otDescSoql);

		Test.stopTest();
	}
	
	/**
	 * Tests Sorter given invalid input
	 */
	@isTest static void negativeTest() {
		//Pass empty list to be sorted. 
		List<Agent__c> emptyList = new List<Agent__c>(); 
		List<sObject> noListt = Sorter.sortAsc(emptyList, 'Contacts_Per_Day__c');
		noListt = Sorter.sortDsc(emptyList, 'Contacts_Per_Day__c'); 
		//sort list by a non numerical field with sorter
		List<Agent__c> stringList = [SELECT Comments_notFormatted__c, Contacts_Per_Day__c, Other_Time__c, Id from Agent__c];
		
		//Should throw type exception (only catch that exception)
		try{
			noListt = Sorter.sortAsc(stringList, 'Comments_notFormatted__c');
		} catch (System.TypeException e) {}
		 
	}
	
}