/**
 * This class contains unit tests for validating the behavior of Apex class
 * AgentRankDistinct.
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
private class AgentRankDistinct_Test {

	/**
     * Sets up data that can be used in all test methods. 
     * Any data that is changed in one test method will be 
     * reset to its original data in the next test mehtod. 
     */
    @testSetup static void setup() {
        // Place 200 agents in the db
        List<Agent__c> agentList = new List<Agent__c>(); 
        for (integer i = 0; i < 200; ++i) {
            Agent__c temp = new Agent__c(); 
            temp.Contacts_Per_Day__c = i;
            temp.Other_Time__c = i; 
	        temp.Date__c = Date.today();
            agentList.add(temp);
        }

        insert agentList; 


        // Have to put in custom settings to test. 
        // only put in contacts per day and other time
        AgentsRankedStats__c cpd = new AgentsRankedStats__c(); 
        cpd.Name = 'Contacts_Per_Day__c'; 
        cpd.rankName__c = 'CPD_Rank__c';
        cpd.rankStyle__c = 'DESC'; 
        insert cpd; 

        AgentsRankedStats__c ot = new AgentsRankedStats__c(); 
        ot.Name = 'Other_Time__c'; 
        ot.rankName__c = 'OT_Rank__c'; 
        ot.rankStyle__c = 'ASC';
        insert ot; 
    }
	
	/**
	 * Tests AgentRankDistinct using expected input
	 */
	@isTest static void positiveTest() {
        
        //Place one more agent in that has same value as another agent
        Agent__c tempAgent = new Agent__c(); 
        tempAgent.Other_Time__c = 20; 
        tempAgent.Contacts_Per_Day__c = 20; 
        tempAgent.Date__c = Date.today(); 
        insert tempAgent; 
        
		// rank agents 
		AgentRankDistinct ranker = new AgentRankDistinct(Date.today());
		ranker.rankAgents(); 

		//Check to make sure the agents are in the correct order
		List<Agent__c> cpdOrderedList = [SELECT Contacts_Per_Day__c, CPD_Rank__c, Other_Time__c, 
			OT_Rank__c FROM Agent__c ORDER BY Contacts_Per_Day__c DESC];
		List<Agent__c> cpdRankOrderedList = [SELECT Contacts_Per_Day__c, CPD_Rank__c, Other_Time__c, 
			OT_Rank__c FROM Agent__c ORDER BY CPD_Rank__c ASC];
		List<Agent__c> otOrderedList = [SELECT Contacts_Per_Day__c, CPD_Rank__c, Other_Time__c, 
			OT_Rank__c FROM Agent__c ORDER BY Other_Time__c ASC];
		List<Agent__c> otRankOrderedList = [SELECT Contacts_Per_Day__c, CPD_Rank__c, Other_Time__c, 
			OT_Rank__c FROM Agent__c ORDER BY OT_Rank__c ASC];

		// Assert that lists are equal
		system.assertEquals(cpdOrderedList, cpdRankOrderedList);
		system.assertEquals(otOrderedList, otRankOrderedList);

	}
	
	
	/**
	 * Tests the percentile ranking system. 
	 */
	@isTest static void percentileRankTest() {
		// Rank agents with percentile rank
		AgentRankDistinct ranker = new AgentRankDistinct(Date.today()); 
		// Rank the non email agents. 
		ranker.rankPercentile(false);
		// Rank the email agents
		ranker.rankPercentile(true); 
		
		// Print the agents ranks to see what they look like. 
		List<Agent__c> otRank = [SELECT Other_Time__c, OT_Rank__c FROM Agent__c ORDER BY OT_Rank__c DESC];
		for (Agent__c agent: otRank) {
			system.debug(LoggingLevel.ERROR, 'Score: '+agent.Other_Time__c+ ', Rank: '+agent.OT_Rank__c);
		}
		
		system.debug(LoggingLevel.ERROR, 'Does this even show up?');
        system.assertEquals(99, otRank[0].OT_Rank__c);
	}
	
	/**
	 * Tests AgentRankDistinct using unexpected input
	 */
	@isTest static void negativeTest() {
		// Try ranking for a date that has no objetcs associated with it. 
		AgentRankDistinct ranker = new AgentRankDistinct(Date.today().addMonths(1));
		ranker.rankAgents();
	}
	
}