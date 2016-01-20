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
private class DateSelectListBuilder_Test {

	/**
	 * Tests Date select list builder with valid and necessary data in DB.
	 */
    static testMethod void positiveTest() {
        //Insert some date and agent values to be inserted. 
        List<Agent__c> agentList = new List<Agent__c>();
        for(integer i = 0; i < 20; ++i) {
        	Agent__c temp = new Agent__c(); 
        	temp.Date__c = Date.newInstance(2000, Math.mod(i, 12), 1);
        	agentList.add(temp);
        }
        
        insert agentList;
        
        //Build select lists 
        DateSelectListBuilder dslBuilder = new DateSelectListBuilder(); 
        List<SelectOption> standardList = dslBuilder.buildSelectList(new List<sObject>());
        system.assert(!standardList.isEmpty());
        
        List<SelectOption> agentDateList = dslBuilder.buildAgentDateSelectList();
        system.assert(!agentDateList.isEmpty()); 
    }
    
    
    /**
     * Tests DateSelectListBuilder on empty data
     */
     static testMethod void emptyTest() {
     	//Build select lists 
        DateSelectListBuilder dslBuilder = new DateSelectListBuilder(); 
        List<SelectOption> standardList = dslBuilder.buildSelectList(new List<sObject>());
        system.assert(!standardList.isEmpty());
        
        //agentDateList should be empty this time because there are no agent 
        //objects to fill the list. 
        List<SelectOption> agentDateList = dslBuilder.buildAgentDateSelectList();
        system.assert(agentDateList.isEmpty());
     }
}