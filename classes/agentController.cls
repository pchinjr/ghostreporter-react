/**
 * Controller for agentStats_R. 
 * This class handles the data and all operations involving the data that 
 * is used on the agentStats_R visual force page
 * @author Mike McGee & Ruben Ortiz
 * 
 */ 

global with sharing class agentController extends PageController {

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
    public Decimal curCPD{get;set;}
    public Decimal curAHT{get;set;}
    public Decimal curHT{get;set;}
    public Decimal curCO7M{get;set;}
    public Decimal curQBPA{get;set;}
    public Decimal curQERR{get;set;}
    public Decimal curSA{get;set;}
    public Decimal curFUT{get;set;}
    public Decimal curComm{get;set;}
    public Decimal curDep{get;set;}
    public Decimal curTW{get;set;}
    public Decimal curTotal{get;set;}
    public String curMonth{get;set;}
    public String totBackground{get;set;}
    public Integer totPoints{get;set;}
    //prior score list
    public Decimal prevCPD{get;set;}
    public Decimal prevAHT{get;set;}
    public Decimal prevHT{get;set;}
    public Decimal prevCO7M{get;set;}
    public Decimal prevQBPA{get;set;}
    public Decimal prevQERR{get;set;}
    public Decimal prevSA{get;set;}
    public Decimal prevFUT{get;set;}
    //Charts wrapper
    public AgentStatsWrapper chartWrapper{get;set;}
    public Map<Integer, Map<String, Decimal>> monthMap{get;set;}
    
    //Chart data 
    //August data
    public Decimal augCPD{get;set;}
    public Decimal augAHT{get;set;}
    public Decimal augHT{get;set;}
    public Decimal augCO7M{get;set;}
    public Decimal augQBPA{get;set;}
    public Decimal augQERR{get;set;}
    //September data
    public Decimal sepCPD{get;set;}
    public Decimal sepAHT{get;set;}
    public Decimal sepHT{get;set;}
    public Decimal sepCO7M{get;set;}
    public Decimal sepQBPA{get;set;}
    public Decimal sepQERR{get;set;}
    //October Data
    public Decimal octCPD{get;set;}
    public Decimal octAHT{get;set;}
    public Decimal octHT{get;set;}
    public Decimal octCO7M{get;set;}
    public Decimal octQBPA{get;set;}
    public Decimal octQERR{get;set;}
    //November Data
    public Decimal novCPD{get;set;}
    public Decimal novAHT{get;set;}
    public Decimal novHT{get;set;}
    public Decimal novCO7M{get;set;}
    public Decimal novQBPA{get;set;}
    public Decimal novQERR{get;set;}
    //December data 
    public Decimal decCPD{get;set;}
    public Decimal decAHT{get;set;}
    public Decimal decHT{get;set;}
    public Decimal decCO7M{get;set;}
    public Decimal decQBPA{get;set;}
    public Decimal decQERR{get;set;}
    //January data
    public Decimal janCPD{get;set;}
    public Decimal janAHT{get;set;}
    public Decimal janHT{get;set;}
    public Decimal janCO7M{get;set;}
    public Decimal janQBPA{get;set;}
    public Decimal janQERR{get;set;}
    //February data
    public Decimal febCPD{get;set;}
    public Decimal febAHT{get;set;}
    public Decimal febHT{get;set;}
    public Decimal febCO7M{get;set;}
    public Decimal febQBPA{get;set;}
    public Decimal febQERR{get;set;}
    //March data
    public Decimal marCPD{get;set;}
    public Decimal marAHT{get;set;}
    public Decimal marHT{get;set;}
    public Decimal marCO7M{get;set;}
    public Decimal marQBPA{get;set;}
    public Decimal marQERR{get;set;}
    //April data 
    public Decimal aprCPD{get;set;}
    public Decimal aprAHT{get;set;}
    public Decimal aprHT{get;set;}
    public Decimal aprCO7M{get;set;}
    public Decimal aprQBPA{get;set;}
    public Decimal aprQERR{get;set;}
    //May data 
    public Decimal mayCPD{get;set;}
    public Decimal mayAHT{get;set;}
    public Decimal mayHT{get;set;}
    public Decimal mayCO7M{get;set;}
    public Decimal mayQBPA{get;set;}
    public Decimal mayQERR{get;set;}
    //June data
    public Decimal junCPD{get;set;}
    public Decimal junAHT{get;set;}
    public Decimal junHT{get;set;}
    public Decimal junCO7M{get;set;}
    public Decimal junQBPA{get;set;}
    public Decimal junQERR{get;set;}
    //July data
    public Decimal julCPD{get;set;}
    public Decimal julAHT{get;set;}
    public Decimal julHT{get;set;}
    public Decimal julCO7M{get;set;}
    public Decimal julQBPA{get;set;}
    public Decimal julQERR{get;set;}
    
    
    //Stat levels
	//cpd levels
	Integer cpdNiLevel = 70;
	Integer cpdGoodLevel = 80; 
	Integer cpdSupLevel = 91; 
	Integer cpdOutStandLevel = 100; 
	//qbpa levels 
	Integer qbpaNiLevel = 70; 
	Integer qbpaGoodLevel = 75; 
	Integer qbpaSupLevel = 85; 
	Integer qbpaOutStandLevel = 90; 
	//qerr levels 
	Double qerrNiLevel = 1.25;
	Double qerrGoodLevel = 1.0; 
	Double qerrSupLevel = 0.75; 
	Double qerrOutStandLevel = 0.5;  
	//aht levels
	Integer achtNiLevel = 275; 
	Integer achtGoodLevel = 260; 
	Integer achtSupLevel = 244; 
	Integer achtOutStandLevel = 235; 
	//ht levels 
	Integer htNiLevel = 10; 
	Integer htGoodLevel = 8; 
	Integer htSupLevel = 6; 
	Integer htOutStandLevel = 5; 
	//co7m levels
	Integer co7mNiLevel = 18; 
	Integer co7mGoodLevel = 16; 
	Integer co7mSupLevel = 14; 
	Integer co7mOutStandLevel = 11; 
	//sa levels
	Integer saNiLevel = 86; 
	Integer saGoodLevel = 90; 
	Integer saSupLevel = 93;
	Integer saOutStandLevel = 96; 
	//fut levels
	Integer futNiLevel = 15; 
	Integer futGoodLevel = 11; 
	Integer futSupLevel = 9; 
	Integer futOutStandLevel = 5;
	//other time levels 
	Integer otNiLevel = 15; 
	Integer otGoodLevel = 11; 
	Integer otSupLevel = 9; 
	Integer otOutStandLevel = 5; 
    
    
    private List<String> months = new String[]{'','January', 'February', 'March', 'April', 'May', 'June',
                                       'July', 'August', 'September', 'October', 'November', 'December'};
                                          
	//selectlist builders, one for each unique select list
    private AgentSelectListBuilder agentSelectListBuilderType; 
    private DateSelectListBuilder dateSelectListBuilderType;

    private ColorCode tableColorer; 
    
    
    //Constructor must allocate values for all table variables, and initialize lists for charts 
    public agentController() {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        renderMode = '';
        monthMap = new Map<Integer, Map<String, Decimal>>(); 
        tableColorer = ColorCode.getInstace(); 
        selectListBuilderType = new AgentSelectListBuilder();
		agentSelectListBuilderType = new AgentSelectListBuilder();
        dateSelectListBuilderType = new DateSelectListBuilder(); 
    }
    
    //Changes render mode to pdf on button click. 
    public void convertToPdf() {
        renderMode = 'pdf'; 
    }

    /**
     * Builds date list for selector on VF page
     * @return List<SelectOption> : list of dates starting with prior month in desc order
     */ 
    public List<SelectOption> getDateList() {
        return dateSelectListBuilderType.buildAgentDateSelectList();
    }
    
    
    /**
    * Builds list of agent names for the agent select List 
    *@auhtor Mike McGee 
    *
    */
    public List<SelectOption> getAgentsList() {
       	List<Agent__c> agents = [SELECT Name__c, Agent_ID__c FROM Agent__c ORDER BY Name__c ASC NULLS LAST];
        defaultAgent = agents.get(0);
        return agentSelectListBuilderType.getAgentList();
    }


    public void save() {
        if (curAgent.Id == null) {
            curAgent.Agent_ID__c = selectedVal;
            curAgent.Date__c = Date.valueOf(dateValue);
            curAgent.Name__c = name; 
            system.debug('Attemptiing to insert agent '+curAgent);
            insert curAgent;
        } else {
            if (curAgent.Name__c == null) {
                curAgent.Name__c = name; 
            }
            system.debug('Attempting to update agent :' +curAgent); 
            update curAgent;
        }
    }
    
    
    public List<AgentStatsWrapper> getAgentStatsPrevMonth(){
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        getAgentsList();
        system.debug('Entered putAgentStats ');
        system.debug('Selected Date = '+dateValue);
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
                                        Hold_Time_Percent__c,
                                        Call_Over_7_Minutes_Percent__c,
                                        Quality_Error_Rate__c,
                                        Schedule_Adherence_Percent__c,
                                        Other_Time__c,
                                        Communication_with_Sup__c,
                                        Teamwork__c,
                                        Dependability__c,
                                        Follow_up_time_percent__c,
                                        Job_Knowledge__c,                        
                                        Resource_Management__c,
                                        Total_Points__c,
                                        supervisor_comments__c,
                                        Date__c
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
        prevMonthList = instantiateList(agentStats);
        if (!prevMonthList.isEmpty()) {
            setCurVals(prevMonthList);
        } else {
            emptyAgent = new List<Agent__c>(); 
            emptyAgent.add(new Agent__c(Average_Call_Handle_Time__c = 0, Contacts_Per_Day__c = 0, 
                                        Hold_Time_Percent__c = 0,  Call_Over_7_Minutes_Percent__c = 0,  
                                        Quality_Score_BPA__c = 0,  Quality_Error_Rate__c = 0, Other_Time__c = 0, 
                                        Schedule_Adherence_Percent__c = 0, Follow_up_time_percent__c = 0,
                                        Communication_with_Sup__c = 0, Dependability__c = 0, Teamwork__c = 0));
            setCurVals(emptyAgent);
        }
        

        List<AgentStatsWrapper> ag = buildAgentStatsWrapper(agentStats); 
        if (ag.isEmpty()) {
            ag = fillWithZeroes(ag); 
        }

        //Remove the last three values so they can be used as input boxes. 
        ag.remove(ag.size() - 1);
        ag.remove(ag.size() - 1);
        ag.remove(ag.size() - 1);
        ag.remove(ag.size() - 1); 

        if (agentStats.isEmpty()) {
            curAgent = emptyAgent.get(0);
            curMonth = 'January';
        } else {
            curAgent = agentStats.get(0);
            curMonth = months[curAgent.Date__c.month()]; 
        } 
        
        system.debug('curAgent is: '+curAgent);
        
        return ag;
    }
    
    
    //To be used for statList (is test)
    public List<Agent__c> getAgentStatsPrevMonth2(){
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        getAgentsList();
        system.debug('Entered putAgentStats ');
        system.debug('Selected Date = '+dateValue);
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
                                        Hold_Time_Percent__c,
                                        Call_Over_7_Minutes_Percent__c,
                                        Quality_Error_Rate__c,
                                        Schedule_Adherence_Percent__c,
                                        Other_Time__c,
                                        Communication_with_Sup__c,
                                        Teamwork__c,
                                        Dependability__c,
                                        Follow_up_time_percent__c,
                                        Job_Knowledge__c,                        
                                        Resource_Management__c,
                                        Total_Points__c,
                                        supervisor_comments__c,
                                        Date__c
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
        prevMonthList = instantiateList(agentStats);
        if (!prevMonthList.isEmpty()) {
            setCurVals(prevMonthList);
        } else {
            emptyAgent = new List<Agent__c>(); 
            emptyAgent.add(new Agent__c(Average_Call_Handle_Time__c = 0, Contacts_Per_Day__c = 0, 
                                        Hold_Time_Percent__c = 0,  Call_Over_7_Minutes_Percent__c = 0,  
                                        Quality_Score_BPA__c = 0,  Quality_Error_Rate__c = 0, Other_Time__c = 0, 
                                        Schedule_Adherence_Percent__c = 0, Follow_up_time_percent__c = 0,
                                        Communication_with_Sup__c = 0, Dependability__c = 0, Teamwork__c = 0));
            setCurVals(emptyAgent);
        }
        

        List<AgentStatsWrapper> ag = buildAgentStatsWrapper(agentStats); 
        if (ag.isEmpty()) {
            ag = fillWithZeroes(ag); 
        }

        //Remove the last three values so they can be used as input boxes. 
        ag.remove(ag.size() - 1);
        ag.remove(ag.size() - 1);
        ag.remove(ag.size() - 1);
        ag.remove(ag.size() - 1); 

        if (agentStats.isEmpty()) {
            curAgent = emptyAgent.get(0);
            curMonth = 'January';
        } else {
            curAgent = agentStats.get(0);
            curMonth = months[curAgent.Date__c.month()]; 
        } 
        
        system.debug('curAgent is: '+curAgent);
        
        return agentStats;
    }
    
     public List<AgentStatsWrapper> getRankings() {
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
                                        SA_Rank__c,
                                        TW_Rank__c, 
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
                                        HTP_Rank__c = 0,
                                        QBPA_Rank__c = 0,
                                        QERR_Rank__c = 0,
                                        SA_Rank__c = 0,
                                        TW_Rank__c = 0 ));
        }
        
        List<AgentStatsWrapper> ag = new List<AgentStatsWrapper>(); 
        for (Agent__c u: agentStats) {
            
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName,  'Contacts Per Day Rank',
                                            Double.valueof(u.get('CPD_Rank__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Average Call Handle Time Rank',
                                            Double.valueof(u.get('ACHT_Rank__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Hold Time Percent Rank',
                                            Double.valueof(u.get('HTP_Rank__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Call Over 7 Minutes Percent Rank',
                                            Double.valueof(u.get('CO7M_Rank__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Quality Score BPA Rank',
                                            Double.valueof(u.get('QBPA_Rank__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Quality Error Rate Rank',
                                            Double.valueof(u.get('QERR_Rank__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Follow up time percent Rank',
                                            Double.valueof(u.get('FUT_Rank__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Schedule Adherence Percent Rank',
                                            Double.valueof(u.get('SA_Rank__c'))));
            ag.add(new AgentStatsWrapper(String.valueOf(u.get('Team__c')), this.agentName, 'Performance Journal Feedback Rank', 
                                            Double.valueOf(u.get('COMM_Rank__c'))));
            ag.add(new AgentStatsWrapper(String.valueOf(u.get('Team__c')), this.agentName, 'Teamwork Rank', 
                                            Double.valueOf(u.get('TW_Rank__c'))));
            ag.add(new AgentStatsWrapper(String.valueOf(u.get('Team__c')), this.agentName, 'Dependability Rank', 
                                            Double.valueOf(u.get('DEP_Rank__c'))));
        } 
        
        return ag;
    }
    
    //temporary place holder for testing 
    public List<Agent__c> getRankings2() {
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
                                        SA_Rank__c,
                                        TW_Rank__c, 
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
                                        HTP_Rank__c = 0,
                                        QBPA_Rank__c = 0,
                                        QERR_Rank__c = 0,
                                        SA_Rank__c = 0,
                                        TW_Rank__c = 0 ));
        }
        
        return agentStats;
    }

    
    /**
     * Gets the agents stats from 2 months ago and returns as a list of AgentStatsWrapper
     * 
     */
     public List<AgentStatsWrapper> getAgentStatsTwoMonthsAgo() {
         
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
                                            Hold_Time_Percent__c,
                                            Call_Over_7_Minutes_Percent__c,
                                            Quality_Error_Rate__c,
                                            Schedule_Adherence_Percent__c,
                                            Other_Time__c,
                                            Communication_with_Sup__c,
                                            Teamwork__c,
                                            Dependability__c,
                                            Follow_up_time_percent__c,
                                            Job_Knowledge__c,                        
                                            Resource_Management__c,
                                            Total_Points__c,
                                            supervisor_comments__c,
                                            Date__c
                                            FROM Agent__c WHERE Agent_ID__c = :selectedVal 
                                            and Date__c = :dateToCheck
                                            ORDER BY Date__C ASC NULLS LAST];
             
        List<Agent__c> emptyAgent = new List<Agent__c>(); 
            emptyAgent.add(new Agent__c(Average_Call_Handle_Time__c = 0, Contacts_Per_Day__c = 0, 
                                        Hold_Time_Percent__c = 0,  Call_Over_7_Minutes_Percent__c = 0,  
                                        Quality_Score_BPA__c = 0,  Quality_Error_Rate__c = 0, 
                                        Schedule_Adherence_Percent__c = 0, Follow_up_time_percent__c = 0, 
                                        Communication_with_Sup__c = 0, Dependability__c = 0, Teamwork__c = 0));

        twoMonthsAgoList = instantiateList(agentStats); 
        if(!twoMonthsAgoList.isEmpty()){
            setPriorVals(twoMonthsAgoList); 
        } else {
            
            setPriorVals(emptyAgent);
        }

        //Add statistics to wrapper list. 
       List<AgentStatsWrapper> ag = buildAgentStatsWrapper(agentStats); 
        if (ag.isEmpty()) {
            ag = fillWithZeroes(ag); 
        } 

        return ag; 
     }
     
     //temporary for testing 
     public List<Agent__c> getAgentStatsTwoMonthsAgo2() {
         
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
                                            Hold_Time_Percent__c,
                                            Call_Over_7_Minutes_Percent__c,
                                            Quality_Error_Rate__c,
                                            Schedule_Adherence_Percent__c,
                                            Other_Time__c,
                                            Communication_with_Sup__c,
                                            Teamwork__c,
                                            Dependability__c,
                                            Follow_up_time_percent__c,
                                            Job_Knowledge__c,                        
                                            Resource_Management__c,
                                            Total_Points__c,
                                            supervisor_comments__c,
                                            Date__c
                                            FROM Agent__c WHERE Agent_ID__c = :selectedVal 
                                            and Date__c = :dateToCheck
                                            ORDER BY Date__C ASC NULLS LAST];
             
        List<Agent__c> emptyAgent = new List<Agent__c>(); 
            emptyAgent.add(new Agent__c(Average_Call_Handle_Time__c = 0, Contacts_Per_Day__c = 0, 
                                        Hold_Time_Percent__c = 0,  Call_Over_7_Minutes_Percent__c = 0,  
                                        Quality_Score_BPA__c = 0,  Quality_Error_Rate__c = 0, 
                                        Schedule_Adherence_Percent__c = 0, Follow_up_time_percent__c = 0, 
                                        Communication_with_Sup__c = 0, Dependability__c = 0, Teamwork__c = 0));

        twoMonthsAgoList = instantiateList(agentStats); 
        if(!twoMonthsAgoList.isEmpty()){
            setPriorVals(twoMonthsAgoList); 
        } else {
            
            setPriorVals(emptyAgent);
        }

        return agentStats; 
     }
    
    public static Date getLastAugust() {
        Date now = Date.today(); 
        if (now.month() < 8 ) {
            return Date.newInstance(now.year() - 1, 8, 1);
        } else {
            return Date.newInstance(now.year(), 8, 1);
        }
    }
    
    public Agent__c getEmptyAgent() {
        Agent__c emptyAgent = new Agent__c( Average_Call_Handle_Time__c = 0, Contacts_Per_Day__c = 0, 
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
     * Builds list of stats to be used in datatable
     * 
     */
    public List<AgentStatsWrapper> getStatList() {
        
        Agent__c emptyAgent = getEmptyAgent(); 
        
        //build each list
        //curMonth list
        List<Agent__c> curMonthList = getAgentStatsPrevMonth2();
        Agent__c curAgent;
        if (curMonthList.isEmpty()) {
            curAgent = emptyAgent; 
        } else {
            curAgent = curMonthList[0]; 
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
        Double saAvg; 
        Double commAvg; 
        Double twAvg; 
        Double depAvg; 
        List<AggregateResult> avgList = getYearlyAverages2();
        AggregateResult avg;
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
        }
        
        //statsWrapper.add( new statsWrapper(  team  ,  agentName,  statName,  rank,  curMonthValue,   prevMonthValue,  avgs )
        List<AgentStatsWrapper> statsWrapper = new List<AgentStatsWrapper>(); 
        //add Contacts_Per_Day__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Contacts Per Day', integer.valueOf(agentRank.get('CPD_Rank__c')), 
                                                Double.valueOf(curAgent.get('Contacts_Per_Day__c')), Double.valueOf(prevAgent.get('Contacts_Per_Day__c')), 
                                                cpdAvg ));
        //add Average_Call_Handle_Time__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Average Call Handle Time', integer.valueOf(agentRank.get('ACHT_Rank__c')), 
                                                Double.valueOf(curAgent.get('Average_Call_Handle_Time__c')), Double.valueOf(prevAgent.get('Average_Call_Handle_Time__c')), 
                                                achtAvg ));
        //add Hold_Time_Percent__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Hold Time Percent', integer.valueOf(agentRank.get('HTP_Rank__c')), 
                                                Double.valueOf(curAgent.get('Hold_Time_Percent__c')), Double.valueOf(prevAgent.get('Hold_Time_Percent__c')), 
                                                htAvg ));
        //add Call_Over_7_Minutes_Percent__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Calls Over 7 Minutes Percent', integer.valueOf(agentRank.get('CO7M_Rank__c')), 
                                                Double.valueOf(curAgent.get('Call_Over_7_Minutes_Percent__c')), Double.valueOf(prevAgent.get('Call_Over_7_Minutes_Percent__c')), 
                                                co7mAvg ));
        //add Quality_Score_BPA__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Quality Score BPA', integer.valueOf(agentRank.get('QBPA_Rank__c')), 
                                                Double.valueOf(curAgent.get('Quality_Score_BPA__c')), Double.valueOf(prevAgent.get('Quality_Score_BPA__c')), 
                                                bpaAvg ));
        //add Quality_Error_Rate__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Quality Error Rate', integer.valueOf(agentRank.get('QERR_Rank__c')), 
                                                Double.valueOf(curAgent.get('Quality_Error_Rate__c')), Double.valueOf(prevAgent.get('Quality_Error_Rate__c')), 
                                                qerrAvg ));
        //add Follow_up_time_percent__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Follow Up Time Percent', integer.valueOf(agentRank.get('FUT_Rank__c')), 
                                                Double.valueOf(curAgent.get('Follow_up_time_percent__c')), Double.valueOf(prevAgent.get('Follow_up_time_percent__c')), 
                                                futAvg ));
        //add Schedule_Adherence_Percent__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Schedule Adherence Percent', integer.valueOf(agentRank.get('SA_Rank__c')), 
                                                Double.valueOf(curAgent.get('Schedule_Adherence_Percent__c')), Double.valueOf(prevAgent.get('Schedule_Adherence_Percent__c')), 
                                                saAvg ));
        //add Performance journal feedback (Communication_with_Sup__c)
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Performance Journal Feedback', integer.valueOf(agentRank.get('COMM_Rank__c')), 
                                                Double.valueOf(curAgent.get('Communication_with_Sup__c')), Double.valueOf(prevAgent.get('Communication_with_Sup__c')), 
                                                commAvg ));
        //add Teamwork__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Teamwork', integer.valueOf(agentRank.get('TW_Rank__c')), 
                                                Double.valueOf(curAgent.get('Teamwork__c')), Double.valueOf(prevAgent.get('Teamwork__c')), 
                                                twAvg ));
        //add Dependability__c
        statsWrapper.add(new AgentStatsWrapper( curAgent.Team__c, curAgent.Name__c, 'Dependability', integer.valueOf(agentRank.get('DEP_Rank__c')), 
                                                Double.valueOf(curAgent.get('Dependability__c')), Double.valueOf(prevAgent.get('Dependability__c')), 
                                                depAvg ));
                                                
        //Return stat list
        return statsWrapper; 
    }
    
    /**
     * Get yearly average scores for all statistics
     * 
     */
     public List<AgentStatsWrapper> getYearlyAverages() {
        getAgentsList();
        Date currentDate = Date.today();
        Date lastAugust = getLastAugust();
      
        if(selectedVal == null) {
            selectedVal = defaultAgent.Agent_Id__c;
        }
        
        List<AggregateResult> agentAvgs = [SELECT 
                                            Team__c, 
                                            Agent_ID__c, 
                                            AVG(Quality_Score_BPA__c) bpa,
                                            AVG(Contacts_Per_Day__c) cpd,
                                            AVG(Average_Call_Handle_Time__c) acht,
                                            AVG(Hold_Time_Percent__c) ht,
                                            AVG(Call_Over_7_Minutes_Percent__c) co7m,
                                            AVG(Quality_Error_Rate__c) qerr,
                                            AVG(Schedule_Adherence_Percent__c) sa,
                                            AVG(Other_Time__c) ot,
                                            AVG(Communication_with_Sup__c) comm,
                                            AVG(Teamwork__c) tw, 
                                            AVG(Dependability__c) dep,
                                            AVG(Follow_up_time_percent__c) fut,
                                            AVG(Job_Knowledge__c) jk,                        
                                            AVG(Resource_Management__c) rm,
                                            AVG(Total_Points__c) tot 
                                            FROM Agent__c WHERE Agent_ID__c = :selectedVal 
                                            and Date__c >= :lastAugust AND Date__c <= :Date.today() 
                                            GROUP BY Team__c,  Agent_ID__c];
                                            
        List<AgentStatsWrapper> statsWrapper = new List<AgentStatsWrapper>();
        if (!agentAvgs.isEmpty()) {
            
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName,  'Contacts Per Day',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('cpd'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Average Call Handle Time',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('acht'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Hold Time Percent',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('ht'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Call Over 7 Minutes Percent',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('co7m'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Quality Score BPA',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('bpa'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Quality Error Rate',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('qerr'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Follow up time percent',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('fut'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Schedule Adherence Percent',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('sa'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Performance Journal Feedback',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('comm'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Teamwork',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('tw'))));
                statsWrapper.add( new AgentStatsWrapper(String.valueof(agentAvgs[agentAvgs.size() - 1].get('Team__c')), this.agentName, 'Dependability',
                                                Double.valueof(agentAvgs[agentAvgs.size() - 1].get('dep'))));
        }
        
        if (statsWrapper.isEmpty()) {
            statsWrapper = fillWithZeroes(statsWrapper); 
        }

        return statsWrapper;
     }
     
     public List<AggregateResult> getYearlyAverages2() {
        getAgentsList();
        Date currentDate = Date.today();
        Date lastAugust = getLastAugust();
      
        if(selectedVal == null) {
            selectedVal = defaultAgent.Agent_Id__c;
        }
        
        List<AggregateResult> agentAvgs = [SELECT 
                                            Team__c, 
                                            Agent_ID__c, 
                                            AVG(Quality_Score_BPA__c) bpa,
                                            AVG(Contacts_Per_Day__c) cpd,
                                            AVG(Average_Call_Handle_Time__c) acht,
                                            AVG(Hold_Time_Percent__c) ht,
                                            AVG(Call_Over_7_Minutes_Percent__c) co7m,
                                            AVG(Quality_Error_Rate__c) qerr,
                                            AVG(Schedule_Adherence_Percent__c) sa,
                                            AVG(Other_Time__c) ot,
                                            AVG(Communication_with_Sup__c) comm,
                                            AVG(Teamwork__c) tw, 
                                            AVG(Dependability__c) dep,
                                            AVG(Follow_up_time_percent__c) fut,
                                            AVG(Job_Knowledge__c) jk,                        
                                            AVG(Resource_Management__c) rm,
                                            AVG(Total_Points__c) tot 
                                            FROM Agent__c WHERE Agent_ID__c = :selectedVal 
                                            and Date__c >= :lastAugust AND Date__c <= :Date.today() 
                                            GROUP BY Team__c,  Agent_ID__c];

        return agentAvgs;
     }
    

    public List<AgentStatsWrapper> buildAgentStatsWrapper (List<Agent__c> agentList) {
        List<AgentStatsWrapper> ag = new List<AgentStatsWrapper>(); 
        for (Agent__c u: agentList) {
            
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName,  'Contacts Per Day',
                                            Double.valueof(u.get('Contacts_Per_Day__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Average Call Handle Time',
                                            Double.valueof(u.get('Average_Call_Handle_Time__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Hold Time Percent',
                                            Double.valueof(u.get('Hold_Time_Percent__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Call Over 7 Minutes Percent',
                                            Double.valueof(u.get('Call_Over_7_Minutes_Percent__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Quality Score BPA',
                                            Double.valueof(u.get('Quality_Score_BPA__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Quality Error Rate',
                                            Double.valueof(u.get('Quality_Error_Rate__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Follow up time percent',
                                            Double.valueof(u.get('Follow_up_time_percent__c'))));
            ag.add( new AgentStatsWrapper(String.valueof(u.get('Team__c')), this.agentName, 'Schedule Adherence Percent',
                                            Double.valueof(u.get('Schedule_Adherence_Percent__c'))));
            ag.add(new AgentStatsWrapper(String.valueOf(u.get('Team__c')), this.agentName, 'Performance Journal Feedback', 
                                            Double.valueOf(u.get('Communication_with_Sup__c'))));
            ag.add(new AgentStatsWrapper(String.valueOf(u.get('Team__c')), this.agentName, 'Teamwork', 
                                            Double.valueOf(u.get('Teamwork__c'))));
            ag.add(new AgentStatsWrapper(String.valueOf(u.get('Team__c')), this.agentName, 'Dependability', 
                                            Double.valueOf(u.get('Dependability__c'))));

        }

        return ag;
    }

    public List<AgentStatsWrapper> buildInputList(List<Agent__c> agentList) {
        List<AgentStatsWrapper> ag = new List<AgentStatsWrapper>(); 
        for (Agent__c agent: agentList) {
            ag.add(new AgentStatsWrapper(String.valueOf(agent.get('Team__c')), this.agentName, 'Performance Journal Feedback', 
                                        Double.valueOf(agent.get('Communication_with_Sup__c'))));
            ag.add(new AgentStatsWrapper(String.valueOf(agent.get('Team__c')), this.agentName, 'Teamwork', 
                                        Double.valueOf(agent.get('Teamwork__c'))));
            ag.add(new AgentStatsWrapper(String.valueOf(agent.get('Team__c')), this.agentName, 'Dependability', 
                                        Double.valueOf(agent.get('Dependability__c'))));
        }

        return ag; 
    }
    
    /**
    * Removes all agents whos date is from previous fiscal year contained in list of agents. 
    * @author Mike McGee 
    * @param agentList	list of Agent__c.
    * @return			list of agents with all dates from previous fiscal year removed 
    */
    public List<Agent__c> setFiscalYear(List<Agent__c> agentList)
    {
    	integer currentYear = Date.today().year(); 
  		integer currentMonth = Date.today().month();
  		
  		Date startDate; 
  		
  		if(currentMonth < 8)
    		startDate = Date.newInstance(currentYear - 1, 8, 1);
    		
    	else 
    		startDate = Date.newInstance(currentYear, 8, 1);
    		
    	system.debug('Start Date = '+startDate);
    	//agent list should be sorted by date when it gets here
    	/*for(integer i = 0; i < agentList.size(); i++)
    	{
    		if(agentList[i].Date__c < startDate)
    		{
    			agentList.remove(i);
    		}
    	}*/
    	
    	integer i = 0;
    	while(agentList[i].Date__c < startDate)
    	{
    		agentList.remove(i);
    	}
    	
    	return agentList; 
    }
    
    
    /**
    * Returns a month+date string for organizing the charts on agentStats_R
    * @author Mike McGee 
    * @param dateVal  the Apex Date object to be parsed into month and year
    * @return         The month+year string representing the Date
    */
    public String getMonthYear(Date dateVal)
    {
        system.debug('Date Val passed in '+dateVal);
        String toReturn = ''; 
        toReturn += (months[dateVal.Month()]); 
        toReturn += ( String.valueOf(dateVal.Year())); 
        system.debug('Date Val '+dateVal +' what I put '+toReturn); 
        return toReturn; 
    }
    
    
   /**
     * Returns the month prior to the previous month. 
     * Special case for january. 
     * @param int currentMoth
     * @return integer previousMonth
     */ 
    public integer getPrevMonth(integer currentMonth) {
         
       //no switch statements in apex
       if(currentMonth == 1) {
           return 12; 
       } else 
            return currentMonth - 1;       
    }
    

    public void loadStats() {
        getStatList(); 
        getAgentStatsPrevMonth();
        getAgentStatsTwoMonthsAgo();
        getRankings();
        getYearlyAverages(); 
    }
    
    
    /**
     * Makes sure there is a value at each place in list
     */
     public List<Agent__c> instantiateList(List<Agent__c> agentList) {
       /* 0 QBPA, 1 CPD, 2 ACHT, 3 HT, 4 CO7M, 5 QERR, 6 SA, 7 FUT */
        for (Agent__c agent : agentList) {
            if (isNull(agent.Quality_Score_BPA__c)) {
               agent.Quality_Score_BPA__c = 0; 
            }
            if (isNull(agent.Contacts_Per_Day__c)) {
               agent.Contacts_Per_Day__c = 0; 
            }
            if (isNull(agent.Average_Call_Handle_Time__c)) {
               agent.Average_Call_Handle_Time__c = 0; 
            }
            if (isNull(agent.Hold_Time_Percent__c)) {
               agent.Hold_Time_Percent__c = 0; 
            }
            if (isNull(agent.Call_Over_7_Minutes_Percent__c)) {
               agent.Call_Over_7_Minutes_Percent__c = 0; 
            }
            if (isNull(agent.Quality_Error_Rate__c)) {
               agent.Quality_Error_Rate__c = 0; 
            }
            if (isNull(agent.Schedule_Adherence_Percent__c)) {
               agent.Schedule_Adherence_Percent__c = 0; 
            }
            if (isNull(agent.Follow_up_time_percent__c)) {
               agent.Follow_up_time_percent__c = 0; 
            }
            if (isNull(agent.Communication_with_Sup__c)) {
                agent.Communication_with_Sup__c = 0; 
            }
            if (isNull(agent.Teamwork__c)) {
                agent.Teamwork__c = 0; 
            }
            if (isNull(agent.Dependability__c)) {
                agent.Dependability__c = 0;
            }
        }
        
        return agentList; 
        
     }
     
     public boolean isNull (Decimal obj) {
         return (obj == null); 
     }
        
        
    public void setCurVals (List<Agent__c> agentList) {
        Agent__c agent = agentList.get(0);
        curAHT = agent.Average_Call_Handle_Time__c; 
        curCPD = agent.Contacts_Per_Day__c;
        curHT = agent.Hold_Time_Percent__c;
        curCO7M = agent.Call_Over_7_Minutes_Percent__c;
        curQBPA = agent.Quality_Score_BPA__c; 
        curQERR = agent.Quality_Error_Rate__c;
        curSA = agent.Schedule_Adherence_Percent__c; 
        curFUT = agent.Follow_up_time_percent__c; 
        curComm = agent.Communication_with_Sup__c;
        curDep = agent.Dependability__c; 
        curTW = agent.Teamwork__c; 

        curTotal = (getPoints('AHT',curAHT) + getPoints('CPD',curCPD) + getPoints('HT',curHT) + getPoints('CO7M',curCO7M) + 
                    getPoints('QBPA',curQBPA) + getPoints('QERR' ,curQERR) + getPoints('SA', curSA) + getPoints('FUT', curFUT) +
                    curComm + curDep + curTW + getPoints('OT', agent.Other_Time__c));
                    
        totBackground = tableColorer.getColorCode('total', curTotal);
    }
    
    public void setPriorVals (List<Agent__c> agentList) {
        Agent__c agent = agentList.get(0) ; 
        prevAHT = agent.Average_Call_Handle_Time__c;
        prevCPD = agent.Contacts_Per_Day__c;
        prevHT = agent.Hold_Time_Percent__c;
        prevCO7M = agent.Call_Over_7_Minutes_Percent__c;
        prevQBPA = agent.Quality_Score_BPA__c; 
        prevQERR = agent.Quality_Error_Rate__c;
        prevSA = agent.Schedule_Adherence_Percent__c; 
        prevFUT = agent.Follow_up_time_percent__c; 

    }

    
    public Integer getPoints(String name, Decimal value) {
        if (name.equalsIgnoreCase('AHT')) {
            return getAchtPoints(value);
        } else if (name.equalsIgnoreCase('CPD')) {
            return getCpdPoints(value); 
        } else if (name.equalsIgnoreCase('CO7M')) {
            return getCo7mPoints(value);
        } else if (name.equalsIgnoreCase('QBPA')) {
            return getQbpaPoints(value); 
        } else if (name.equalsIgnoreCase('QERR')) {
            return getQerrPoints(value); 
        } else if (name.equalsIgnoreCase('SA')) {
            return getSaPoints(value);
        } else if (name.equalsIgnoreCase('FUT')) {
            return getFutPoints(value);
        } else if (name.equalsIgnoreCase('OT')) {
            return getOtherTimePoints(value); 
        } else if (name.equalsIgnoreCase('HT')) {
            return getHtPoints(value); 
        } else {
            return 0; 
        }
    }
    
    public Integer getQbpaPoints(Decimal statValue) {
		if (statValue < qbpaNiLevel) {
			return 0; 
		} else if (statValue < qbpaGoodLevel) {
			return 4;
		} else if (statValue < qbpaSupLevel) {
			return 8; 
		} else if (statValue < qbpaOutStandLevel) {
			return 12; 
		} else {
			return 15; 
		}
	}

	public Integer getCpdPoints(Decimal statValue) {
		if (statValue < cpdNiLevel) {
			return 0; 
		} else if (statValue < cpdGoodLevel) {
			return 1;
		} else if (statValue < cpdSupLevel) {
			return 3; 
		} else if (statValue < cpdOutStandLevel) {
			return 4; 
		} else {
			return 5; 
		}
	}

	public Integer getAchtPoints(Decimal statValue) {
		if (statValue > achtNiLevel) {
			return 0; 
		} else if (statValue > achtGoodLevel) {
			return 2;
		} else if (statValue > achtSupLevel) {
			return 6; 
		} else if (statValue > achtOutStandLevel) {
			return 8; 
		} else {
			return 10; 
		}
	}

	public Integer getHtPoints(Decimal statValue) {
		if (statValue > htNiLevel) {
			return 0; 
		} else if (statValue > htGoodLevel) {
			return 2;
		} else if (statValue > htSupLevel) {
			return 6; 
		} else if (statValue > htOutStandLevel) {
			return 8; 
		} else {
			return 10; 
		}
	}

	public Integer getCo7mPoints(Decimal statValue) {
		if (statValue > co7mNiLevel) {
			return 0; 
		} else if (statValue > co7mGoodLevel) {
			return 2;
		} else if (statValue > co7mSupLevel) {
			return 6; 
		} else if (statValue > co7mOutStandLevel) {
			return 8; 
		} else {
			return 10; 
		}
	}

	public Integer getQerrPoints(Decimal statValue) {
		if (statValue > qerrNiLevel) {
			return 0; 
		} else if (statValue > qerrGoodLevel) {
			return 2;
		} else if (statValue > qerrSupLevel) {
			return 6; 
		} else if (statValue > qerrOutStandLevel) {
			return 8; 
		} else {
			return 10; 
		}
	}

	public Integer getSaPoints(Decimal statValue) {
		if (statValue < saNiLevel) {
			return 0; 
		} else if (statValue < saGoodLevel) {
			return 1;
		} else if (statValue < saSupLevel) {
			return 3; 
		} else if (statValue < saOutStandLevel) {
			return 4; 
		} else {
			return 5; 
		}
	}

	public Integer getFutPoints(Decimal statValue) {
		if (statValue > futNiLevel) {
			return 0; 
		} else if (statValue > futGoodLevel) {
			return 2;
		} else if (statValue > futSupLevel) {
			return 6; 
		} else if (statValue > futOutStandLevel) {
			return 8; 
		} else {
			return 10; 
		}
	}
	
	public Integer getOtherTimePoints(Decimal statValue) {
		if (statValue > otNiLevel) {
			return 0; 
		} else if (statValue > otGoodLevel) {
			return 1;
		} else if (statValue >= otSupLevel) {
			return 3; 
		} else if (statValue > otOutStandLevel) {
			return 4; 
		} else {
			return 5; 
		}
	}
	
        

    public String getColorCode(String statName, Integer statValue) {
        return tableColorer.getColorCode(statName, statValue);
    }


    public List<AgentStatsWrapper> fillWithZeroes(List<AgentStatsWrapper> statsWrapper) {
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Quality Score BPA', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Contacts Per Day', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Average Call Handle Time', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Hold Time Percent', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Call Over 7 Minutes Percent', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Quality Error Rate', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Schedule Adherence Percent', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Follow up time percent', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Performance Journal Feedback', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Dependability', 0));
            statsWrapper.add( new AgentStatsWrapper('Empty', 'Empty' , 'Teamwork', 0));

            return statsWrapper; 
    }

    public void fillCharts() {
        //Get stats for agent over last fiscal year. Starts in August
        Date lastAugust = getLastAugust(); 
        List<Agent__c> statsList = [SELECT Agent_Id__c, Contacts_Per_Day__c, Average_Call_Handle_Time__c, Hold_Time_Percent__c,
                                    Call_Over_7_Minutes_Percent__c, Quality_Score_BPA__c, Quality_Error_Rate__c, Date__c 
                                    FROM Agent__c WHERE Agent_Id__c =: selectedVal AND Date__c > :lastAugust];
        
        fillChartVals(statsList);                           
                                    
        Integer month;                            
        for (Agent__c a: statsList) {
            month = a.Date__c.month(); 
            Map<String, Decimal> statMap = new Map<String, Decimal>(); 
            statMap.put('Contacts_Per_Day__c', Math.round(a.Contacts_Per_Day__c));
            statMap.put('Average_Call_Handle_Time__c', a.Average_Call_Handle_Time__c.setScale(2));
            statMap.put('Hold_Time_Percent__c', (a.Hold_Time_Percent__c ).setScale(2) );
            statMap.put('Call_Over_7_Minutes_Percent__c', (a.Call_Over_7_Minutes_Percent__c ).setScale(2));
            statMap.put('Quality_Score_BPA__c', (a.Quality_Score_BPA__c ).setScale(2));
            statMap.put('Quality_Error_Rate__c', (a.Quality_Error_Rate__c) .setScale(2));
            monthMap.put(month, statMap);
        }
    }
    
    public void fillChartVals(List<Agent__c> statList) {
        
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
    }
    
    public void fillFebVals(Agent__c a) {
        febCPD = Math.round(a.Contacts_Per_Day__c);
        febAHT = a.Average_Call_Handle_Time__c.setScale(2);
        febHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        febCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        febQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        febQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillMarVals(Agent__c a) {
        marCPD = Math.round(a.Contacts_Per_Day__c);
        marAHT = a.Average_Call_Handle_Time__c.setScale(2);
        marHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        marCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        marQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        marQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillAprVals(Agent__c a) {
        aprCPD = Math.round(a.Contacts_Per_Day__c);
        aprAHT = a.Average_Call_Handle_Time__c.setScale(2);
        aprHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        aprCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        aprQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        aprQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillMayVals(Agent__c a) {
        mayCPD = Math.round(a.Contacts_Per_Day__c);
        mayAHT = a.Average_Call_Handle_Time__c.setScale(2);
        mayHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        mayCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        mayQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        mayQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillJunVals(Agent__c a) {
        junCPD = Math.round(a.Contacts_Per_Day__c);
        junAHT = a.Average_Call_Handle_Time__c.setScale(2);
        junHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        junCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        junQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        junQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillJulVals(Agent__c a) {
        julCPD = Math.round(a.Contacts_Per_Day__c);
        julAHT = a.Average_Call_Handle_Time__c.setScale(2);
        julHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        julCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        julQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        julQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillAugVals(Agent__c a) {
        augCPD = Math.round(a.Contacts_Per_Day__c);
        augAHT = a.Average_Call_Handle_Time__c.setScale(2);
        augHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        augCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        augQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        augQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillSepVals(Agent__c a) {
        sepCPD = Math.round(a.Contacts_Per_Day__c);
        sepAHT = a.Average_Call_Handle_Time__c.setScale(2);
        sepHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        sepCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        sepQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        sepQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillOctVals(Agent__c a) {
        octCPD = Math.round(a.Contacts_Per_Day__c);
        octAHT = a.Average_Call_Handle_Time__c.setScale(2);
        octHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        octCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        octQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        octQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillNovVals(Agent__c a) {
        novCPD = Math.round(a.Contacts_Per_Day__c);
        novAHT = a.Average_Call_Handle_Time__c.setScale(2);
        novHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        novCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        novQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        novQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillDecVals(Agent__c a) {
        decCPD = Math.round(a.Contacts_Per_Day__c);
        decAHT = a.Average_Call_Handle_Time__c.setScale(2);
        decHT = (a.Hold_Time_Percent__c ).setScale(2) ;
        decCO7M = (a.Call_Over_7_Minutes_Percent__c ).setScale(2);
        decQBPA = (a.Quality_Score_BPA__c ).setScale(2); 
        decQERR = (a.Quality_Error_Rate__c) .setScale(2); 
    }
    
    public void fillChartWithZeroes() {
        //create empty agent
        Agent__c emptyAgent = new Agent__c(); 
        emptyAgent.Contacts_Per_Day__c = 0; 
        emptyAgent.Average_Call_Handle_Time__c = 0;
        emptyAgent.Hold_Time_Percent__c = 0; 
        emptyAgent.Call_Over_7_Minutes_Percent__c = 0; 
        emptyAgent.Quality_Score_BPA__c = 0; 
        emptyAgent.Quality_Error_Rate__c = 0; 
        
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