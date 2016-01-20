/**
 * This class contains unit tests for validating the behavior of Apex class
 * AgentRank.
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
private class AgentRank_Test {

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
            temp.Average_Call_Handle_Time__c = i;
	        temp.Call_Over_7_Minutes_Percent__c = i; 
	        temp.Communication_with_Sup__c = i; 
	        temp.Dependability__c = i;  
	        temp.Follow_up_time_percent__c = i;
	        temp.Hold_Time_Percent__c = i;
	        temp.Quality_Score_BPA__c = i;
	        temp.Quality_Error_Rate__c = i; 
	        temp.Schedule_Adherence_Percent__c = i;
	        temp.Teamwork__c = i;
	        temp.Email_Handle_Time__c = i; 
	        temp.Emails_Per_Day__c = i; 
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
	 * Tests AgentRank using expected input
	 */
	@isTest static void positiveTest() {

		Test.startTest();

		// Call AgentRank denseRank() 
		AgentRank rankTest = new AgentRank(Date.today()); 
		rankTest.denseRank();

		// Assert a few stats are correct. 
		List<Agent__c> aList = [SELECT Contacts_Per_Day__c, CPD_Rank__c, 
				OT_Rank__c, Other_Time__c FROM Agent__c ORDER BY Contacts_Per_Day__c DESC]; 
		// Due to how the agents were inserted. OtherTime and 
		// Contacts per day should have opposite ranks.
		// Also due to the way it was inserted it should have not ties in ranking. 
		// This should also be tested.  
		for (Integer i = 0; i < aList.size(); ++i) {
			system.assertEquals(i+1, aList[i].CPD_Rank__c);
			system.assertEquals(aList.size() - i, aList[i].OT_Rank__c);
		}

		//Call agent rank competitionRank(); 
		AgentRank rankTest2 = new AgentRank(Date.today());
		rankTest2.competitionRank();
		for (Integer i = 0; i < aList.size(); ++i) {
			system.assertEquals(i+1, aList[i].CPD_Rank__c);
			system.assertEquals(aList.size() - i, aList[i].OT_Rank__c);
		}


		// Test for ties. 
		Agent__c temp = new Agent__c(); 
			temp.Contacts_Per_Day__c = 199;
            temp.Other_Time__c = 1; 
            temp.Average_Call_Handle_Time__c = 1;
	        temp.Call_Over_7_Minutes_Percent__c = 1; 
	        temp.Communication_with_Sup__c = 1; 
	        temp.Dependability__c = 1;  
	        temp.Follow_up_time_percent__c = 1;
	        temp.Hold_Time_Percent__c = 1;
	        temp.Quality_Score_BPA__c = 1;
	        temp.Quality_Error_Rate__c = 1; 
	        temp.Schedule_Adherence_Percent__c = 1;
	        temp.Teamwork__c = 1;
	        temp.Email_Handle_Time__c = 1; 
	        temp.Emails_Per_Day__c = 1; 
	        temp.Date__c = Date.today();
	    insert temp; 

	    AgentRank rankTest3 = new AgentRank(Date.today()); 
	    rankTest3.denseRank(); 

	    // Check for two objects with rank 2. 
	    // maje sure there is a rank 3
	    List<Agent__c> tiesAgents = [SELECT CPD_Rank__c FROM Agent__c WHERE CPD_Rank__c = 1]; 
	    system.assertEquals(2, tiesAgents.size());
	    List<Agent__c> notEmpty = [SELECT CPD_Rank__c FROM Agent__c WHERE CPD_Rank__c = 2];
	    system.assert(!notEmpty.isEmpty());

	    rankTest3.competitionRank(); 
	    // check to make sure there are two objects with rank 2
	    // there should be no object ranked 3
	    List<Agent__c> tiesAgents2 = [SELECT CPD_Rank__c FROM Agent__c WHERE CPD_Rank__c = 1];
	    system.assertEquals(2, tiesAgents2.size());
	    List<Agent__c> emptyList = [SELECT CPD_Rank__c FROM Agent__c WHERE CPD_Rank__c = 2];
	    system.assert(emptyList.isEmpty());
	}
	
	/**
	 * Tests AgentRank using unexpected input
	 */
	@isTest static void negativeTest() {
		// Call AgentRanker with no agents in db. 
		AgentRank notTodatRank = new AgentRank(Date.today().addMonths(1)); 
	}
	
}