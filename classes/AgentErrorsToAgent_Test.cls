/**
 * This class contains unit tests for validating the behavior of the private 
 * method 
 * transferErrorScoresToStatsObj() contained in AgentErrorsTriggerHandler
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
 * Test class for private method on AgentErrprsTriggerHanlder.
 * The test class will 
 * <ul>
 * 	<li> Create an Agent Errors object with the necessary values set
 *  <li> Assert that a matching Agent__c object exists with corresponding
 *    	 Quality_Email_Percent and Quality_Error_Rate fiedls.
 *  <li> Update that object 
 *  <li> Delete that object.
 * </ul>
 * 
 */
@isTest
private class AgentErrorsToAgent_Test {
	
	/**
	 * Inserts all data needed to properly test.
	 * Set's all data values to their initial configurations.
	 * All values set in this method will persist throughout
	 * all test methods to be executed in the running context. 
	 */
	@testSetup static void setup() {
		
	}


	@isTest static void positiveTest() {
		// Willbe only one AgentTeam object in DB
		AgentTeam__c aTeam = new AgentTeam__c();
		aTeam.PSERMID__c = '12345';
		insert aTeam;
		System.assertEquals('12345', aTeam.PSERMID__c);
		// Create a new Agent Errors Object
		AgentErrors__c errObj = new AgentErrors__c();
		errObj.Date__c = Date.today();
		errObj.TotalServiceOrders__c = 22;
		errObj.Agent__c = aTeam.Id;
		errObj.AllSasNotSelect__c = 1;
		errObj.ATO__c = 1;
		errObj.FaMisc__c = 1;
		errObj.Deposit__c = 1;
		errObj.MailingAddress__c = 1;
		errObj.Misc__c = 1;
		errObj.PayPlan__c = 1;
		errObj.NoConnectionCharge__c = 1;
		errObj.SelectedTooManySAS__c = 1;
		errObj.WrongAddress__c = 1;
		errObj.WrongSA__c = 1;
		errObj.Email_Salutation__c = 1;
		errObj.Email_Paragraph__c = 1;
		errObj.Email_Sentence__c = 1;
		errObj.Email_Spelling__c = 1;
		errObj.Email_Punctuation__c = 1;
		errObj.Email_Grammar__c = 1;
		errObj.Email_FirstContactResolution__c = 1;
		errObj.Email_Tone__c = 1;
		errObj.Email_ProperClosing__c = 1;
		errObj.Sat_Sun_Holiday__c = 1;

		// Insert the object 
		insert errObj;
		System.assert(errObj.Id != null);
		System.assert(errObj.Agent__c != null);


		// Have to query for AgentErrors object now.
		AgentErrors__c ae = [SELECT TotalErrors__c, TotalServiceOrders__c, 
							 EmailTotal__c, WrongSA__c, Id From AgentErrors__c
							 WHERE Id =: errObj.Id];

		// Assert that there is now an agent object and its Quality_Email_Perc
		// and Quality_Error_Rate are as expected.
		Agent__c agentObj = [SELECT Quality_Error_Rate__c, 
							Quality_Email_Percent__c FROM Agent__c limit 1];

		System.assert(agentObj != null);

		System.assert(ae != null);

		System.assert(ae.TotalErrors__c != null);

		System.assert(ae.TotalServiceOrders__c != null);

		System.assert(agentObj.Quality_Error_Rate__c != null);

		System.assert(agentObj.Quality_Email_Percent__c != null);

		System.assertEquals(ae.TotalErrors__c/ae.TotalServiceOrders__c, 
							agentObj.Quality_Error_Rate__c);
		
		System.assertEquals(ae.EmailTotal__c, 
							agentObj.Quality_Email_Percent__c);

		// Update a field on the Agent errors object to take care of update trig
		ae.WrongSA__c = 2; 
		update ae;
		// Delete Agent Errors object to take care of delete trigger.
		delete ae;
	}
	
	@isTest static void agentObjExsts() {
		// Start by inseting agent object
		Agent__c a = new Agent__c();
		a.Date__c = Date.newInstance(Date.today().year(), 
									Date.today().month(),
									1);
		a.agentid__c = '12345';
		a.agent_name__c = 'Temp name';
		insert a;

		System.debug('Date.today() is: '+Date.today());


		// Willbe only one AgentTeam object in DB
		AgentTeam__c aTeam = new AgentTeam__c();
		aTeam.PSERMID__c = '12345';
		insert aTeam;
		System.assertEquals('12345', aTeam.PSERMID__c);
		// Create a new Agent Errors Object
		AgentErrors__c errObj = new AgentErrors__c();
		errObj.Date__c = Date.today();
		errObj.TotalServiceOrders__c = 22;
		errObj.Agent__c = aTeam.Id;
		errObj.AllSasNotSelect__c = 1;
		errObj.ATO__c = 1;
		errObj.FaMisc__c = 1;
		errObj.Deposit__c = 1;
		errObj.MailingAddress__c = 1;
		errObj.Misc__c = 1;
		errObj.PayPlan__c = 1;
		errObj.NoConnectionCharge__c = 1;
		errObj.SelectedTooManySAS__c = 1;
		errObj.WrongAddress__c = 1;
		errObj.WrongSA__c = 1;
		errObj.Email_Salutation__c = 1;
		errObj.Email_Paragraph__c = 1;
		errObj.Email_Sentence__c = 1;
		errObj.Email_Spelling__c = 1;
		errObj.Email_Punctuation__c = 1;
		errObj.Email_Grammar__c = 1;
		errObj.Email_FirstContactResolution__c = 1;
		errObj.Email_Tone__c = 1;
		errObj.Email_ProperClosing__c = 1;
		errObj.Sat_Sun_Holiday__c = 1;

		// Insert the object 
		insert errObj;
		System.assert(errObj.Id != null);
		System.assert(errObj.Agent__c != null);


		// Have to query for AgentErrors object now.
		AgentErrors__c ae = [SELECT TotalErrors__c, TotalServiceOrders__c, 
							 EmailTotal__c, WrongSA__c, Id From AgentErrors__c
							 WHERE Id =: errObj.Id];


		// Assert that there is now an agent object and its Quality_Email_Perc
		// and Quality_Error_Rate are as expected.
		Agent__c agentObj = [SELECT Quality_Error_Rate__c, 
							Quality_Email_Percent__c, agentid__c FROM Agent__c limit 1];

		System.debug('agentObj.agentid__c is: '+agentObj.agentid__c);

		System.assert(agentObj != null);

		System.assert(ae != null);

		System.assert(ae.TotalErrors__c != null);

		System.assert(ae.TotalServiceOrders__c != null);

		System.assert(agentObj.Quality_Error_Rate__c != null);

		System.assert(agentObj.Quality_Email_Percent__c != null);

		System.assertEquals(ae.TotalErrors__c/ae.TotalServiceOrders__c, 
							agentObj.Quality_Error_Rate__c);
		
		System.assertEquals(ae.EmailTotal__c, 
							agentObj.Quality_Email_Percent__c);
	}
	
}