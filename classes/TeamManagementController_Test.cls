/**
 * This class contains unit tests for validating the behavior of Apex class
 * TeamManagementController
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
private class TeamManagementController_Test {
	
	/**
     * Sets up data that can be used in all test methods. 
     * Any data that is changed in one test method will be 
     * reset to its original data in the next test mehtod. 
     */
    @testSetup static void setup() {
    	// Need an AgentTeam 
    	AgentTeam__c at = new AgentTeam__c();
    	at.FirstName__c = 'test'; 
    	at.LastName__c = 'man';
    	at.PSERMID__c = 'testAgent'; 
    	at.Team__c = 'testTeam';
    	insert at; 
    }

	@isTest static void positiveTest() {
		// Need to set page reference in order to test page variables. 
		PageReference pRef = Page.TeamManagement;
		// Set some page variable 
		// Select sf_uniqueId so that it can be set as uniqueID. 
		AgentTeam__c onlyAgent = [SELECT sf_uniqueId__c FROM AgentTeam__c LIMIT 1];
		String uId = onlyAgent.sf_uniqueId__c;
		String sysId = onlyAgent.Id; 
		ApexPages.currentPage().getParameters().put('uniqueId', sysId);
		// Instantiate new controller
		TeamManagementController controller = new TeamManagementController();
		// Need to set selected agent and team 
		controller.selectedAgentName = uId;
		controller.selectedTeam = 'testTeam';
		// Call select methods. ()
		controller.getTeamSelectList();
		controller.resetAgentSelectList();
		// Call set methods
		controller.setAgentTeam();
		controller.resetAgentInfo();
		controller.setAgentTeamSpecific();
		// Call update methods. 
		TeamManagementController.updateAgentOnClick(true, uId, 'testTeam');
		TeamManagementController.updateAgentWithNameOnClick(true, uId, 'testTeam', 'Test', 'Agent');
		TeamManagementController.addNewAgentOnClickListener('testy', 'Age', false, 'testTeam', 'testyAgent');


	}
	
	
}