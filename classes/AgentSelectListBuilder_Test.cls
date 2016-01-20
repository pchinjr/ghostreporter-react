/**
 * This class contains unit tests for validating the behavior of Apex
 * class AgentSelectListBuilder
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
private class AgentSelectListBuilder_Test {
	
    static testMethod void myUnitTest() {
        
        //Instatniate builder
        AgentSelectListBuilder aslBuilder = new AgentSelectListBuilder();
        
        List<Agent__c> agentList = new List<Agent__c>(); 
        //put some agents in the db
        for (integer i = 0; i < 25; ++i) {
        	Agent__c temp = new Agent__c();
        	temp.Agent_Id__c = 'temp'+i;
        	temp.Team__c = 'Team' +i;
        	temp.Name__c = 'Test Agent'+i;
        	agentList.add(temp);
        }
        
        //call build selectLIst
        List<SelectOption> selectList = aslBuilder.buildSelectList(agentList);
        
        //Call getAgentList() need to put some values in AgentTeam for this
        List<AgentTeam__c> aTeamList = new List<AgentTeam__c>(); 
        for (integer i = 0; i < 25; ++i) {
        	AgentTeam__c temp = new AgentTeam__c();
        	temp.PSERMID__c = 'temp'+i;
        	temp.Team__c = 'Team' +i;
        	temp.FirstName__c = 'Test';
        	temp.LastName__c =  'Agent'+i;
        	aTeamList.add(temp);
        }
        insert aTeamList; 
        
        List<SelectOption> getList = aslBuilder.getAgentList(); 
        
        //Call getAgentList2()
        List<SelectOption> selectList2 = aslBuilder.getAgentList2(); 
               
    }
    
     
}