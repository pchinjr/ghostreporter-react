/**
 * Controller for agentStats_R. 
 * This class handles the data and all operations involving the data that 
 * is used on the agentStats_R visual force page
 * @author Mike McGee & Ruben Ortiz
 * 
 */ 

global with sharing class AgentController_m extends PageController {

    public String selectedVal{get;set;}  // This will hold the selected value, the id in here
    public String dateValue{get;set;}  //This will hold date value selected in pickl list
    public String agentTeam{get;set;}
    public String agentName{get;set;}
    public String renderMode{get;set;} //Render style for page
    
    public Agent__c defaultAgent{get;set;}
    
    //Maps for assigning color values to table cells. 
    public Map<String, List<String>> statLevelMap {get;set;}
    
    public double SA_average{get;set;} 
    public double FUT_average{get;set;} 
    
    //Lists for metric table
    public List<Agent__c> prevMonthList {get;set;}
    public List<Agent__c> twoMonthsAgoList {get;set;}
    //Current Score list 
    public String name{get;set;}
    public Agent__c curAgent{get;set;}
    public Decimal curTotal{get;set;}
    public String curMonth{get;set;}
    public String totBackground{get;set;}
    public Integer totPoints{get;set;}
    //prior score list
    public Agent__c prevAgent{get;set;}
    //Charts wrapper
    public AgentStatsWrapper chartWrapper{get;set;}
    
    /*********************************
     * Chart data 
     ********************************/
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
    
    List<String> statApexNames = new String[]{'Contacts_Per_Day__c', 'Average_Call_Handle_Time__c', 
            'Hold_Time_Percent__c', 'Call_Over_7_Minutes_Percent__c', 'Quality_Score_BPA__c', 
            'Quality_Error_Rate__c', 'Follow_up_time_percent__c', 'Schedule_Adherence_Percent__c', 
            'Communication_with_Sup__c', 'Teamwork__c', 'Dependability__c'};
    
    
    private List<String> months = new String[]{'','January', 'February', 'March', 'April', 'May', 'June',
                                       'July', 'August', 'September', 'October', 'November', 'December'};
                                       
    //Dates for queries 
    Date prevMonthDate; 
    Date twoMonthsAgoDate; 
                                          
	//selectlist builders, one for each unique select list
    private AgentSelectListBuilder agentSelectListBuilderType; 
    private DateSelectListBuilder dateSelectListBuilderType;

    private ColorCode tableColorer; 
    
    
    /**
     * Constructor must allocate values for all table variables, and initialize lists for charts
     * 
     */
    public AgentController_m() {
        system.debug('Constructor was called');
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        renderMode = '';
        tableColorer = ColorCode.getInstace(); 
        selectListBuilderType = new AgentSelectListBuilder();
		agentSelectListBuilderType = new AgentSelectListBuilder();
        dateSelectListBuilderType = new DateSelectListBuilder(); 
        //Set selectedVal if it is null. 
        if (selectedVal == null) {
            selectedVal = getAgentsList().get(0).getValue(); 
        }
        setDates(); 
        setCurAgent(); 
        setPrevAgent(); 
        fillCharts(); 
    }
    
    /**
     * Sets the dates to be used in the stats queries. 
     * <p>
     * sets prevMonthDate to to the selected date if a date has been selected. 
     * If no date has been selected yet, then it sets the prevMonthDate to 
     * todays date minus 1 month. Then sets the twoMonthsAgoDate to minus 1 from 
     * the prevMonthDate
     * 
     * @author Mike McGee 
     */
    private void setDates() {
        system.debug('setDates was called'); 
        Date currentDate = Date.today();
        if(dateValue != null) {
            system.debug('Date value is: '+dateValue); 
            prevMonthDate = Date.valueOf(dateValue);
        } else {
            Date holderDate = currentDate.addMonths(-1);
            prevMonthDate = Date.newInstance(holderDate.year(), holderDate.month(), 1); 
        }
        
        twoMonthsAgoDate = prevMonthDate.addMonths(-1); 
    }
    
    //Changes render mode to pdf on button click. 
    public void convertToPdf() {
        renderMode = 'pdf'; 
    }

    /**
     * Builds date list for selector on VF page
     * 
     * @author Mike McGee 
     * @return list of dates starting with prior month in desc order
     */ 
    public List<SelectOption> getDateList() {
        system.debug('getDateList was called');
        return dateSelectListBuilderType.buildAgentDateSelectList();
    }
    
    
    /**
    * Builds list of agent names for the agent select List
    * <p> 
    * Selects list from Agent__c object
    * 
    * @auhtor Mike McGee 
    * @return select option list for agents in Agent__c object. 
    */
    public List<SelectOption> getAgentsList() {
        system.debug('getAgentList was called');
       	List<Agent__c> agents = [SELECT Name__c, Agent_ID__c FROM Agent__c ORDER BY Name__c ASC NULLS LAST];
        defaultAgent = agents.get(0);
        return agentSelectListBuilderType.getAgentList();
    }


    /**
     * Saves any updates that have been made to the curAgent. 
     * <p>
     * Uses an update DML to save changes. If no curAgent object exists for the 
     * selected month (which shouldn't happen) then a new record is inserted. 
     * 
     * @author Mike McGee 
     */
    public void save() {
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
            update curAgent;
        }
    }
    
    /**
     * Gets the date corresponding to August of the current fiscal year. 
     * <p>
     * needed for some queries where the whole fiscal year is required. 
     * 
     * @author Mike McGee
     * @return Date object corresponding to August of selected fiscal year. 
     */
    public static Date getLastAugust() {
        Date now = Date.today(); 
        if (now.month() < 8 ) {
            return Date.newInstance(now.year() - 1, 8, 1);
        } else {
            return Date.newInstance(now.year(), 8, 1);
        }
    }
    
    /**
     * Sets the curTotal and totBackground fields to be used in AgentStats page. 
     * 
     * @author Mike McGee 
     */
    public void setCurTotal(Agent__c agent, List<String> statsList) {
        curTotal = AgentStatistic.getAgentTotalPoints(agent, statsList); 
        totBackground = tableColorer.getColorCode('total', curTotal); 
    }
    
    
    /**
     * Sets the current agent to be used in the charts and input fields. 
     * <p>
     * gets the Agent__c object corresponding to the currently selected date and 
     * Agent Id fields. 
     * 
     * @author Mike McGee 
     */
     public void setCurAgent() {
        system.debug('setCurAgent was called'); 
        system.debug('Date inside setCurAgent is: '+prevMonthDate); 
        //curAgent = QUERY for all needed stats where Date__c is current month 
        List<Agent__c> temp = [SELECT Name__c, Quality_Score_BPA__c, Contacts_Per_Day__c,
                                        Average_Call_Handle_Time__c, Hold_Time_Percent__c,
                                        Call_Over_7_Minutes_Percent__c, Quality_Error_Rate__c,
                                        Schedule_Adherence_Percent__c, Communication_with_Sup__c,
                                        Teamwork__c, Dependability__c, Follow_up_time_percent__c,
                                        Supervisor_Comments__c, Comments_notFormatted__c, RVW_CPD__c, 
                                        RVW_AHT__c, RVW_HT__c, RVW_CO7M__c, RVW_QBPA__c, RVW_QERR__c, 
                                        RVW_FUT__c, RVW_SA__c, RVW_COMM__c,RVW_DEP__c, RVW_TW__c, Date__c 
                                        FROM Agent__c WHERE Agent_ID__c = : selectedVal and Date__c = :prevMonthDate]; 
                                        
        // If temp is empty then nothing got returned from query meaning no 
        // Agent__c object exists for that month, place an emptyAgent in its place
        if (temp.isEmpty()) {
            temp.add(new Agent__c()); 
        }
        temp = initializeList(temp, 'Agent__c'); 
        curAgent = temp.get(0); 
        
        setCurTotal(curAgent, statApexNames); 
     }
     
     /**
     * Sets the prevAgent field to be used in the charts and input fields. 
     * <p>
     * gets the Agent__c object corresponding to one month prior to the 
     * currently selected date and Agent Id fields. 
     * 
     * @author Mike McGee 
      */
      public void setPrevAgent() {
          system.debug('setPrevAgent was called');
          system.debug('Date inside set prevAgent is: '+twoMonthsAgoDate); 
          //prevAgent = QUERY for all needed stats where Date__c is prev month.
          List<Agent__c> temp = [SELECT Name__c, Quality_Score_BPA__c, Contacts_Per_Day__c,
                                        Average_Call_Handle_Time__c, Hold_Time_Percent__c,
                                        Call_Over_7_Minutes_Percent__c, Quality_Error_Rate__c,
                                        Schedule_Adherence_Percent__c, Communication_with_Sup__c,
                                        Teamwork__c, Dependability__c, Follow_up_time_percent__c,
                                        Supervisor_Comments__c, Comments_notFormatted__c, Date__c 
                                        FROM Agent__c WHERE Agent_ID__c = : selectedVal and Date__c = :twoMonthsAgoDate];
                                        
        // If temp is empty then nothing got returned from query meaning no 
        // Agent__c object exists for that month, place an emptyAgent in its place
        if (temp.isEmpty()) {
            temp.add(new Agent__c()); 
        }
        temp = initializeList(temp, 'Agent__c'); 
        prevAgent = temp.get(0); 
      }
    
    /**
     * Builds list of stats to be used in datatable
     * <p>
     * Uses StatWrapper and Statistic and AgentStatistic to build list of stats 
     * for the datatable. Performs two SOQL select statements to pull all 
     * necessary data. Then loops through those lists adding them to the statMap 
     * associated with the StatWrapper class. This maps values is the list that 
     * gets returned/ 
     * 
     * @author Mike McGee
     * @return list of statistics corresponding to currently selected agent.  
     */
    public List<Statistic> getStatList() {
        system.debug('getStatList was called'); 
        system.debug('Inside getStatList selectedVal = '+selectedVal); 
        
        //Clear static statMap so it won't have any previous agent's values in it. 
        StatWrapper.clearStatMap(); 
        Date lastAugust = getLastAugust();
            
        List<String> statNames = new String[]{'Contacts Per Day', 'Average Call Handle Time', 
            'Hold Time Percent', 'Calls Over 7 Minutes Percent', 'Quality Score BPA', 
            'Quality Error Rate', 'Follow Up Time Percent', 'Schedule Adherence Percent', 
            'Performance Journal Feedback', 'Teamwork', 'Dependability'};
            
        List<String> rankNames = new String[]{'CPD_Rank__c', 'ACHT_Rank__c', 'HTP_Rank__c', 
            'CO7M_Rank__c', 'QBPA_Rank__c', 'QERR_Rank__c', 'FUT_Rank__c', 'SA_Rank__c', 
            'COMM_Rank__c', 'TW_Rank__c', 'DEP_Rank__c'};
        
        // Select all stats needed for the past fiscal year (starts in august)
        List<Agent__c> aList = [SELECT Quality_Score_BPA__c, Contacts_Per_Day__c,
                                        Average_Call_Handle_Time__c, Hold_Time_Percent__c,
                                        Call_Over_7_Minutes_Percent__c, Quality_Error_Rate__c,
                                        Schedule_Adherence_Percent__c, Communication_with_Sup__c,
                                        Teamwork__c, Dependability__c, Follow_up_time_percent__c, Date__c 
                                        FROM Agent__c WHERE Agent_ID__c = : selectedVal and Date__c >:lastAugust];
        //select all ranks for this month only. 
        List<Agent__c> rankList = [SELECT ACHT_Rank__c, CO7M_Rank__c,COMM_Rank__c, 
                                  CPD_Rank__c, DEP_Rank__c, FUT_Rank__c, HTP_Rank__c,
                                  QBPA_Rank__c, QERR_Rank__c, SA_Rank__c, TW_Rank__c, Date__c
                                  FROM Agent__c WHERE Agent_ID__c = : selectedVal and Date__c = :prevMonthDate];
                                  
        
        // If lists are empty then no agent object exsts for the selected agent
        // during the current month. Since we want the charts to load anyway 
        // we need to add an empty agent to each list. 
        if (aList.isEmpty()) {
            aList.add(new Agent__c(Date__c = prevMonthDate)); 
        }
        if (rankList.isEmpty()) {
            rankList.add(new Agent__c(Date__c = prevMonthDate)); 
        }
        //Need to initialize both lists so that charts show up even when empty
        aList = initializeList(aList, 'Agent__c'); 
        system.debug('aList after initializeList: '+aList); 
        rankList = initializeList(rankList, 'Agent__c'); 
                                  
        //add stats to wrapper
        for (Agent__c a: aList) {
            for (Integer i = 0; i < statApexNames.size(); ++i) {
                new StatWrapper(statNames[i], Double.valueOf(a.get(statApexNames[i])), Date.valueOf(a.get('Date__c')), prevMonthDate); 
            }
        }
        //Add ranks to wrapper. 
        for (Agent__c a: rankList) {
            for (Integer i = 0; i < statNames.size(); ++i) {
                new StatWrapper(statNames[i], Integer.valueOf(a.get(rankNames[i]))); 
            }
        }
        
        //return the new list.
        return StatWrapper.getStatList(); 
    }

    /**
     * Loads all the stats needed for the charts and table to load. 
     * <p> 
     * Gets called after every change of the selected agent object to ensure 
     * that data for new agent is loaded in, so that charts and table will load. 
     * 
     * @author Mike McGee 
     */
    public void loadStats() {
        system.debug('loadStats was called'); 
        setDates(); 
        getStatList(); 
        setCurAgent(); 
        setPrevAgent(); 
        fillCharts(); 
    }
        
    /**
     * gets the hex color code for the stat passed in
     * <p>
     * uses ColorCode to assign background colors to the datatable. 
     * 
     * @author Mike McGee 
     * @return hex code for color 
     */
    public String getColorCode(String statName, Integer statValue) {
        return tableColorer.getColorCode(statName, statValue);
    }

    /**************************************************************************
     * Below here is all for the line charts 
     * 
     * ************************************************************************/
    
    /**
     * Fills all of the data needed for the graphs on AgentStats page tab 2. 
     * <p> 
     * Simply performs the select statement for all of the data that will be needed. 
     * then calls the fillChartVals method passing in the data. 
     * 
     * @author Mike McGee 
     */
    public void fillCharts() {
        system.debug('fillCharts was called');
        //Get stats for agent over last fiscal year. Starts in August
        Date lastAugust = getLastAugust(); 
        List<Agent__c> statsList = [SELECT Agent_Id__c, Contacts_Per_Day__c, Average_Call_Handle_Time__c, Hold_Time_Percent__c,
                                    Call_Over_7_Minutes_Percent__c, Quality_Score_BPA__c, Quality_Error_Rate__c, Date__c,
                                     rvw_aht__c, rvw_ht__c, rvw_co7m__c, rvw_comm__c,
                                     rvw_cpd__c, rvw_dep__c, rvw_fut__c,  rvw_qbpa__c, 
                                        rvw_qerr__c, rvw_sa__c, rvw_tw__c
                                    FROM Agent__c WHERE Agent_Id__c =: selectedVal AND Date__c > :lastAugust];
                                    
        statsList = initializeList(statsList, 'Agent__c'); 
        
        fillChartVals(statsList);                           
    }
    
    /**
     * Fills month fields for graphs on AgentStats page with each months data. 
     * <p>
     * calls specific fillMonthVals method based off the Date__c field associated
     * with the current working Agent__c object. 
     * 
     * @author Mike McGee 
     * @param statList list of Agent__c objects to fill graph data with. 
     */
    public void fillChartVals(List<Agent__c> statList) {
        system.debug('fillChartVals was called');
        //Fill all chart variables with 0's in case 
        //they do not have any data associated with them. 
        //If they are null, it will break the page
        fillChartWithZeroes(); 
        
        for (Agent__c a: statList) {
            if (a.date__c.month() == 1) {
                fillJanVals(a);
            } else if (a.Date__c.month() == 2) {
                fillFebVals(a);
            } else if (a.Date__c.month() == 3) {
                fillMarVals(a);
            } else if (a.Date__c.month() == 4) {
                fillAprVals(a);
            } else if (a.Date__c.month() == 5) {
                fillMayVals(a);
            } else if (a.Date__c.month() == 6) {
                fillJunVals(a);
            } else if (a.Date__c.month() == 7) {
                fillJulVals(a);
            } else if (a.Date__c.month() == 8) {
                fillAugVals(a);
            } else if (a.Date__c.month() == 9) {
                fillSepVals(a);
            } else if (a.Date__c.month() == 10) {
                fillOctVals(a);
            } else if (a.Date__c.month() == 11) {
                fillNovVals(a);
            } else if (a.Date__c.month() == 12) {
                fillDecVals(a);
            }
        }
    }
    
    public void fillJanVals(Agent__c a) {
        janCPD = Math.round(a.Contacts_Per_Day__c);
        janAHT = a.Average_Call_Handle_Time__c.setScale(2);
        janHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillFebVals(Agent__c a) {
        febCPD = Math.round(a.Contacts_Per_Day__c);
        febAHT = a.Average_Call_Handle_Time__c.setScale(2);
        febHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillMarVals(Agent__c a) {
        marCPD = Math.round(a.Contacts_Per_Day__c);
        marAHT = a.Average_Call_Handle_Time__c.setScale(2);
        marHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillAprVals(Agent__c a) {
        aprCPD = Math.round(a.Contacts_Per_Day__c);
        aprAHT = a.Average_Call_Handle_Time__c.setScale(2);
        aprHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillMayVals(Agent__c a) {
        mayCPD = Math.round(a.Contacts_Per_Day__c);
        mayAHT = a.Average_Call_Handle_Time__c.setScale(2);
        mayHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillJunVals(Agent__c a) {
        junCPD = Math.round(a.Contacts_Per_Day__c);
        junAHT = a.Average_Call_Handle_Time__c.setScale(2);
        junHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillJulVals(Agent__c a) {
        julCPD = Math.round(a.Contacts_Per_Day__c);
        julAHT = a.Average_Call_Handle_Time__c.setScale(2);
        julHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillAugVals(Agent__c a) {
        augCPD = Math.round(a.Contacts_Per_Day__c);
        augAHT = a.Average_Call_Handle_Time__c.setScale(2);
        augHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
        
    }
    
    public void fillSepVals(Agent__c a) {
        sepCPD = Math.round(a.Contacts_Per_Day__c);
        sepAHT = a.Average_Call_Handle_Time__c.setScale(2);
        sepHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillOctVals(Agent__c a) {
        octCPD = Math.round(a.Contacts_Per_Day__c);
        octAHT = a.Average_Call_Handle_Time__c.setScale(2);
        octHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillNovVals(Agent__c a) {
        novCPD = Math.round(a.Contacts_Per_Day__c);
        novAHT = a.Average_Call_Handle_Time__c.setScale(2);
        novHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
    public void fillDecVals(Agent__c a) {
        decCPD = Math.round(a.Contacts_Per_Day__c);
        decAHT = a.Average_Call_Handle_Time__c.setScale(2);
        decHT = (a.Hold_Time_Percent__c ).setScale(2) ;
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
    }
    
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