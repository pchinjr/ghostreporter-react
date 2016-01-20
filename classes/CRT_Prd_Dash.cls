public with sharing class CRT_Prd_Dash {
public List<AggregateResult> crt_rt;
public List<AggregateResult> crt_agent;
public List<Case_Wrapper> CaseWrapper;
public List<Case_Wrapper> agentWrapper;
public List<Case_Totals_Wrapper> caseTotals;
public List<AggregateResult> crtUser;
public List<User_Wrapper> userWrapper;
public List<CaseHour> case_Hour;

public String uj {get;set;}

public Integer count =0;//}{get;set;}
public Integer incrementCount {get;set;}
public Integer availUserCount {get;set;}
public Integer unavailUserCount {get;set;}
public Integer AlexHours {get;set;}
public Integer MelindaHours {get;set;}
public Integer RubenHours {get;set;}

public String  showBadge {get;set;}
public List<AgentTotals> agentTotalsList {get;set;}

public CRT_Prd_Dash(){
    availUserCount=0;unavailUserCount=0;
    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
    getOriginTotals();
}



public void json_user(){
    
    uj  = new USER_JSON().makeUserJSON(getUser());
    
}


/* 
   Description: Calculates the daily Hourly totals
   Purpose: Used to display agent daily Hourly totals in a VF table page.
   Client: VF Page- CRT_Stats, {!Hours}, {!u.h1} ...{!u.h12}
*/
public List<CaseHour> getHours(){

    this.crtUser = [select name, available__c , count(id) from user  where  name = 'Ruben Ortiz' or profile.name = 'CRT Member' 
                     group by name, available__c  ];

    this.case_Hour = new List<CaseHour>();
    
    for(AggregateResult u: this.crtUser){
        this.case_Hour.add(new CaseHour(String.valueof(u.get('name'))));    
    }

    agentTotalsList = new List<AgentTotals>();
    
    for(Integer x=0; x<this.case_Hour.size(); x++){
        agentTotalsList.add(new AgentTotals(this.case_Hour[x].agent, this.case_Hour[x].total));        
    }

    return this.case_Hour; 
}

/* 
   Description: Calculates the running daily total cases touched by each agent.
   Purpose: Used to display agent daily totals in a VF page.
   Client: VF Page- CRT_Stats, {!agentTotalsList['agentTotal']}, {!agentTotalsList['agentName']}
*/
public List<AgentTotals> getAgentTotals(){
    this.crtUser = [select name, available__c , count(id) from user  where  name = 'Ruben Ortiz' 
                    or profile.name = 'CRT Member' group by name, available__c  ];
    
    this.case_Hour = new List<CaseHour>();
    
    for(AggregateResult u: this.crtUser){
        this.case_Hour.add(new CaseHour(String.valueof(u.get('name'))));    
    }
 
    agentTotalsList = new List<AgentTotals>();
 
    for(Integer x=0; x< this.case_Hour.size(); x++){
           agentTotalsList.add(new AgentTotals(this.case_Hour[x].agent, this.case_Hour[x].total));        
    }
 
    return agentTotalsList; 
}

/* 
   Description: Returns the logged in state of CRT agents
   Purpose: Used to display the availability state of all CRT Members
   Client: VF Page- CRT_Stats, {!user},  {!agentTotalsList['agentName']}
*/
public List<User_Wrapper> getUser(){
    availUserCount = 0;
    unavailUserCount = 0;
     
    this.crtUser = [select name, available__c , count(id) from user  where  name = 'Ruben Ortiz' or profile.name = 'CRT Member'  group by name, available__c  ];
 
    this.userWrapper = new List<User_Wrapper>();
    System.debug(this.userWrapper);
    for(AggregateResult u: this.crtUser){
        this.userWrapper.add(new User_Wrapper(u));    
    }
    
   for(Integer x=0;x<this.userWrapper.size();x++){
       if(this.userWrapper[x].state == 'Available' && this.userWrapper[x].state != null)
        availUserCount = availUserCount + 1;
       else
        unavailUserCount = unavailUserCount + 1;
   }

    return this.userWrapper;
} 

public PageReference incrementCounter() {
        count++;
        return null;
}

public Integer getCount() {
        return count;
}

/* 
   Description: Returns the aggregate measures by Origin, source and priority 
   Purpose: Dito  
   Client: VF Page- CRT_Stats, {!OriginTotals}, {!u.origin}...
*/
public List<Case_Wrapper> getOriginTotals (){
     
    this.crt_rt = [select origin, source__c, priority, sum(CRT_Ops_InProg__c) inpr, sum(CRT_Ops_Closed__c) clsd, 
                                sum(CRT_Ops_Promoted__c) prom, sum(CRT_Ops_Queue__c) queue, 
                                sum(CRT_Ops_Unassigned__c) unass,  max(case_age_Unassigned__c) oldest,  
                                avg(case_age_in_business_hours__c) avgh, min(case_age_in_business_hours__c) cmin,  max(case_age_in_business_hours__c) cmax 
                                from case 
                                group by origin, source__c, priority
                                  ];
                          
    this.CaseWrapper = new List<Case_Wrapper>();
    
    for(Integer x=0;x<this.crt_rt.size();x++){
        System.debug('rows=' + x);
    }
    
    for(AggregateResult c: this.crt_rt){
        this.CaseWrapper.add(new Case_Wrapper(c));
    }
    
    getTotals(this.CaseWrapper,'realtime');
    
    return this.CaseWrapper;   // cw;
}

//Agent Stats
public List<Case_Wrapper> getAgentStats (){
    this.crt_agent = [select owner.name, sum(CRT_Ops_InProg__c) inpr, sum(CRT_Ops_Closed__c) clsd, 
                                    sum(CRT_Ops_Promoted__c) prom, sum(CRT_Ops_Queue__c) queue, 
                                    sum(CRT_Ops_Unassigned__c) unass, max(case_age_Unassigned__c) oldest,  
                                    avg(case_age_in_business_hours__c) avgh, min(case_age_in_business_hours__c) cmin,  max(case_age_in_business_hours__c) cmax 
                                    from case 
                                    group by owner.name];
         
                                      
    this.agentWrapper = new List<Case_Wrapper>();

    
    for(AggregateResult c: this.crt_agent){
        System.debug('in da loop');
        this.agentWrapper.add(new Case_Wrapper(c,'Process Agent'));
    }
      
    
    getTotals(this.agentWrapper, 'agent');
    
 return this.agentWrapper;
}

/* 
   Description: Returns a row which represents the grand total
   Purpose: Clearly, calculating a grand total is no walk in the park, this frankenstein function attemps to
            generate an aggregation that varies based on the type of measure, ie max, min, avg.
   Client:  getOriginTotals()
*/
public List<Case_Wrapper> getTotals(List<Case_Wrapper> cwrapper, String mode){

    String field1, field2, field3;
    Integer inprogress, queue, promoted, closed, unassigned;
    Integer avgHandle, minHandle, maxHandle, oldest, oldest2, minHandle2;
   
    field2 = '';
    field3 = 'Totals';
    
    if(mode=='agent')
      field1='Totals';
    
    List<Case_Wrapper> ctemp = new List<Case_Wrapper>();
    ctemp=cwrapper;
    
    unassigned = 0; inprogress = 0; queue = 0; promoted = 0; closed = 0; 
    avgHandle = 0; minHandle = 0; maxHandle = 0; oldest = 0;  minHandle2 = 0;
    
    for(Integer x=0; x < ctemp.size(); x++){
            unassigned = unassigned +  Integer.valueof(ctemp[x].unassigned); 
            inprogress = inprogress +  Integer.valueof(ctemp[x].inprogress); 
            queue = queue +  Integer.valueof(ctemp[x].queue);
            promoted = promoted + Integer.valueof(ctemp[x].promoted);
            closed = closed + Integer.valueof(ctemp[x].closed); 
            avgHandle = avgHandle + Integer.valueof(ctemp[x].avgHandle);

            if(Integer.valueof(ctemp[x].maxHandle) > maxHandle)
              maxHandle = Integer.valueof(ctemp[x].maxHandle);
        
            if(oldest < Integer.valueof(ctemp[x].oldestC))
               oldest = Integer.valueof(ctemp[x].oldestC);
            
    }

    //Loop again to get the MinHandle Time, excluding zero
    minhandle = maxHandle;
    for(Integer x=0; x < ctemp.size(); x++){
           if(Integer.valueof(ctemp[x].minHandle) > 0 && Integer.valueof(ctemp[x].minHandle) < minHandle)
              minHandle = Integer.valueof(ctemp[x].minHandle);
    }
 
    //calculate the averages
    avgHandle = avgHandle / ctemp.size();

    Case_Wrapper caseTotals = new Case_Wrapper(field1, field2, field3, inprogress, queue, promoted, unassigned, closed, avgHandle, minHandle, maxHandle, oldest);

    if(this.CaseWrapper != null){
      cwrapper.add(caseTotals);
    }
    
  return cwrapper;
}


/* 
   Description: Return the avg, min, max and oldest unassigned case.
   Purpose: ...
   Client:  getOriginTotals()
*/






/*

 


*/


/*
public void getAgentTotals(){

    String field1, field2, field3;
    
    Integer inprogress, queue, promoted, closed, unassigned;
    
    Integer avgHandle, minHandle, maxHandle, oldest;
    
    
    field1 = 'Totals';
    field2 = '';
    field3 = 'Totals';
    
    List<Case_Wrapper> ctemp = new List<Case_Wrapper>();
    ctemp=this.ca;
    
    unassigned = 0; inprogress = 0; queue = 0; promoted = 0; closed = 0; 
    avgHandle = 0; minHandle = 0; maxHandle = 0; oldest = 0;
    
    for(Integer x=0; x < ctemp.size(); x++){
            unassigned = inprogress +  Integer.valueof(ctemp[x].unassigned); 
            inprogress = inprogress +  Integer.valueof(ctemp[x].inprogress); 
            queue = queue +  Integer.valueof(ctemp[x].queue);
            promoted = promoted + Integer.valueof(ctemp[x].promoted);
            closed = closed + Integer.valueof(ctemp[x].closed); 
            avgHandle = avgHandle + Integer.valueof(ctemp[x].avgHandle);
            minHandle = minHandle + Integer.valueof(ctemp[x].minHandle);
            maxHandle = maxHandle + Integer.valueof(ctemp[x].maxHandle);
            oldest = oldest + Integer.valueof(ctemp[x].oldestC);
    
    
    }
    
    //calculate the averages
    avgHandle = avgHandle / ctemp.size();
    minHandle = minHandle / ctemp.size();
    maxHandle = maxHandle / ctemp.size();
    oldest = oldest / ctemp.size();
    
    Case_Wrapper caseTotals = new Case_Wrapper(field1, field2, field3, inprogress, queue, promoted, unassigned, closed, avgHandle, minHandle, maxHandle, oldest);
    

    if(this.cw != null){
    this.ca.add(ct);
    }
    
    
}
*/

}