@isTest
private class AgentConroller_m2_Test {
    
    
    /**
     * Builds list of required custom settings 
     * @return list of AgentStatsScoringLevel__c.
     */
    private static List<AgentStatsScoringLevel__c> getCustomSettingsList() {
        List<AgentStatsScoringLevel__c> settingsList = new List<AgentStatsScoringLevel__c>(); 
        //Contacts per day setting 
        AgentStatsScoringLevel__c cpd = new AgentStatsScoringLevel__c();
        cpd.Name = 'Contacts_Per_Day__c';
        cpd.GoodLevel__c = 80; 
        cpd.OutstandingLevel__c = 100; 
        cpd.GoodPoints__c = 3; 
        cpd.OutstandingPoints__c = 5; 
        cpd.RankStyle__c = 'HIGH'; 
        cpd.NeedsImprovementLevel__c = 70; 
        cpd.SuperiorLevel__c = 91; 
        cpd.NeedsImprovementPoints__c = 1; 
        cpd.SuperiorPoints__c = 4; 
        cpd.UnsatisfactoryPoints__c = 0; 
        
        //Dependability.
        AgentStatsScoringLevel__c acht = new AgentStatsScoringLevel__c(); 
        acht.Name = 'Dependability__c';
        acht.OutstandingLevel__c = 4;
        acht.GoodLevel__c = 1.9;
        acht.GoodPoints__c = 3; 
        acht.OutstandingPoints__c = 5; 
        acht.RankStyle__c = 'HIGH'; 
        acht.NeedsImprovementLevel__c = 0.9; 
        acht.SuperiorLevel__c = 3.0;
        acht.SuperiorPoints__c = 4; 
        acht.NeedsImprovementPoints__c = 1; 
        acht.UnsatisfactoryPoints__c = 0; 
        
        
        //Need to add a LOW rank style stat,
        AgentStatsScoringLevel__c ot = new AgentStatsScoringLevel__c(); 
        ot.Name = 'Other_Time__c';
        ot.OutstandingLevel__c = 300;
        ot.GoodLevel__c = 660;
        ot.GoodPoints__c = 3; 
        ot.OutstandingPoints__c = 5; 
        ot.RankStyle__c = 'LOW'; 
        ot.NeedsImprovementLevel__c = 900; 
        ot.SuperiorLevel__c = 540;
        ot.SuperiorPoints__c = 4; 
        ot.NeedsImprovementPoints__c = 1; 
        ot.UnsatisfactoryPoints__c = 0;
        
       	settingsLIst.add(acht);
        settingsList.add(cpd);
        settingsList.add(ot);
        
        //Don't put one of the scores in here so that you can test if it returns 'white'
        
        return settingsList; 
    }
    
    public static List<AgentStatsScoringLevels_EmailAndCalls__c> getEmailSettings() {
    	
    	List<AgentStatsScoringLevels_EmailAndCalls__c> emailSettingsList = 
    							new List<AgentStatsScoringLevels_EmailAndCalls__c>();
    	
    	//add two email custom settings 
    	AgentStatsScoringLevels_EmailAndCalls__c ot = new AgentStatsScoringLevels_EmailAndCalls__c();
    	ot.Name = 'Other_Time__c'; 
    	ot.GoodPoints__c = 3; 
    	ot.GoodLevel__c = 660;
    	ot.NeedsImprovementPoints__c = 1;
    	ot.NeedsImprovementLevel__c = 900; 
    	ot.OutstandingPoints__c = 5;
    	ot.OutstandingLevel__c = 300;
    	ot.SuperiorPoints__c = 4;
    	ot.SuperiorLevel__c = 540;
    	ot.UnsatisfactoryPoints__c = 0; 
    	ot.RankStyle__c = 'LOW'; 
    	
    	AgentStatsScoringLevels_EmailAndCalls__c cpd = new AgentStatsScoringLevels_EmailAndCalls__c();
    	cpd.Name = 'Contacts_Per_Day__c'; 
    	cpd.GoodPoints__c = 6; 
    	cpd.GoodLevel__c = 70;
    	cpd.NeedsImprovementPoints__c = 2;
    	cpd.NeedsImprovementLevel__c = 60; 
    	cpd.OutstandingPoints__c = 10;
    	cpd.OutstandingLevel__c = 90;
    	cpd.SuperiorPoints__c = 8;
    	cpd.SuperiorLevel__c = 81;
    	cpd.UnsatisfactoryPoints__c = 0; 
    	cpd.RankStyle__c = 'HIGH'; 
    	
    	emailSettingsList.add(ot);
    	emailSettingsList.add(cpd); 
    	
    	return emailSettingsList; 
    	
    }
    
    
    /**
     * Test method for single expected input
     * 
     * @author Mike McGee
     */
    private static testMethod void test_positive_nonEmail() {
        
        List<Agent__c> agentList = [SELECT Id FROM Agent__c];
        system.assert(agentList.isEmpty());
        
        //insert custom settings list
        insert getCustomSettingsList();
        
        //insert custom email agent settings
        insert getEmailSettings(); 
        
        //Insert one non emial Agent__c object for testing
        Agent__c testAgent = new Agent__c();
        testAgent.Dependability__c = 5; 
        testAgent.Communication_with_Sup__c = 4; 
        testAgent.Contacts_Per_Day__c = 7;
        testAgent.Other_Time__c = 0; 
        testAgent.Agent_ID__c = '12345'; 
        testAgent.Date__c = Date.today();
        insert testAgent;
        
        //Insert one AgentTeam__c object for testing. 
        AgentTeam__c testAgentTeam = new AgentTeam__c(); 
        testAgentTeam.PSERMID__c = '12345'; 
		testAgentTeam.FirstName__c = 'Test';
        testAgentTeam.LastName__c = 'Agent'; 
		testAgentTeam.Team__c = 'CRT';
        insert testAgentTeam;
        
    	//Need to try with an isEmail client
        
        
        //Get page reference for tableTeser_r2
        PageReference pageRef = Page.TableTester_r2; 
        
        //Set page as starting point. 
        Test.setCurrentPage(pageRef);
        
        //Instantiate Controller
        AgentController_m2 controller = new AgentController_m2(); 
        
        //Set all variables that would otherwise be selected
        controller.selectedVal = '12345';
        controller.dateValue = String.valueOf(Date.today()); 
        
        
        //simulate select list getter methods
        List<SelectOption> dateList = controller.getDateList(); 
        List<SelectOption> agentSelectList = controller.getAgentsList(); 
        
        //make sure lists are not empty
        system.assert(!dateList.isEmpty()); 
        system.assert(!agentSelectList.isEmpty());
        
        //Call getStatList()
        List<AgentStatsWrapper> wrapperList = controller.getStatList(); 
        
        //Make sure stat list is not empty
        system.assert(!wrapperList.isEmpty());
        
        //Make sure curMonth values, also check avg value and color code. 
        for (AgentStatsWrapper sw: wrapperList) {
            if (sw.statName.equalsIgnoreCase('Contacts Per Day')) {
                system.assertEquals(7, sw.curMonthValue);
                system.assertEquals(7, sw.avg);
                system.assertEquals('#F44336 !important', sw.curColor);
            } else if (sw.statName.equalsIgnoreCase('Dependability')) {
                system.assertEquals(5, sw.curMonthValue);
                system.assertEquals(5, sw.avg);
                system.assertEquals('#4CAF50 !important', sw.curColor);
            } else if (sw.statName.equalsIgnoreCase('Performance Journal Feedback')) {
                system.assertEquals(4, sw.curMonthValue);
                system.assertEquals(4, sw.avg);
                system.assertEquals('white', sw.curColor);
            } else if (sw.statName.equalsIgnoreCase('Other Time')) {
            	system.assertEquals(0, sw.curMonthValue);
                system.assertEquals(0, sw.avg);
                system.assertEquals('#4CAF50 !important', sw.curColor);
            }
        }
        
        //Set some values to be saved
        controller.curAgent.Dependability__c = 1;
        controller.curAgent.Communication_with_Sup__c = 2; 
        controller.curAgent.Schedule_Adherence_Percent__c = 3;
        controller.curAgent.Teamwork__c = 4;
        
        //Call save()
        controller.save(); 
        
        //assert that the correct values were saved. 
        Agent__c shouldBeCurAgent = [SELECT Id, Dependability__c, Communication_with_Sup__c, Schedule_Adherence_Percent__c, Teamwork__c FROM Agent__c WHERE Agent_Id__c = :controller.curAgent.Agent_Id__c];
        system.assertEquals(1, shouldBeCurAgent.Dependability__c); 
        system.assertEquals(2, shouldBeCurAgent.Communication_with_Sup__c);
        system.assertEquals(3, shouldBeCurAgent.Schedule_Adherence_Percent__c); 
        system.assertEquals(4, shouldBeCurAgent.Teamwork__c); 
        
        
        //Use load stats to simulate selected agent being changed
        controller.loadStats(); 
       
    }
    
    /**
     * Test method for single expected input where agent isEMail
     * 
     * @author Mike McGee
     */
    private static testMethod void test_positive_email() {
        
        List<Agent__c> agentList = [SELECT Id FROM Agent__c];
        system.assert(agentList.isEmpty());
        
        //insert custom settings list
        insert getCustomSettingsList();
        
        //insert custom email agent settings
        insert getEmailSettings(); 
        
        //Insert one non emial Agent__c object for testing
        Agent__c testAgent = new Agent__c();
        testAgent.Other_Time__c = 0; 
        testAgent.Contacts_Per_Day__c = 7;
        testAgent.Agent_ID__c = '12345'; 
        testAgent.Date__c = Date.today();
        testAgent.IsEmailAgent__c = true; 
        insert testAgent;
        
        //Insert one AgentTeam__c object for testing. 
        AgentTeam__c testAgentTeam = new AgentTeam__c(); 
        testAgentTeam.PSERMID__c = '12345'; 
		testAgentTeam.FirstName__c = 'Test';
        testAgentTeam.LastName__c = 'Agent'; 
		testAgentTeam.Team__c = 'CRT';
        insert testAgentTeam;
        
    	//Need to try with an isEmail client
        
        
        //Get page reference for tableTeser_r2
        PageReference pageRef = Page.TableTester_r2; 
        
        //Set page as starting point. 
        Test.setCurrentPage(pageRef);
        
        //Instantiate Controller
        AgentController_m2 controller = new AgentController_m2(); 
        
        //Set all variables that would otherwise be selected
        controller.selectedVal = '12345';
        controller.dateValue = String.valueOf(Date.today()); 
        
        
        //simulate select list getter methods
        List<SelectOption> dateList = controller.getDateList(); 
        List<SelectOption> agentSelectList = controller.getAgentsList(); 
        
        //make sure lists are not empty
        system.assert(!dateList.isEmpty()); 
        system.assert(!agentSelectList.isEmpty());
        
        //Call getStatList()
        List<AgentStatsWrapper> wrapperList = controller.getStatList(); 
        
        //Make sure stat list is not empty
        system.assert(!wrapperList.isEmpty());
        
        //Make sure curMonth values, also check avg value and color code. 
        for (AgentStatsWrapper sw: wrapperList) {
            if (sw.statName.equalsIgnoreCase('Contacts Per Day')) {
                system.assertEquals(7, sw.curMonthValue);
                system.assertEquals(7, sw.avg);
                system.assertEquals('#F44336 !important', sw.curColor);
            } else if (sw.statName.equalsIgnoreCase('Other Time')) {
                system.assertEquals(0, sw.curMonthValue);
                system.assertEquals(0, sw.avg);
                system.assertEquals('#4CAF50 !important', sw.curColor);
            } 
        }
        
        //Set some values to be saved
        controller.curAgent.Dependability__c = 1;
        controller.curAgent.Communication_with_Sup__c = 2; 
        controller.curAgent.Schedule_Adherence_Percent__c = 3;
        controller.curAgent.Teamwork__c = 4;
        
        //Call save()
        controller.save(); 
        
        //assert that the correct values were saved. 
        Agent__c shouldBeCurAgent = [SELECT Id, Dependability__c, Communication_with_Sup__c, Schedule_Adherence_Percent__c, Teamwork__c FROM Agent__c WHERE Agent_Id__c = :controller.curAgent.Agent_Id__c];
        system.assertEquals(1, shouldBeCurAgent.Dependability__c); 
        system.assertEquals(2, shouldBeCurAgent.Communication_with_Sup__c);
        system.assertEquals(3, shouldBeCurAgent.Schedule_Adherence_Percent__c); 
        system.assertEquals(4, shouldBeCurAgent.Teamwork__c); 
        
        
        //Use load stats to simulate selected agent being changed
        controller.loadStats(); 
       
    }
    
    /**
     * Test method for single incorrect input (empty controller)
     */
     private static testMethod void emptyTest() {
     	//Insert one agent object and one agent team object for select list
     	//building
     	Agent__c ag = new Agent__c();
     	ag.Agent_ID__c = '12345'; 
        ag.Date__c = Date.today(); 
        insert ag; 
        
        AgentTeam__c testAt = new AgentTeam__c(); 
        testAt.PSERMID__c = '12345'; 
		testAt.FirstName__c = 'Test';
        testAt.LastName__c = 'Agent'; 
		testAt.Team__c = 'CRT';
        insert testAt;    	     	
     	
     	//Instantiate controller
     	AgentController_m2 controller = new AgentController_m2(); 
     	
     	
     	//simulate select list getter methods
        List<SelectOption> dateList = controller.getDateList(); 
        List<SelectOption> agentSelectList = controller.getAgentsList();
        
        //call loadStats without selected values
        List<AgentStatsWrapper> wrapperList = controller.getStatList();
        
        //assert that all values in wrapper list are 0
        for (AgentStatsWrapper sw: wrapperList) {
        	system.assertEquals(0, sw.curMonthValue);
        	system.assertEquals(0, sw.avg);
        	system.assertEquals(0, sw.prevMonthValue);
        } 
        
        //call save with no selected values
        controller.save(); 
        
        //call loadStats with no selected values.
        controller.loadStats(); 
        
     }
    
   
}