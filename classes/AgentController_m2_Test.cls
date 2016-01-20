/**
 * This class contains unit tests for validating the behavior of Apex class
 * AgentController_m2
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
public class AgentController_m2_Test {
	
	sObjectType oType = Schema.getGlobalDescribe().get('Agent__c'); 
	List<Schema.sObjectField> fields = oType.getDescribe().fields.getMap().values();

	/**
     * Sets up data that can be used in all test methods. 
     * Any data that is changed in one test method will be 
     * reset to its original data in the next test mehtod. 
     */
    @testSetup static void setup() {
    	// Need to insert at least one agent with statistics. 
    	Agent__c testAgent = new Agent__c(); 
    	// Get all stats and set all stats
    	sObjectType oType = Schema.getGlobalDescribe().get('Agent__c'); 
		List<Schema.sObjectField> fields = oType.getDescribe().fields.getMap().values();
		for (Integer i = 0, j = fields.size(); i < j; ++i) {
			if (fields[i].getDescribe().Type == DisplayType.Double ||
				fields[i].getDescribe().Type == DisplayType.Integer ) {
				try {
					testAgent.put(fields[i].getDescribe().getName(), Integer.valueOf(Math.random()));
				} catch(System.SObjectException e){}
			}
		}

		// Set other needed fields. 
		testAgent.Agent_ID__c = 'testId'; 
		insert testAgent;

		// Put some agents in agent team so that you can use agent select list builder
		AgentTeam__c aTeam = new AgentTeam__c(); 
		aTeam.FirstName__c = 'Test'; 
		aTeam.LastName__c = 'Man'; 
		aTeam.PSERMID__c = 'testId'; 
		insert aTeam; 
    }



	/** 
	 * Currently only attempting to get full coverage, A better test class should be written in the future. 
	 */
	static testMethod void positiveTest() {
		// Instantiate the controller
		AgentController_m2 controller = new AgentController_m2(); 

		// Set all of the fields in the controller
		controller.selectedVal = 'testId'; 
		controller.dateValue = String.valueOf(Date.today()); 

		// Call all methods in controller
		controller.getDateList();
		controller.getAgentsList();
		controller.getStatList();
		sObjectType oType = Schema.getGlobalDescribe().get('Agent__c'); 
		List<Schema.sObjectField> fields = oType.getDescribe().fields.getMap().values();
		String aQuery = 'SELECT Id';
		for (Schema.sObjectField field : fields) {
			if (field.getDescribe().Type == DisplayType.Double ||
				field.getDescribe().Type == DisplayType.Integer ) {
				aQuery += ','+field.getDescribe().getName(); 
			}
		}
		aQuery += ' FROM Agent__c';
		System.debug('The query string: '+aQuery);
		List<Agent__c> aList = Database.query(aQuery);
		controller.instantiateList(aList); 
		controller.save();

	}

}