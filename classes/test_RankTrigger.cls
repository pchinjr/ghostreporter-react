@isTest
global class test_RankTrigger {

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


	private static testMethod void test() {
        DateTime firstDate;
        DateTime secondDate;
        
        Agent__c agent = new Agent__c();
        agent.date__c = Date.today();
        agent.name__c = 'Ortiz, Ruben';
        agent.agentid_date__c = '1234455';
        agent.agent_name__c = 'Ortiz, Ruben';
        agent.Other_Time__c = 20; 
        agent.Contacts_Per_Day__c = 20; 
        insert agent;
        
        AgentRankStarter__c ag = new AgentRankStarter__c(LastRankDateTime__c = Datetime.now(), Name='12345',rankkey__c='12345' );
        insert ag;
        
        firstDate = [select LastRankDateTime__c from AgentRankStarter__c limit 1].LastRankDateTime__c;
        
        List<AgentRankStarter__c> temp = new List<AgentRankStarter__c>();
        
        for(AgentRankStarter__c ab: [select LastRankDateTime__c from AgentRankStarter__c]){
            System.debug('old date=' + ab.LastRankDateTime__c + 'new date=' + DateTime.Now().addMinutes(7));
            ab.LastRankDateTime__c = DateTime.Now().addMinutes(7);
            temp.add(ab);
            
        }
        update temp;
        
        secondDate = [select LastRankDateTime__c from AgentRankStarter__c limit 1].LastRankDateTime__c;
        System.debug('firstdate =' + firstDate + ', second date =' + secondDate);
        
        System.assertNotEquals(firstDate, temp[0].LastRankDateTime__c);

    System.debug('test');
        
 

              
                
    
 
	}

}