/**
 * Controller for agentStats_R, tableTester_r2, tableTester_r3. 
 * This class handles the data and all operations involving the data that 
 * is used on the agentStats_R, tableTester_r2, tableTester_r3 visual force pages
 * @author Mike McGee & Ruben Ortiz
 * 
 */ 

global with sharing class AgentController_m2 extends PageController {

    public String selectedVal{get;set;}  // This will hold the selected value, the id in here
    public String dateValue{get;set;}  //This will hold date value selected in pickl list

    
    public String renderMode{get;set;} //Render style for page
    
    public Agent__c defaultAgent{get;set;}

    //Lists for metric table
    public List<Agent__c> prevMonthList {get;set;}
    public List<Agent__c> twoMonthsAgoList {get;set;}
    //Current Score list 
    public String name{get;set;}
    public Agent__c curAgent{get;set;}
    public Decimal curCPD{get;set;}
    public Decimal curAHT{get;set;}
    public String curAHT_TF{get;set;}
    public Decimal curHT{get;set;}
    public String curHT_TF{get;set;}
    public Decimal curCO7M{get;set;}
    public Decimal curQBPA{get;set;}
    public Decimal curQERR{get;set;}
    public Decimal curSA{get;set;}
    public Decimal curFUT{get;set;}
    public String curFUT_TF{get;set;}
    public Decimal curComm{get;set;}
    public Decimal curDep{get;set;}
    public Decimal curTW{get;set;}
    public Decimal curTotal{get;set;}
    public Decimal avgTotal{get;set;}
    public String curMonth{get;set;}
    public String curYear{get;set;}
    public String totBackground{get;set;}
    public String totAvgBackground{get;set;}

    //prior score list
    public Decimal prevCPD{get;set;}
    public Decimal prevAHT{get;set;}
    public String prevAHT_TF{get;set;}
    public Decimal prevHT{get;set;}
    public String prevHT_TF{get;set;}
    public Decimal prevCO7M{get;set;}
    public Decimal prevQBPA{get;set;}
    public Decimal prevQERR{get;set;}
    public Decimal prevSA{get;set;}
    public Decimal prevFUT{get;set;}
    public String prevFUT_TF{get;set;}


    
    
    //Chart data 
    //August data
    public Decimal augCPD{get;set;}
    public Decimal augAHT{get;set;}
    public Decimal augHT{get;set;}
    public Decimal augCO7M{get;set;}
    public Decimal augQBPA{get;set;}
    public Decimal augQERR{get;set;}
    public Boolean augRVW_CPD{get;set;}
    public Boolean augRVW_HT{get;set;}
    public Boolean augRVW_AHT{get;set;}
    public Boolean augRVW_CO7M{get;set;}
    public Boolean augRVW_COMM{get;set;}
    public Boolean augRVW_DEP{get;set;}
    public Boolean augRVW_FUT{get;set;}
    public Boolean augRVW_QBPA{get;set;}
    public Boolean augRVW_QERR{get;set;}
    public Boolean augRVW_SA{get;set;}
    public Boolean augRVW_TW{get;set;}
    public Boolean augRVW_OT{get;set;}
    //September data
    public Decimal sepCPD{get;set;}
    public Decimal sepAHT{get;set;}
    public Decimal sepHT{get;set;}
    public Decimal sepCO7M{get;set;}
    public Decimal sepQBPA{get;set;}
    public Decimal sepQERR{get;set;}
    public Boolean sepRVW_CPD{get;set;}
    public Boolean sepRVW_HT{get;set;}
    public Boolean sepRVW_AHT{get;set;}
    public Boolean sepRVW_CO7M{get;set;}
    public Boolean sepRVW_COMM{get;set;}
    public Boolean sepRVW_DEP{get;set;}
    public Boolean sepRVW_FUT{get;set;}
    public Boolean sepRVW_QBPA{get;set;}
    public Boolean sepRVW_QERR{get;set;}
    public Boolean sepRVW_SA{get;set;}
    public Boolean sepRVW_TW{get;set;}
    public Boolean sepRVW_OT{get;set;}
    //October DataVW
    public Decimal octCPD{get;set;}
    public Decimal octAHT{get;set;}
    public Decimal octHT{get;set;}
    public Decimal octCO7M{get;set;}
    public Decimal octQBPA{get;set;}
    public Decimal octQERR{get;set;}
    public Boolean octRVW_CPD{get;set;}
    public Boolean octRVW_HT{get;set;}
    public Boolean octRVW_AHT{get;set;}
    public Boolean octRVW_CO7M{get;set;}
    public Boolean octRVW_COMM{get;set;}
    public Boolean octRVW_DEP{get;set;}
    public Boolean octRVW_FUT{get;set;}
    public Boolean octRVW_QBPA{get;set;}
    public Boolean octRVW_QERR{get;set;}
    public Boolean octRVW_SA{get;set;}
    public Boolean octRVW_TW{get;set;}
    public Boolean octRVW_OT{get;set;}
    //November Data
    public Decimal novCPD{get;set;}
    public Decimal novAHT{get;set;}
    public Decimal novHT{get;set;}
    public Decimal novCO7M{get;set;}
    public Decimal novQBPA{get;set;}
    public Decimal novQERR{get;set;}
    public Boolean novRVW_CPD{get;set;}
    public Boolean novRVW_HT{get;set;}
    public Boolean novRVW_AHT{get;set;}
    public Boolean novRVW_CO7M{get;set;}
    public Boolean novRVW_COMM{get;set;}
    public Boolean novRVW_DEP{get;set;}
    public Boolean novRVW_FUT{get;set;}
    public Boolean novRVW_QBPA{get;set;}
    public Boolean novRVW_QERR{get;set;}
    public Boolean novRVW_SA{get;set;}
    public Boolean novRVW_TW{get;set;}
    public Boolean novRVW_OT{get;set;}
    //December data 
    public Decimal decCPD{get;set;}
    public Decimal decAHT{get;set;}
    public Decimal decHT{get;set;}
    public Decimal decCO7M{get;set;}
    public Decimal decQBPA{get;set;}
    public Decimal decQERR{get;set;}
    public Boolean decRVW_CPD{get;set;}
    public Boolean decRVW_HT{get;set;}
    public Boolean decRVW_AHT{get;set;}
    public Boolean decRVW_CO7M{get;set;}
    public Boolean decRVW_COMM{get;set;}
    public Boolean decRVW_DEP{get;set;}
    public Boolean decRVW_FUT{get;set;}
    public Boolean decRVW_QBPA{get;set;}
    public Boolean decRVW_QERR{get;set;}
    public Boolean decRVW_SA{get;set;}
    public Boolean decRVW_TW{get;set;}
    public Boolean decRVW_OT{get;set;}
    //January data
    public Decimal janCPD{get;set;}
    public Decimal janAHT{get;set;}
    public Decimal janHT{get;set;}
    public Decimal janCO7M{get;set;}
    public Decimal janQBPA{get;set;}
    public Decimal janQERR{get;set;}
    public Boolean janRVW_CPD{get;set;}
    public Boolean janRVW_HT{get;set;}
    public Boolean janRVW_AHT{get;set;}
    public Boolean janRVW_CO7M{get;set;}
    public Boolean janRVW_COMM{get;set;}
    public Boolean janRVW_DEP{get;set;}
    public Boolean janRVW_FUT{get;set;}
    public Boolean janRVW_QBPA{get;set;}
    public Boolean janRVW_QERR{get;set;}
    public Boolean janRVW_SA{get;set;}
    public Boolean janRVW_TW{get;set;}
    public Boolean janRVW_OT{get;set;}
    //February data
    public Decimal febCPD{get;set;}
    public Decimal febAHT{get;set;}
    public Decimal febHT{get;set;}
    public Decimal febCO7M{get;set;}
    public Decimal febQBPA{get;set;}
    public Decimal febQERR{get;set;}
    public Boolean febRVW_CPD{get;set;}
    public Boolean febRVW_HT{get;set;}
    public Boolean febRVW_AHT{get;set;}
    public Boolean febRVW_CO7M{get;set;}
    public Boolean febRVW_COMM{get;set;}
    public Boolean febRVW_DEP{get;set;}
    public Boolean febRVW_FUT{get;set;}
    public Boolean febRVW_QBPA{get;set;}
    public Boolean febRVW_QERR{get;set;}
    public Boolean febRVW_SA{get;set;}
    public Boolean febRVW_TW{get;set;}
    public Boolean febRVW_OT{get;set;}
    //March data
    public Decimal marCPD{get;set;}
    public Decimal marAHT{get;set;}
    public Decimal marHT{get;set;}
    public Decimal marCO7M{get;set;}
    public Decimal marQBPA{get;set;}
    public Decimal marQERR{get;set;}
    public Boolean marRVW_CPD{get;set;}
    public Boolean marRVW_HT{get;set;}
    public Boolean marRVW_AHT{get;set;}
    public Boolean marRVW_CO7M{get;set;}
    public Boolean marRVW_COMM{get;set;}
    public Boolean marRVW_DEP{get;set;}
    public Boolean marRVW_FUT{get;set;}
    public Boolean marRVW_QBPA{get;set;}
    public Boolean marRVW_QERR{get;set;}
    public Boolean marRVW_SA{get;set;}
    public Boolean marRVW_TW{get;set;}
    public Boolean marRVW_OT{get;set;}
    //April data 
    public Decimal aprCPD{get;set;}
    public Decimal aprAHT{get;set;}
    public Decimal aprHT{get;set;}
    public Decimal aprCO7M{get;set;}
    public Decimal aprQBPA{get;set;}
    public Decimal aprQERR{get;set;}
    public Boolean aprRVW_CPD{get;set;}
    public Boolean aprRVW_HT{get;set;}
    public Boolean aprRVW_AHT{get;set;}
    public Boolean aprRVW_CO7M{get;set;}
    public Boolean aprRVW_COMM{get;set;}
    public Boolean aprRVW_DEP{get;set;}
    public Boolean aprRVW_FUT{get;set;}
    public Boolean aprRVW_QBPA{get;set;}
    public Boolean aprRVW_QERR{get;set;}
    public Boolean aprRVW_SA{get;set;}
    public Boolean aprRVW_TW{get;set;}
    public Boolean aprRVW_OT{get;set;}
    //May data 
    public Decimal mayCPD{get;set;}
    public Decimal mayAHT{get;set;}
    public Decimal mayHT{get;set;}
    public Decimal mayCO7M{get;set;}
    public Decimal mayQBPA{get;set;}
    public Decimal mayQERR{get;set;}
    public Boolean mayRVW_CPD{get;set;}
    public Boolean mayRVW_HT{get;set;}
    public Boolean mayRVW_AHT{get;set;}
    public Boolean mayRVW_CO7M{get;set;}
    public Boolean mayRVW_COMM{get;set;}
    public Boolean mayRVW_DEP{get;set;}
    public Boolean mayRVW_FUT{get;set;}
    public Boolean mayRVW_QBPA{get;set;}
    public Boolean mayRVW_QERR{get;set;}
    public Boolean mayRVW_SA{get;set;}
    public Boolean mayRVW_TW{get;set;}
    public Boolean mayRVW_OT{get;set;}
    //June data
    public Decimal junCPD{get;set;}
    public Decimal junAHT{get;set;}
    public Decimal junHT{get;set;}
    public Decimal junCO7M{get;set;}
    public Decimal junQBPA{get;set;}
    public Decimal junQERR{get;set;}
    public Boolean junRVW_CPD{get;set;}
    public Boolean junRVW_HT{get;set;}
    public Boolean junRVW_AHT{get;set;}
    public Boolean junRVW_CO7M{get;set;}
    public Boolean junRVW_COMM{get;set;}
    public Boolean junRVW_DEP{get;set;}
    public Boolean junRVW_FUT{get;set;}
    public Boolean junRVW_QBPA{get;set;}
    public Boolean junRVW_QERR{get;set;}
    public Boolean junRVW_SA{get;set;}
    public Boolean junRVW_TW{get;set;}
    public Boolean junRVW_OT{get;set;}
    //July data
    public Decimal julCPD{get;set;}
    public Decimal julAHT{get;set;}
    public Decimal julHT{get;set;}
    public Decimal julCO7M{get;set;}
    public Decimal julQBPA{get;set;}
    public Decimal julQERR{get;set;}
    public Boolean julRVW_CPD{get;set;}
    public Boolean julRVW_HT{get;set;}
    public Boolean julRVW_AHT{get;set;}
    public Boolean julRVW_CO7M{get;set;}
    public Boolean julRVW_COMM{get;set;}
    public Boolean julRVW_DEP{get;set;}
    public Boolean julRVW_FUT{get;set;}
    public Boolean julRVW_QBPA{get;set;}
    public Boolean julRVW_QERR{get;set;}
    public Boolean julRVW_SA{get;set;}
    public Boolean julRVW_TW{get;set;}
    public Boolean julRVW_OT{get;set;}

    
    Boolean isEmailAgent;
    
    private List<String> months = new String[]{'','January', 'February', 'March', 'April', 'May', 'June',
                                       'July', 'August', 'September', 'October', 'November', 'December'};
                                          
	//selectlist builders, one for each unique select list
    private AgentSelectListBuilder agentSelectListBuilderType; 
    private DateSelectListBuilder dateSelectListBuilderType;

    private ColorCode tableColorer; 
    
    
    /**
     * Constructor is called at each time page is loaded. 
     */
    public AgentController_m2() {
        system.debug('Constructor was called');
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        renderMode = '';
         
        tableColorer = ColorCode.getInstace(); 
        selectListBuilderType = new AgentSelectListBuilder();
		agentSelectListBuilderType = new AgentSelectListBuilder();
        dateSelectListBuilderType = new DateSelectListBuilder(); 
    }




    /**
     * Builds date list for selector on VF page
     * @return List<SelectOption> : list of dates starting with prior month in desc order
     */ 
    public List<SelectOption> getDateList() {
        system.debug('getDateList was called');
        return dateSelectListBuilderType.buildAgentDateSelectList();
    }
    


    
    /**
    * Builds list of agent names for the agent select List 
    *@auhtor Mike McGee 
    *
    */
    public List<SelectOption> getAgentsList() {
        system.debug('getAgentList was called');
       	List<Agent__c> agents = [SELECT Name__c, Agent_ID__c FROM Agent__c ORDER BY Name__c ASC NULLS LAST];
        defaultAgent = agents.get(0);
        return agentSelectListBuilderType.getAgentList();
    }




    /**
     * Onlcick for save button on vf page. 
     * Saves the current values associated with the selected agent object. 
     * if there is not already an object for the selected agent and date then a
     * new object is inserted with the values that are input for the selected agent. 
     */
    public void save() {
        system.debug('Entered save method'); 
        if (curAgent.Id == null) {
            curAgent.Agent_ID__c = selectedVal;
            curAgent.Date__c = Date.valueOf(dateValue);
            curAgent.Name__c = name; 
            system.debug('Attempting to insert agent '+curAgent);
            insert curAgent;
        } else {
            if (curAgent.Name__c == null) {
                curAgent.Name__c = name; 
            }
            system.debug('Attempting to update agent :' +curAgent);
            // score agent before updating 
            system.debug('========..... Testing for curAgent.Communication_with_Sup__c is: '+curAgent.Communication_with_Sup__c);
            curAgent = AgentStatistic.scoreAgent(curAgent); 
            update curAgent;
        }
        
        //Call ranker, not calling when running test because it will not have the custom settings necessary to 
        //rank agents. When more time, insert the custom settings into the AgentController_m2_Test class. 
        system.debug('Calling agent ranker'); 
        if (!Test.isRunningTest()) {
            AgentRankDistinct ranker = new AgentRankDistinct(Date.valueOf(dateValue));
            //ranker.rankAgents(); 
            ranker.rankPercentile(true);
            ranker.rankPercentile(false);
        }
    }
   
    

    
    /**
     * Gets all stats for the selected month that are needed to display on the 
     * vf page. 
     * <p> Also calls the <code>setCurVals</code> method which sets the values
     * that will be displayed above the linear gauges. If the query for the agent object
     * returns and empty list then an agent object with 0's in all stats is placed in the
     * list before it is returned. This is necessary for the chart to load even on an empty 
     * agent 
     *
     * @return list of agent objects containing selected months stats
     */
    public List<Agent__c> getAgentStatsPrevMonth2(){
        system.debug('getAgentStatsPrevMonth2 was called');
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        getAgentsList();
        Date currentDate = Date.today();
        Date toConvert = currentDate.addMonths(-1);
        
        if(dateValue == null) {
            
            dateValue = String.valueOf(toConvert); // change to make the day the first of this month. 
        }
        
        Date dateToCheck = Date.valueOf(dateValue);
        
        if(selectedVal == null) {
            selectedVal = defaultAgent.Agent_Id__c;
        }
        
        fillCharts(); 
        
        List<Agent__c> agentStats = [SELECT Id,
                                        Name__c,
                                        Active__c, 
                                        Team__c, 
                                        Agent_ID__c, 
                                        Quality_Score_BPA__c,
                                        Contacts_Per_Day__c,
                                        Average_Call_Handle_Time__c,
                                        Average_Call_Handle_Time_Double__c,
                                        Average_Call_Handle_Time_Formatted__c,
                                        Hold_Time_Percent__c, Hold_Time_Double__c,
                                        Call_Over_7_Minutes_Percent__c,
                                        Quality_Error_Rate__c,
                                        Quality_Email_Percent__c,
                                        Schedule_Adherence_Percent__c,
                                        Other_Time__c, Other_Time_Double__c,Other_Time_Time__c,
                                        Email_Handle_Time__c, Email_Handle_Time_Double__c, Emails_Per_Day__c,
                                        Communication_with_Sup__c,
                                        Teamwork__c,
                                        Dependability__c,
                                        Follow_up_time_percent__c, Follow_up_time_double__c,
                                        Job_Knowledge__c,                        
                                        Resource_Management__c,
                                        Total_Points__c,
                                        supervisor_comments__c,
                                        Comments_notFormatted__c,
                                        Date__c, rvw_ot__c, rvw_aht__c, rvw_ht__c, rvw_co7m__c, rvw_comm__c,
                                        rvw_cpd__c, rvw_dep__c, rvw_fut__c,  rvw_qbpa__c, rvw_qep__c,
                                        rvw_qerr__c, rvw_sa__c, rvw_tw__c, rvw_epd__c, rvw_eht__c, IsEmailAgent__c
                                        FROM Agent__c WHERE Agent_ID__c = :selectedVal 
                                        and Date__c = :dateToCheck
                                        ORDER BY Date__C ASC NULLS LAST];
                                        
        List<Agent__c> names  = [SELECT Name__c FROM Agent__c WHERE Agent_ID__c = :selectedVal]; 
        if(!names.isEmpty()) {
            name = names.get(0).Name__c; 
        } else {
            name = 'Default'; 
        }
              

        List<Agent__c> emptyAgent; 
        //prevMonthList = instantiateList(agentStats);
        prevMonthList = agentStats; 
        if (!prevMonthList.isEmpty()) {
            setCurVals(prevMonthList);
        } else {
            emptyAgent = new List<Agent__c>(); 
            emptyAgent.add(new Agent__c(
                                        Email_Handle_Time__c = 0, Email_Handle_Time_Double__c = 0, Emails_Per_Day__c = 0,
                                        Average_Call_Handle_Time__c = 0, Average_Call_Handle_Time_Double__c = 0, Contacts_Per_Day__c = 0, 
                                        Hold_Time_Percent__c = 0, Hold_Time_Double__c = 0,  Call_Over_7_Minutes_Percent__c = 0,  
                                        Quality_Score_BPA__c = 0,  Quality_Error_Rate__c = 0, Other_Time__c = 0,
                                        Schedule_Adherence_Percent__c = 0, Follow_up_time_percent__c = 0, Follow_up_time_double__c = 0,
                                        Communication_with_Sup__c = 0, Dependability__c = 0, Teamwork__c = 0));
            setCurVals(emptyAgent);
        }
        

        if (agentStats.isEmpty()) {
            curAgent = emptyAgent.get(0);
            curMonth = 'January';
            curYear = String.valueOf(Date.today().year());
        } else {
            curAgent = agentStats.get(0);
            curMonth = months[curAgent.Date__c.month()]; 
            curYear = String.valueOf(curAgent.Date__c.year());
        } 
        
        system.debug('curAgent is: '+curAgent);
        
        return agentStats;
    }
    
    

    
    /**
     * Gets all ranking stats for the selected date and agent. 
     * if the query for the rankings returns no values, it sets each 
     * ranking to 0 and returns the list. 
     * @return list of agent objects containing the rankings for the selected agent and date.
     */
    public List<Agent__c> getRankings2() {
        system.debug('getRankings2 was called');
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        getAgentsList();
        Date currentDate = Date.today();
        Date toConvert = currentDate.addMonths(-1);
        
        if(dateValue == null) {
            
            dateValue = String.valueOf(toConvert); // change to make the day the first of this month. 
        }
        
        Date dateToCheck = Date.valueOf(dateValue);
        
        if(selectedVal == null) {
            selectedVal = defaultAgent.Agent_Id__c;
        }
    
        
        List<Agent__c> agentStats = [SELECT Id,
                                        Name__c,
                                        Active__c, 
                                        Team__c, 
                                        Agent_ID__c, 
                                        ACHT_Rank__c,
                                        CO7M_Rank__c,
                                        COMM_Rank__c, 
                                        CPD_Rank__c,
                                        DEP_Rank__c,
                                        FUT_Rank__c,
                                        HTP_Rank__c,
                                        QBPA_Rank__c,
                                        QERR_Rank__c,
                                        OT_Rank__c,
                                        SA_Rank__c,
                                        TW_Rank__c,
                                        EHT_Rank__c,
                                        EPD_Rank__c,
                                        Rank_QualEmailPerc__c,
                                        Date__c
                                        FROM Agent__c WHERE Agent_ID__c = :selectedVal 
                                        and Date__c = :dateToCheck
                                        ORDER BY Date__C ASC NULLS LAST];
        
        if (agentStats.isEmpty()) {
            agentStats.add(new Agent__c(ACHT_Rank__c = 0,
                                        CO7M_Rank__c = 0,
                                        COMM_Rank__c = 0, 
                                        CPD_Rank__c = 0,
                                        DEP_Rank__c = 0,
                                        FUT_Rank__c = 0,
                                        OT_Rank__c = 0,
                                        HTP_Rank__c = 0,
                                        QBPA_Rank__c = 0,
                                        QERR_Rank__c = 0,
                                        SA_Rank__c = 0,
                                        EHT_Rank__c = 0,
                                        EPD_Rank__c = 0,
                                        Rank_QualEmailPerc__c = 0,
                                        TW_Rank__c = 0 ));
        }
        
        return agentStats;
    }


    
     
     /**
      * Gets all the stats needed for the agent stats dashboard for one month prior to
      * the selected month. 
      * <p> If the list returned from the query is empty then it adds an agent object 
      * with all stats set to zero to the list. 
      * <p> Also calls the method <code>setPriorVals</code> to set the values that will be 
      * displayed above the linear gauge on the agent stats dash board. 
      *
      * @return list of agent objects containing the stats for one month prior to selected month.
      */
     public List<Agent__c> getAgentStatsTwoMonthsAgo2() {
        system.debug('getAgentStatsTwoMonthsAgo2 was called');
        getAgentsList();
        Date currentDate = Date.today();
        Date toConvert = Date.newInstance(currentDate.year(), currentDate.month(), 1);
        Date dateToCheck = null; 
        if(dateValue == null) {
            dateToCheck = toConvert.addMonths(-1);
        } else {
            dateToCheck = Date.valueOf(dateValue);
        }
        
        //Move the date to check back two months.
        dateToCheck = dateToCheck.addMonths(-1); 
        
        if(selectedVal == null) {
            selectedVal = defaultAgent.Agent_Id__c;
        }
        
        List<Agent__c> agentStats = [SELECT Active__c, 
                                            Team__c, 
                                            Agent_ID__c, 
                                            Quality_Score_BPA__c,
                                            Contacts_Per_Day__c,
                                            Average_Call_Handle_Time__c,
                                            Average_Call_Handle_Time_Double__c,
                                            Hold_Time_Percent__c, Hold_Time_Double__c,
                                            Call_Over_7_Minutes_Percent__c,
                                            Quality_Error_Rate__c,
                                            Quality_Email_Percent__c,
                                            Emails_Per_Day__c, Email_Handle_Time__c, Email_Handle_Time_Double__c,
                                            Schedule_Adherence_Percent__c,
                                            Other_Time__c, Other_Time_Double__c,
                                            Communication_with_Sup__c,
                                            Teamwork__c,
                                            Dependability__c,
                                            Follow_up_time_percent__c, Follow_up_time_Double__c,
                                            Job_Knowledge__c,                        
                                            Resource_Management__c,
                                            Total_Points__c,
                                            supervisor_comments__c,
                                            IsEmailAgent__c,
                                            Date__c
                                            FROM Agent__c WHERE Agent_ID__c = :selectedVal 
                                            and Date__c = :dateToCheck
                                            ORDER BY Date__C ASC NULLS LAST];
             
        List<Agent__c> emptyAgent = new List<Agent__c>(); 
            emptyAgent.add(new Agent__c(
                                        Email_Handle_Time__c = 0, Email_Handle_Time_Double__c = 0, Emails_Per_Day__c = 0,
                                        Average_Call_Handle_Time__c = 0, Average_Call_Handle_Time_Double__c = 0, Contacts_Per_Day__c = 0, 
                                        Hold_Time_Percent__c = 0, Hold_Time_Double__c = 0,  Call_Over_7_Minutes_Percent__c = 0,  
                                        Quality_Score_BPA__c = 0,  Quality_Error_Rate__c = 0, Other_Time__c = 0, Quality_Email_Percent__c = 0,
                                        Schedule_Adherence_Percent__c = 0, Follow_up_time_percent__c = 0, Follow_up_time_double__c = 0,
                                        Communication_with_Sup__c = 0, Dependability__c = 0, Teamwork__c = 0));

        //twoMonthsAgoList = instantiateList(agentStats); 
        twoMonthsAgoList = agentStats; 
        if(!twoMonthsAgoList.isEmpty()){
            setPriorVals(twoMonthsAgoList); 
        } else {
            
            setPriorVals(emptyAgent);
        }

        return agentStats; 
     }
    



    /**
     * Gets a Date object representing the 1st of the August prior to the passed in value. 
     * <p> If 2015-09-01 is passed in it will return 2015-08-01, if 2014-07-01 is passed in it
     * will return 2013-08-01. If 2015-08-01 is passed in, it will return 2015-08-01. 
     * 
     * @param dateValue the currently selected value. 
     * @return a date object representing August prior to the passed in date. 
     */
    public static Date getLastAugust(String dateValue) {
        system.debug('getLastAugust was called');
        //Date now = Date.today(); 
        Date now = Date.valueOf(dateValue); 
        if (now.month() < 8 ) {
            return Date.newInstance(now.year() - 1, 8, 1);
        } else {
            return Date.newInstance(now.year(), 8, 1);
        }
    }
    


    /**
     * Builds an agent object with stats set to zero.
     * @return an agent object with stats all set to zero. 
     */
    public Agent__c getEmptyAgent() {
        Agent__c emptyAgent = new Agent__c(Other_Time__c = 0, Average_Call_Handle_Time__c = 0, Contacts_Per_Day__c = 0, 
                                        Hold_Time_Percent__c = 0,  Call_Over_7_Minutes_Percent__c = 0,  
                                        Quality_Score_BPA__c = 0,  Quality_Error_Rate__c = 0, 
                                        Schedule_Adherence_Percent__c = 0, Follow_up_time_percent__c = 0, 
                                        Communication_with_Sup__c = 0, Dependability__c = 0, Teamwork__c = 0, 
                                        ACHT_Rank__c = 0,
                                        CO7M_Rank__c = 0,
                                        COMM_Rank__c = 0, 
                                        CPD_Rank__c = 0,
                                        DEP_Rank__c = 0,
                                        FUT_Rank__c = 0,
                                        HTP_Rank__c = 0,
                                        QBPA_Rank__c = 0,
                                        QERR_Rank__c = 0,
                                        SA_Rank__c = 0,
                                        TW_Rank__c = 0 );
                                        
        return emptyAgent; 
    }
    


    
    /**
     * Gets a list of AgentStatsWrapper representing all statistics needed
     * for the datatable on AgentStats Dashboard. 
     * @return a list of <code>AgentStatsWrapper</code> containing all necessary statistics. 
     */
    public List<AgentStatsWrapper> getStatList() {
        system.debug('getStatList was called');
        
        Agent__c emptyAgent = getEmptyAgent(); 
        
        //build each list
        //curMonth list
        List<Agent__c> curMonthList = getAgentStatsPrevMonth2();
        Agent__c curentAgent;
        if (curMonthList.isEmpty()) {
            curentAgent = emptyAgent; 
        } else {
            curentAgent = curMonthList[0]; 
        }

        //prevMonth list
        List<Agent__c> prevMonthList = getAgentStatsTwoMonthsAgo2();
        Agent__c prevAgent;
        if (prevMonthList.isEmpty()) {
            prevAgent = emptyAgent; 
        } else {
            prevAgent = prevMonthList[0];
        }
        //ranking List
        List<Agent__C> rankList = getRankings2(); 
        Agent__c agentRank;
        if (rankList.isEmpty()) {
            agentRank = emptyAgent; 
        } else {
            agentRank = rankList[0];
        }
        //Average List
        //Average values 
        Double cpdAvg; 
        Double achtAvg; 
        Double htAvg; 
        Double co7mAvg; 
        Double bpaAvg;
        Double qerrAvg; 
        Double futAvg; 
        Double otAvg;
        Double saAvg; 
        Double commAvg; 
        Double twAvg; 
        Double depAvg; 
        Double ehtAvg; 
        Double epdAvg;
        Double qepAvg; 
        Boolean rvw_aht;
        Boolean rvw_ht;
        Boolean rvw_co7m;
        Boolean rvw_comm;
        Boolean rvw_cpd; 
        Boolean rvw_dep;
        Boolean rvw_fut;
        Boolean rvw_qbpa; 
        Boolean rvw_qerr;
        Boolean rvw_sa;
        Boolean rvw_tw;
        Boolean rvw_ot;
        Boolean rvw_epd;
        Boolean rvw_eht;
        Boolean rvw_QEP; 
        List<AggregateResult> avgList = getYearlyAverages2();
        AggregateResult avg;
        
        
        boolean wasEmailAgent; 
        
        if (avgList.isEmpty()) {
            cpdAvg = 0; 
            achtAvg = 0; 
            htAvg = 0; 
            co7mAvg = 0; 
            bpaAvg = 0;
            qerrAvg = 0; 
            futAvg = 0; 
            saAvg = 0; 
            commAvg = 0; 
            twAvg = 0; 
            depAvg = 0;
            otAvg = 0;
            ehtAvg = 0; 
            epdAvg = 0; 
            qepAvg = 0; 
            wasEmailAgent = false; 
            
        } else {
            avg = avgList[avgList.size() - 1];
            
            cpdAvg = Double.valueOf(avg.get('cpd')); 
            achtAvg = Double.valueOf(avg.get('acht')); 
            htAvg = Double.valueOf(avg.get('ht')); 
            co7mAvg = Double.valueOf(avg.get('co7m')); 
            bpaAvg = Double.valueOf(avg.get('bpa'));
            qerrAvg = Double.valueOf(avg.get('qerr')); 
            futAvg = Double.valueOf(avg.get('fut')); 
            saAvg = Double.valueOf(avg.get('sa')); 
            commAvg = Double.valueOf(avg.get('comm')); 
            twAvg = Double.valueOf(avg.get('tw')); 
            depAvg = Double.valueOf(avg.get('dep')); 
            otAvg = Double.valueof(avg.get('ot'));
            ehtAvg = Double.valueOf(avg.get('eht'));
            epdAvg = Double.valueOf(avg.get('epd'));
            qepAvg = Double.valueOf(avg.get('qep'));

            wasEmailAgent = getEmailHistory();
        }
        
        if(curentAgent.get('IsEmailAgent__c')==null)
            isEmailAgent = false;
        if(curentAgent.get('rvw_ot__c')==null)
            rvw_ot = false;
        if(curentAgent.get('rvw_cpd__c')==null)
            rvw_cpd = false;
        if(curentAgent.get('rvw_aht__c')==null)
            rvw_aht = false;
        if(curentAgent.get('rvw_ht__c')==null)
            rvw_ht = false;
        if(curentAgent.get('rvw_co7m__c')==null)
            rvw_co7m = false;
        if(curentAgent.get('rvw_qbpa__c')==null)
            rvw_qbpa = false;
        if(curentAgent.get('rvw_qerr__c')==null)
            rvw_qerr = false;
        if(curentAgent.get('rvw_fut__c')==null)
            rvw_fut = false;
        if(curentAgent.get('rvw_sa__c')==null)
            rvw_sa = false;
        if(curentAgent.get('rvw_comm__c')==null)
            rvw_comm = false;
        if(curentAgent.get('rvw_tw__c')==null)
            rvw_tw = false;
        if(curentAgent.get('rvw_dep__c')==null)
            rvw_dep = false;
        if(curentAgent.get('rvw_epd__c')==null)
            rvw_epd = false;
        if(curentAgent.get('rvw_eht__c')==null)
            rvw_eht = false;
        if(curentAgent.get('rvw_qep__c')==null)
            rvw_qep = false;

        //build temp agent to send to setAvgVals so that YTD totPoints can be calculated
        Agent__c tempAgent = new Agent__c(); 
        tempAgent.Contacts_Per_Day__c = cpdAvg; 
        tempAgent.Average_Call_Handle_Time_Double__c = achtAvg; 
        tempAgent.Hold_Time_Double__c = htAvg; 
        tempAgent.Call_Over_7_Minutes_Percent__c = co7mAvg; 
        tempAgent.Quality_Score_BPA__c = bpaAvg;
        tempAgent.Quality_Error_Rate__c = qerrAvg;
        tempAgent.Follow_up_time_Double__c = futAvg; 
        tempAgent.Schedule_Adherence_Percent__c = saAvg; 
        tempAgent.Communication_with_Sup__c = commAvg; 
        tempAgent.Teamwork__c = twAvg; 
        tempAgent.Dependability__c = depAvg; 
        tempAgent.Other_Time_Double__c = otAvg; 
        tempAgent.Email_Handle_Time_Double__c = ehtAvg; 
        tempAgent.IsEmailAgent__c = wasEmailAgent;
        tempAgent.Emails_Per_Day__c = epdAvg; 
        tempAgent.Quality_Email_Percent__c = qepAvg; 
        
        setAvgVals(tempAgent); 

        // (String agentTeam, String agentName, String statName, Integer rank, 
        //  Decimal curMonthValue, Decimal prevMonthValue, 
        //  Decimal avg, Boolean statReviewd, Double currMonthValueFormatted, Double prevMonthValueFormatted, 
        //  boolean isEmailCurMonth, boolean isEmailPrevMonth, boolean wasEverEmail, String ApiName)
        
        List<AgentStatsWrapper> statsWrapper = new List<AgentStatsWrapper>(); 
        //add Contacts_Per_Day__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Contacts Per Day', integer.valueOf(agentRank.get('CPD_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Contacts_Per_Day__c')), Double.valueOf(prevAgent.get('Contacts_Per_Day__c')), 
                                                cpdAvg, rvw_cpd , curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c, wasEmailAgent, 'Contacts_Per_Day__c'));
      

      //add Average_Email_Handle_Time_Double__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Avg Email Handle Time', integer.valueOf(agentRank.get('EHT_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Email_Handle_Time_Double__c')), Double.valueOf(prevAgent.get('Email_Handle_Time_Double__c')), 
                                                ehtAvg, rvw_eht, Double.valueOf(curentAgent.get('Email_Handle_Time_Double__c')), Double.valueOf(prevAgent.get('Email_Handle_Time_Double__c')), curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c, wasEmailAgent, 'Email_Handle_Time_Double__c' ));
                                                
       

                                                
        //add Average_Call_Handle_Time__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Average Call Handle Time', integer.valueOf(agentRank.get('ACHT_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Average_Call_Handle_Time_Double__c')), Double.valueOf(prevAgent.get('Average_Call_Handle_Time_Double__c')), 
                                                achtAvg, rvw_aht, Double.valueOf(curentAgent.get('Average_Call_Handle_Time_Double__c')), Double.valueOf(prevAgent.get('Average_Call_Handle_Time_Double__c')),
                                                curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c, wasEmailAgent, 'Average_Call_Handle_Time_Double__c'));
       
        //add Hold_Time_Percent__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Hold Time Percent', integer.valueOf(agentRank.get('HTP_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Hold_Time_Double__c')), Double.valueOf(prevAgent.get('Hold_Time_Double__c')), 
                                                htAvg, rvw_ht, Double.valueOf(curentAgent.get('Hold_Time_Double__c')),  Double.valueOf(prevAgent.get('Hold_Time_Double__c')), curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c, wasEmailAgent, 'Hold_Time_Double__c' )
                                                );
                                                
         //add Other_Time_Time__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Other Time', integer.valueOf(agentRank.get('OT_Rank__c')), 
                                                Double.valueOf(curentAgent.get('other_time_Double__c')), Double.valueOf(prevAgent.get('other_time_Double__c')), 
                                                otAvg, rvw_ot, Double.valueOf(curentAgent.get('other_time_Double__c')), Double.valueOf(prevAgent.get('other_time_Double__c')), curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c, wasEmailAgent, 'Other_Time_Double__c' )
                                                );
        
        //add Follow_up_time_percent__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Follow Up Time Percent', integer.valueOf(agentRank.get('FUT_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Follow_up_time_Double__c')), Double.valueOf(prevAgent.get('Follow_up_time_Double__c')), 
                                                futAvg, rvw_fut, Double.valueOf(curentAgent.get('Follow_up_time_Double__c')), Double.valueOf(prevAgent.get('Follow_up_time_Double__c')), curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c, wasEmailAgent, 'Follow_up_time_Double__c' )
                                                );
                                                
                                                

                                                
        //add Call_Over_7_Minutes_Percent__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Calls Over 7 Minutes Percent', integer.valueOf(agentRank.get('CO7M_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Call_Over_7_Minutes_Percent__c')), Double.valueOf(prevAgent.get('Call_Over_7_Minutes_Percent__c')), 
                                                co7mAvg, rvw_co7m, curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c, wasEmailAgent, 'Call_Over_7_Minutes_Percent__c' ));
        //add Quality_Score_BPA__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Quality Score BPA', integer.valueOf(agentRank.get('QBPA_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Quality_Score_BPA__c')), Double.valueOf(prevAgent.get('Quality_Score_BPA__c')), 
                                                bpaAvg, rvw_qbpa, curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c , wasEmailAgent, 'Quality_Score_BPA__c'));

        //Add quality email percent
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Quality Email %', integer.valueOf(agentRank.get('Rank_QualEmailPerc__c')), 
                                                Double.valueOf(curentAgent.get('Quality_Email_Percent__c')), Double.valueOf(prevAgent.get('Quality_Email_Percent__c')), 
                                                qepAvg, rvw_QEP, curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c , wasEmailAgent, 'Quality_Email_Percent__c'));

        //add Quality_Error_Rate__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Quality Error Rate', integer.valueOf(agentRank.get('QERR_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Quality_Error_Rate__c')), Double.valueOf(prevAgent.get('Quality_Error_Rate__c')), 
                                                qerrAvg, rvw_qerr, curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c , wasEmailAgent, 'Quality_Error_Rate__c'));
       
        //add Schedule_Adherence_Percent__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Schedule Adherence Percent', integer.valueOf(agentRank.get('SA_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Schedule_Adherence_Percent__c')), Double.valueOf(prevAgent.get('Schedule_Adherence_Percent__c')), 
                                                saAvg, rvw_sa , curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c,  wasEmailAgent,'Schedule_Adherence_Percent__c'));
        //add Performance journal feedback (Communication_with_Sup__c)
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Performance Journal Feedback', integer.valueOf(agentRank.get('COMM_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Communication_with_Sup__c')), Double.valueOf(prevAgent.get('Communication_with_Sup__c')), 
                                                commAvg, rvw_comm , curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c,  wasEmailAgent,'Communication_with_Sup__c'));
        //add Teamwork__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Teamwork', integer.valueOf(agentRank.get('TW_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Teamwork__c')), Double.valueOf(prevAgent.get('Teamwork__c')), 
                                                twAvg, rvw_tw , curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c,  wasEmailAgent,'Teamwork__c'));
        //add Dependability__c
        statsWrapper.add(new AgentStatsWrapper( curentAgent.Team__c, curentAgent.Name__c, 'Dependability', integer.valueOf(agentRank.get('DEP_Rank__c')), 
                                                Double.valueOf(curentAgent.get('Dependability__c')), Double.valueOf(prevAgent.get('Dependability__c')), 
                                                depAvg, rvw_dep , curentAgent.IsEmailAgent__c, prevAgent.IsEmailAgent__c,  wasEmailAgent, 'Dependability__c'));

                                        
        //Return stat list
        return statsWrapper; 
    }




    /**
     * Finds if agent was ever an email agent, returns true if they 
     * were, false if they were not
     * @return true if curagent was ever an email agent, false if they were not
     */
    public boolean getEmailHistory() {
        Date lastAugust = getLastAugust(dateValue); 
        List<Agent__c> emailList = [SELECT IsEmailAgent__c, Id from Agent__c 
                WHERE Agent_Id__c = :curAgent.Agent_Id__c AND Date__c >= :lastAugust AND
                Date__c <= :Date.today() AND IsEmailAgent__c = true]; 

        return !emailList.isEmpty(); 
    }
    


    
     /**
      * Gets an aggregate list contaiing the average values for the selected agents
      * stats over the period from the selected date to prior August. 
      * @return list of statistic averages. 
      */
     public List<AggregateResult> getYearlyAverages2() {
        system.debug('getYearlyAverages2 was called');
        getAgentsList();
        Date currentDate = Date.today();
        Date lastAugust = getLastAugust(dateValue);
      
        if(selectedVal == null) {
            selectedVal = defaultAgent.Agent_Id__c;
        }
        
        List<AggregateResult> agentAvgs = [SELECT 
                                            Team__c, 
                                            Agent_ID__c, 
                                            AVG(Quality_Score_BPA__c) bpa,
                                            AVG(Contacts_Per_Day__c) cpd,
                                            AVG(achtNotZero__c) acht,
                                            AVG(Hold_Time_Double__c) ht,
                                            AVG(Call_Over_7_Minutes_Percent__c) co7m,
                                            AVG(Quality_Error_Rate__c) qerr,
                                            AVG(Schedule_Adherence_Percent__c) sa,
                                            AVG(Other_Time_Double__c) ot,
                                            AVG(Communication_with_Sup__c) comm,
                                            AVG(Teamwork__c) tw, 
                                            AVG(Dependability__c) dep,
                                            AVG(Follow_up_time_Double__c) fut,
                                            AVG(Job_Knowledge__c) jk,                        
                                            AVG(Resource_Management__c) rm,
                                            AVG(isEmailEHT__c) eht,
                                            AVG(Emails_Per_Day__c) epd,
                                            AVG(isEmailQEP__c) qep,
                                            AVG(Total_Points__c) tot
                                            FROM Agent__c WHERE Agent_ID__c = :selectedVal 
                                            and Date__c >= :lastAugust AND Date__c <= :Date.today()
                                            
                                            GROUP BY Team__c,  Agent_ID__c];
         
         system.debug('--------------------------Avgs: '+agentAvgs);
         system.debug('Last august is '+lastAugust);

        return agentAvgs;
     }
    
    

    /**
     * Calls all methods necessary for ensuring that 
     * data is loaded for agent stats dashboard
     */
    public void loadStats() {
        getStatList(); 
        //getAgentStatsPrevMonth2();
        //getAgentStatsTwoMonthsAgo2();
        //getRankings2();
        //getYearlyAverages2(); 
    }
    


    /**
     * Makes sure there is a value at each place in list
     * <p> Deprecated: should use <code>initializeList</code> instead. 
     * @Deprecated 
     * @param agentList list of agents to set values for. 
     * @return list of agent object with no null values. 
     */
     public List<Agent__c> instantiateList(List<Agent__c> agentList) {
        system.debug('instantiateList was called');
       /* 0 QBPA, 1 CPD, 2 ACHT, 3 HT, 4 CO7M, 5 QERR, 6 SA, 7 FUT */
        for (Integer i = 0, j = agentList.size(); i < j; ++i) {
            if (isNull(agentList[i].Quality_Score_BPA__c)) {
               agentList[i].Quality_Score_BPA__c = 0; 
            }
            if (isNull(agentList[i].Contacts_Per_Day__c)) {
               agentList[i].Contacts_Per_Day__c = 0; 
            }
            if (isNull(agentList[i].Average_Call_Handle_Time__c)) {
               agentList[i].Average_Call_Handle_Time__c = 0; 
            }
            if (isNull(agentList[i].Hold_Time_Percent__c)) {
               agentList[i].Hold_Time_Percent__c = 0; 
            }
            if (isNull(agentList[i].Call_Over_7_Minutes_Percent__c)) {
               agentList[i].Call_Over_7_Minutes_Percent__c = 0; 
            }
            if (isNull(agentList[i].Quality_Error_Rate__c)) {
               agentList[i].Quality_Error_Rate__c = 0; 
            }
            if (isNull(agentList[i].Schedule_Adherence_Percent__c)) {
               agentList[i].Schedule_Adherence_Percent__c = 0; 
            }
            if (isNull(agentList[i].Follow_up_time_percent__c)) {
               agentList[i].Follow_up_time_percent__c = 0; 
            }
            if (isNull(agentList[i].Communication_with_Sup__c)) {
                agentList[i].Communication_with_Sup__c = 0; 
            }
            if (isNull(agentList[i].Teamwork__c)) {
                agentList[i].Teamwork__c = 0; 
            }
            if (isNull(agentList[i].Dependability__c)) {
                agentList[i].Dependability__c = 0;
            }
        }
        
        return agentList;
        
     }
     


     /**
      * Checks if a passed in value is null. 
      * @param obj Decimal object to check nullness. 
      * @return true if object is null false otherwise. 
      */
     public boolean isNull (Decimal obj) {
        system.debug('isNull was called');
         return (obj == null); 
     }
        
    

    /**
     * Sets the background color and total average points for passed in agent
     * @param the agent object containing average values. 
     */   
    public void setAvgVals(Agent__c avgAgent) {
        system.debug('setAvgVals was called');

        /* Should rebuild this list dynamically from the custom setting
         * Will be using email cs because every stat in the non email cs is in the 
         * email cs. 
         */
         Map<String, AgentStatsScoringLevels_EmailAndCalls__c> statMap = AgentStatsScoringLevels_EmailAndCalls__c.getAll(); 
         List<String> statList = new List<String>(statMap.keySet());
            
        avgTotal = AgentStatistic.getAgentTotalPoints(avgAgent, statList);
        totAvgBackground = tableColorer.getColorCode('total', avgTotal);
        
    }
     


    /**
     * Sets the current values to be used in the agent stats dashboard. 
     * @param agentList list containing agent object to use for setting values. 
     */   
    public void setCurVals (List<Agent__c> agentList) {
         system.debug('setCurVals was called');
        Agent__c agent = agentList.get(0);
        // Get clone of agent object so that you do nto update original 
        // values accidentally. 
        Agent__c copiedAgent = agent.clone(); 

        curCPD = copiedAgent.Contacts_Per_Day__c;
        curAHT = copiedAgent.Average_Call_Handle_Time_Double__c; 
        curAHT_TF = buildTimeString(copiedAgent.Average_Call_Handle_Time_Double__c);
        curHT = copiedAgent.Hold_Time_Double__c;
        curHT_TF = buildTimeString(copiedAgent.Hold_Time_Double__c);
        curCO7M = copiedAgent.Call_Over_7_Minutes_Percent__c;
        curQBPA = copiedAgent.Quality_Score_BPA__c; 
        curQERR = copiedAgent.Quality_Error_Rate__c;
        curSA = copiedAgent.Schedule_Adherence_Percent__c; 
        curFUT = copiedAgent.Follow_up_time_Double__c;
        curFUT_TF = buildTimeString(copiedAgent.Follow_up_time_Double__c);
        curComm = copiedAgent.Communication_with_Sup__c;
        curDep = copiedAgent.Dependability__c; 
        curTW = copiedAgent.Teamwork__c; 

        /* Should rebuild this list dynamically from the custom setting
         * Will be using email cs because every stat in the non email cs is in the 
         * email cs. 
         */
        Map<String, AgentStatsScoringLevels_EmailAndCalls__c> statMap = AgentStatsScoringLevels_EmailAndCalls__c.getAll(); 
        List<String> statList = new List<String>(statMap.keySet());
        
        curTotal = AgentStatistic.getAgentTotalPoints(copiedAgent, statList);
        totBackground = tableColorer.getColorCode('total', curTotal);
    }
    


    /**
     * Returns a string representation of the the seconds passed in 
     * in hh:mm:ss
     * @param seconds the number of seconds to convert. 
     * @return the sting representation of the time in hh:mm:ss
     */
    public String buildTimeString(Decimal seconds) {
        Time zeroTime = Time.newInstance(0, 0, 0, 0);
        Time t = zeroTime.addSeconds(Integer.valueOf(seconds)); 
        String temp = formatZeros(t.hour()) +':'+ formatZeros(t.minute()) +':'+formatZeros(t.second());
        return temp; 
    }
    



    /**
     * Formats number passed in to have a leading zero if it is less than 
     * 10. Otherwise it leaves it as it is. 
     * @param value the number to format
     * @return the string representing the number with a leading 0
     */
    private String formatZeros(integer value) {
        if (value > 10) {
            return String.valueOf(value); 
        } else {
            String temp = '0'; 
            return temp + String.valueOf(value); 
        }
    }
    


    /**
     * Sets the prior values to be used in the agent stats dashboard. 
     * <p> Not necessary to make a copy of the agent object as this object
     * will not be updated in the <code>save</code> method like that the curAgent object will. 
     * 
     * @param agentList list containing agent object to set previous values from. 
     */
    public void setPriorVals (List<Agent__c> agentList) {
        system.debug('setPriorVals was called');
        Agent__c agent = agentList.get(0) ; 
        prevAHT = agent.Average_Call_Handle_Time_Double__c;
        prevAHT_TF = buildTimeString(agent.Average_Call_Handle_Time_Double__c);
        prevCPD = agent.Contacts_Per_Day__c;
        prevHT = agent.Hold_Time_Double__c;
        prevHT_TF = buildTimeString(agent.Hold_Time_Double__c);
        prevCO7M = agent.Call_Over_7_Minutes_Percent__c;
        prevQBPA = agent.Quality_Score_BPA__c; 
        prevQERR = agent.Quality_Error_Rate__c;
        prevSA = agent.Schedule_Adherence_Percent__c; 
        prevFUT = agent.Follow_up_time_Double__c;
        prevFUT_TF = buildTimeString(agent.Follow_up_time_Double__c); 

    }



    /**
     * Creates list of stats to fill charts and then calls <code>fillChartVals</code> 
     * to actually do the filling. 
     * <p> This method seems like a prime candidate for refactoring. As do most of the method in this
     * controller. 
     */
    public void fillCharts() {
        system.debug('fillCharts was called');
        //Get stats for agent over last fiscal year. Starts in August
        Date lastAugust = getLastAugust(dateValue); 
        List<Agent__c> statsList = [SELECT Agent_Id__c, Contacts_Per_Day__c, Average_Call_Handle_Time__c, Hold_Time_Percent__c, Other_Time__c,Hold_Time_Double__c,
                                    Call_Over_7_Minutes_Percent__c, Quality_Score_BPA__c, Quality_Error_Rate__c, Date__c,
                                     rvw_ot__c, rvw_aht__c, rvw_ht__c, rvw_co7m__c, rvw_comm__c,
                                     rvw_cpd__c, rvw_dep__c, rvw_fut__c,  rvw_qbpa__c, 
                                        rvw_qerr__c, rvw_sa__c, rvw_tw__c
                                    FROM Agent__c WHERE Agent_Id__c =: selectedVal AND Date__c >= :lastAugust];
        system.debug('selected value inside of fillCharts is '+selectedVal);
        system.debug('last august inside of fillCarts is '+lastAugust);
        system.debug('The statList is '+statsList);
                                    
        //Calls initializeList from parent class which will set all null values
        //to either 0 or '' if they are a number or string. 
        //(will try and transition all initialization for charts to this). 
        statsList = initializeList(statsList, 'Agent__c'); 
        
        fillChartVals(statsList);                           
    }
    


    /**
     *  Calls individual chart filling methods based off of the month 
     * of the agent object. 
     * @param statList list of agent objects containing all of the stats to 
     * place into the charts on the agent stats dashboard. 
     */
    public void fillChartVals(List<Agent__c> statList) {
        system.debug('fillChartVals was called');
        //Fill all chart variables with 0's in case 
        //they do not have any data associated with them. 
        //If they are null, it will break the page
        fillChartWithZeroes(); 
        
        for (Integer i = 0, j = statList.size(); i < j; ++i) {
            if (statList[i] == null) continue; 
            if (statList[i].date__c.month() == 1) {
                fillJanVals(statList[i]);
            } else if (statList[i].Date__c.month() == 2) {
                fillFebVals(statList[i]);
            } else if (statList[i].Date__c.month() == 3) {
                fillMarVals(statList[i]);
            } else if (statList[i].Date__c.month() == 4) {
                fillAprVals(statList[i]);
            } else if (statList[i].Date__c.month() == 5) {
                fillMayVals(statList[i]);
            } else if (statList[i].Date__c.month() == 6) {
                fillJunVals(statList[i]);
            } else if (statList[i].Date__c.month() == 7) {
                fillJulVals(statList[i]);
            } else if (statList[i].Date__c.month() == 8) {
                fillAugVals(statList[i]);
            } else if (statList[i].Date__c.month() == 9) {
                fillSepVals(statList[i]);
            } else if (statList[i].Date__c.month() == 10) {
                fillOctVals(statList[i]);
            } else if (statList[i].Date__c.month() == 11) {
                fillNovVals(statList[i]);
            } else if (statList[i].Date__c.month() == 12) {
                fillDecVals(statList[i]);
            }
        }
    }
    

    /**
     * Sets January chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillJanVals(Agent__c a) {
        system.debug('Filling janVlas for : '+a.Agent_Id__c); 
        janCPD = Math.round(a.Contacts_Per_Day__c);
        janAHT = a.Average_Call_Handle_Time__c.setScale(2);
        janHT = (a.Hold_Time_double__c ) ;
        janCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        janQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        janQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        janRVW_CPD = a.rvw_cpd__c;
        janRVW_HT  = a.rvw_ht__c;
 
        janRVW_AHT = a.rvw_aht__c;
        janRVW_CO7M = a.rvw_co7m__c;
        janRVW_COMM = a.rvw_comm__c;
        janRVW_DEP  = a.rvw_dep__c;
        janRVW_FUT  = a.rvw_fut__c;
        janRVW_QBPA = a.rvw_qbpa__c;
        janRVW_QERR = a.rvw_qerr__c;
        janRVW_SA   = a.rvw_sa__c;
        janRVW_TW   = a.rvw_tw__c;
        janRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets February chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillFebVals(Agent__c a) {
        febCPD = Math.round(a.Contacts_Per_Day__c);
        febAHT = a.Average_Call_Handle_Time__c.setScale(2);
        febHT = (a.Hold_Time_double__c ) ;
        febCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        febQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        febQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        febRVW_CPD = a.rvw_cpd__c;
        febRVW_HT  = a.rvw_ht__c;
         
        febRVW_AHT = a.rvw_aht__c;
        febRVW_CO7M = a.rvw_co7m__c;
        febRVW_COMM = a.rvw_comm__c;
        febRVW_DEP  = a.rvw_dep__c;
        febRVW_FUT  = a.rvw_fut__c;
        febRVW_QBPA = a.rvw_qbpa__c;
        febRVW_QERR = a.rvw_qerr__c;
        febRVW_SA   = a.rvw_sa__c;
        febRVW_TW   = a.rvw_tw__c;
        febRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets March chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillMarVals(Agent__c a) {
        marCPD = Math.round(a.Contacts_Per_Day__c);
        marAHT = a.Average_Call_Handle_Time__c.setScale(2);
        marHT = (a.Hold_Time_double__c ) ;
        marCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        marQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        marQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        marRVW_CPD = a.rvw_cpd__c;
        marRVW_HT  = a.rvw_ht__c;
         
        marRVW_AHT = a.rvw_aht__c;
        marRVW_CO7M = a.rvw_co7m__c;
        marRVW_COMM = a.rvw_comm__c;
        marRVW_DEP  = a.rvw_dep__c;
        marRVW_FUT  = a.rvw_fut__c;
        marRVW_QBPA = a.rvw_qbpa__c;
        marRVW_QERR = a.rvw_qerr__c;
        marRVW_SA   = a.rvw_sa__c;
        marRVW_TW   = a.rvw_tw__c;
        marRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets April chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillAprVals(Agent__c a) {
        aprCPD = Math.round(a.Contacts_Per_Day__c);
        aprAHT = a.Average_Call_Handle_Time__c.setScale(2);
        aprHT = (a.Hold_Time_double__c ) ;
        aprCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        aprQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        aprQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        aprRVW_CPD = a.rvw_cpd__c;
        aprRVW_HT  = a.rvw_ht__c;
         
        aprRVW_AHT = a.rvw_aht__c;
        aprRVW_CO7M = a.rvw_co7m__c;
        aprRVW_COMM = a.rvw_comm__c;
        aprRVW_DEP  = a.rvw_dep__c;
        aprRVW_FUT  = a.rvw_fut__c;
        aprRVW_QBPA = a.rvw_qbpa__c;
        aprRVW_QERR = a.rvw_qerr__c;
        aprRVW_SA   = a.rvw_sa__c;
        aprRVW_TW   = a.rvw_tw__c;
        aprRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets May chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillMayVals(Agent__c a) {
        mayCPD = Math.round(a.Contacts_Per_Day__c);
        mayAHT = a.Average_Call_Handle_Time__c.setScale(2);
        mayHT = (a.Hold_Time_double__c ) ;
        mayCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        mayQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        mayQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        mayRVW_CPD = a.rvw_cpd__c;
        mayRVW_HT  = a.rvw_ht__c; 
        mayRVW_AHT = a.rvw_aht__c;
        mayRVW_CO7M = a.rvw_co7m__c;
        mayRVW_COMM = a.rvw_comm__c;
        mayRVW_DEP  = a.rvw_dep__c;
        mayRVW_FUT  = a.rvw_fut__c;
        mayRVW_QBPA = a.rvw_qbpa__c;
        mayRVW_QERR = a.rvw_qerr__c;
        mayRVW_SA   = a.rvw_sa__c;
        mayRVW_TW   = a.rvw_tw__c;
        mayRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets June chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillJunVals(Agent__c a) {
        junCPD = Math.round(a.Contacts_Per_Day__c);
        junAHT = a.Average_Call_Handle_Time__c.setScale(2);
        junHT = (a.Hold_Time_double__c ) ;
        junCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        junQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        junQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        junRVW_CPD = a.rvw_cpd__c;
        junRVW_HT  = a.rvw_ht__c;
         
        junRVW_AHT = a.rvw_aht__c;
        junRVW_CO7M = a.rvw_co7m__c;
        junRVW_COMM = a.rvw_comm__c;
        junRVW_DEP  = a.rvw_dep__c;
        junRVW_FUT  = a.rvw_fut__c;
        junRVW_QBPA = a.rvw_qbpa__c;
        junRVW_QERR = a.rvw_qerr__c;
        junRVW_SA   = a.rvw_sa__c;
        junRVW_TW   = a.rvw_tw__c;
        junRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets July chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillJulVals(Agent__c a) {
        julCPD = Math.round(a.Contacts_Per_Day__c);
        julAHT = a.Average_Call_Handle_Time__c.setScale(2);
        julHT = (a.Hold_Time_double__c ) ;
        julCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        julQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        julQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        julRVW_CPD = a.rvw_cpd__c;
        julRVW_HT  = a.rvw_ht__c;
         
        julRVW_AHT = a.rvw_aht__c;
        julRVW_CO7M = a.rvw_co7m__c;
        julRVW_COMM = a.rvw_comm__c;
        julRVW_DEP  = a.rvw_dep__c;
        julRVW_FUT  = a.rvw_fut__c;
        julRVW_QBPA = a.rvw_qbpa__c;
        julRVW_QERR = a.rvw_qerr__c;
        julRVW_SA   = a.rvw_sa__c;
        julRVW_TW   = a.rvw_tw__c;
        julRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets August chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillAugVals(Agent__c a) {
        augCPD = Math.round(a.Contacts_Per_Day__c);
        augAHT = a.Average_Call_Handle_Time__c.setScale(2);
        augHT = (a.Hold_Time_double__c ) ;
        augCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        augQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        augQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        augRVW_CPD = a.rvw_cpd__c;
        augRVW_HT  = a.rvw_ht__c;
         
        augRVW_AHT = a.rvw_aht__c;
        augRVW_CO7M = a.rvw_co7m__c;
        augRVW_COMM = a.rvw_comm__c;
        augRVW_DEP  = a.rvw_dep__c;
        augRVW_FUT  = a.rvw_fut__c;
        augRVW_QBPA = a.rvw_qbpa__c;
        augRVW_QERR = a.rvw_qerr__c;
        augRVW_SA   = a.rvw_sa__c;
        augRVW_TW   = a.rvw_tw__c;
        augRVW_OT = a.rvw_ot__c;
        
    }
    

    /**
     * Sets September chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillSepVals(Agent__c a) {
        sepCPD = Math.round(a.Contacts_Per_Day__c);
        sepAHT = a.Average_Call_Handle_Time__c.setScale(2);
        sepHT = (a.Hold_Time_double__c ) ;
        sepCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        sepQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        sepQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        sepRVW_CPD = a.rvw_cpd__c;
        sepRVW_HT  = a.rvw_ht__c;
         
        sepRVW_AHT = a.rvw_aht__c;
        sepRVW_CO7M = a.rvw_co7m__c;
        sepRVW_COMM = a.rvw_comm__c;
        sepRVW_DEP  = a.rvw_dep__c;
        sepRVW_FUT  = a.rvw_fut__c;
        sepRVW_QBPA = a.rvw_qbpa__c;
        sepRVW_QERR = a.rvw_qerr__c;
        sepRVW_SA   = a.rvw_sa__c;
        sepRVW_TW   = a.rvw_tw__c;
        sepRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets October chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillOctVals(Agent__c a) {
        octCPD = Math.round(a.Contacts_Per_Day__c);
        octAHT = a.Average_Call_Handle_Time__c.setScale(2);
        octHT = (a.Hold_Time_double__c ) ;
        octCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        octQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        octQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        octRVW_CPD = a.rvw_cpd__c;
        octRVW_CPD = a.rvw_ht__c;
         
        octRVW_AHT = a.rvw_aht__c;
        octRVW_CO7M = a.rvw_co7m__c;
        octRVW_COMM = a.rvw_comm__c;
        octRVW_DEP  = a.rvw_dep__c;
        octRVW_FUT  = a.rvw_fut__c;
        octRVW_QBPA = a.rvw_qbpa__c;
        octRVW_QERR = a.rvw_qerr__c;
        octRVW_SA   = a.rvw_sa__c;
        octRVW_TW   = a.rvw_tw__c;
        octRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets November chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillNovVals(Agent__c a) {
        novCPD = Math.round(a.Contacts_Per_Day__c);
        novAHT = a.Average_Call_Handle_Time__c.setScale(2);
        novHT = (a.Hold_Time_double__c ) ;
        novCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        novQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        novQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        novRVW_CPD = a.rvw_cpd__c;
        novRVW_CPD = a.rvw_ht__c;
         
        novRVW_AHT = a.rvw_aht__c;
        novRVW_CO7M = a.rvw_co7m__c;
        novRVW_COMM = a.rvw_comm__c;
        novRVW_DEP  = a.rvw_dep__c;
        novRVW_FUT  = a.rvw_fut__c;
        novRVW_QBPA = a.rvw_qbpa__c;
        novRVW_QERR = a.rvw_qerr__c;
        novRVW_SA   = a.rvw_sa__c;
        novRVW_TW   = a.rvw_tw__c;
        novRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Sets December chart variable
     * @param the agent object to use for setting values. 
     */
    public void fillDecVals(Agent__c a) {
        decCPD = Math.round(a.Contacts_Per_Day__c);
        decAHT = a.Average_Call_Handle_Time__c.setScale(2);
        decHT = (a.Hold_Time_double__c ) ;
        decCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        decQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        decQERR = (a.Quality_Error_Rate__c) .setScale(2); 
        decRVW_CPD = a.rvw_cpd__c;
        decRVW_HT  = a.rvw_ht__c;
         
        decRVW_AHT = a.rvw_aht__c;
        decRVW_CO7M = a.rvw_co7m__c;
        decRVW_COMM = a.rvw_comm__c;
        decRVW_DEP  = a.rvw_dep__c;
        decRVW_FUT  = a.rvw_fut__c;
        decRVW_QBPA = a.rvw_qbpa__c;
        decRVW_QERR = a.rvw_qerr__c;
        decRVW_SA   = a.rvw_sa__c;
        decRVW_TW   = a.rvw_tw__c;
        decRVW_OT = a.rvw_ot__c;
    }
    

    /**
     * Creates an agent object with zeroes for all statisics 
     * and used this obkect to fill all chart variables with zeroes.
     */
    public void fillChartWithZeroes() {
        system.debug('fillChartWithZeroes was called');
        //create empty agent
        Agent__c emptyAgent = new Agent__c(); 
        emptyAgent.Contacts_Per_Day__c = 0; 
        emptyAgent.Average_Call_Handle_Time__c = 0;
        emptyAgent.Hold_Time_Percent__c = 0; 
        emptyAgent.Call_Over_7_Minutes_Percent__c = 0; 
        emptyAgent.Quality_Score_BPA__c = 0; 
        emptyAgent.Quality_Error_Rate__c = 0;
        emptyAgent.Hold_Time_Double__c = 0; 
        emptyAgent.rvw_cpd__c = false;
        
        //fill all charts with empty agent
        fillJanVals(emptyAgent); 
        fillFebVals(emptyAgent); 
        fillMarVals(emptyAgent); 
        fillAprVals(emptyAgent); 
        fillMayVals(emptyAgent);
        fillJunVals(emptyAgent); 
        fillJulVals(emptyAgent); 
        fillAugVals(emptyAgent); 
        fillSepVals(emptyAgent); 
        fillOctVals(emptyAgent); 
        fillNovVals(emptyAgent); 
        fillDecVals(emptyAgent); 
    }

}