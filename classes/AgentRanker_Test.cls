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
private class AgentRanker_Test {

    static testMethod void myUnitTest() {
    	
    	List<Agent__c> agentList = new List<Agent__c>();
    	
    	//Start by placing some agents to be ranked in the db.
    	for (Integer i = 0; i < 25; ++i) {
    		Agent__c temp = new Agent__c();
    		temp.Date__c = Date.today();
    		temp.Agent_Id__c = 'Agent'+i;
    		temp.Average_Call_Handle_Time__c = i;
	        temp.Call_Over_7_Minutes_Percent__c = i; 
	        temp.Communication_with_Sup__c = i; 
	        temp.Dependability__c = i; 
	        temp.Contacts_Per_Day__c = i; 
	        temp.Follow_up_time_percent__c = i;
	        temp.Hold_Time_Percent__c = i;
	        temp.Quality_Score_BPA__c = i;
	        temp.Quality_Error_Rate__c = i; 
	        temp.Schedule_Adherence_Percent__c = i;
	        temp.Teamwork__c = i;
	        temp.Email_Handle_Time__c = i; 
	        agentList.add(temp);
    	}
    	
    	insert agentList;
    	
    	
    	/* Each test requires a new contructor due to the nature of the update */
    	
    			
		//dense rank with dateless ranker
		AgentRanker datelessRanker2 = new AgentRanker();
    	datelessRanker2.denseRank();
    	
    	//Need to set isRecursive to false, so that code will execute.. This 
		//simulates a new running context on the page. 
		datelessRanker2.setIsRecursive(false);

    	
    	//Instantiate agent ranker without date 
    	AgentRanker datelessRanker = new AgentRanker();
    	//rank with dateless ranker
    	datelessRanker.competitionRank();
    	
    	//Instantiate ranker with todays date
    	AgentRanker datedRanker = new AgentRanker(Date.today());
    	datedRanker.competitionRank();
		
		//Need to set isRecursive to false, so that code will execute.. This 
		//simulates a new running context on the page. 
		datedRanker.setIsRecursive(false); 
		
		//dated ranker for dense rank
		AgentRanker datedRanker2 = new AgentRanker(Date.today());
    	datedRanker2.denseRank();
    }
    
    private static testMethod void bulkTest() {
        List<Agent__c> agentList = new List<Agent__c>();
    	
    	//Start by placing 200 agents to be ranked in the db.
    	for (Integer i = 0; i < 200; ++i) {
    		Agent__c temp = new Agent__c();
    		temp.Date__c = Date.today();
    		temp.Agent_Id__c = 'Agent'+i;
    		temp.Average_Call_Handle_Time__c = i;
	        temp.Call_Over_7_Minutes_Percent__c = i; 
	        temp.Communication_with_Sup__c = i; 
	        temp.Dependability__c = i; 
	        temp.Contacts_Per_Day__c = i; 
	        temp.Follow_up_time_percent__c = i;
	        temp.Hold_Time_Percent__c = i;
	        temp.Quality_Score_BPA__c = i;
	        temp.Quality_Error_Rate__c = i; 
	        temp.Schedule_Adherence_Percent__c = i;
	        temp.Teamwork__c = i;
	        temp.Email_Handle_Time__c = i; 
	        agentList.add(temp);
    	}
    	
    	insert agentList;
        
        //Attemp to rank them using either method. 
        //Instantiate ranker with todays date
    	AgentRanker datedRanker = new AgentRanker(Date.today());
        datedRanker.denseRank();
    }
}