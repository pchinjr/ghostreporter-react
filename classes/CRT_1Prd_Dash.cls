global with sharing class CRT_1Prd_Dash {
    
public List<AggregateResult> crt_rt;
public List<AggregateResult> crt_agent;
public List<Case_Wrapper> crtAgentDetail;
public List<Case_Wrapper> CaseWrapper;
public List<Case_Wrapper> agentWrapper;
public List<Case_Totals_Wrapper> caseTotals;
public List<AggregateResult> crtUser;
public List<User_Wrapper> userWrapper;
public List<CaseHour> case_Hour;



public Integer count =0;//}{get;set;}
public Integer incrementCount {get;set;}
public Integer availUserCount {get;set;}
public Integer unavailUserCount {get;set;}
public Integer AlexHours {get;set;}
public Integer MelindaHours {get;set;}
public Integer RubenHours {get;set;}

public String  showBadge {get;set;}
public List<AgentTotals> agentTotalsList {get;set;}

public List<Case> crtDetail{get;set;}
//public Case crtDetail{get;set;}
public String timeId{get;set;}

transient public String JSONString {get; set;}

    
	public String objId {get; set;}
	public String objType {get; set;}
	public String userName {get; set;}

public CRT_1Prd_Dash(){
    timeId = [select Id from BusinessHours].Id;
    availUserCount=0;unavailUserCount=0;
    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
    getOriginTotals();
       retrieveData();
    
}





/* 
   Description: Calculates the daily Hourly totals
   Purpose: Used to display agent daily Hourly totals in a VF table page.
   Client: VF Page- CRT_Stats, {!Hours}, {!u.h1} ...{!u.h12}
*/
public List<CaseHour> getHours(){

    this.crtUser = [select name, available__c , count(id) from user  where  profile.name = 'CRT Member' 
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
    this.crtUser = [select name, available__c , count(id) from user  where   profile.name = 'CRT Member' 
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
     
    this.crtUser = [select name, available__c , count(id) from user  where  profile.name = 'CRT Member'  group by name, available__c  ];
 
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
                                group by origin, source__c, priority having sum(CRT_Ops_Queue__c) > 0];
    system.debug('crt_rt size: '+crt_rt.size());
                          
    this.CaseWrapper = new List<Case_Wrapper>();
    
    for(Integer x=0;x<this.crt_rt.size();x++){
        System.debug('rows=' + x);
    }
    
    for(AggregateResult c: this.crt_rt){
        if(Integer.valueOf(c.get('queue')) > 0){
         this.CaseWrapper.add(new Case_Wrapper(c));
         
        }
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
                                    from case where owner.profile.name = 'CRT Member'
                                    group by owner.name];
         
                                      
    this.agentWrapper = new List<Case_Wrapper>();

    
    for(AggregateResult c: this.crt_agent){
       
        this.agentWrapper.add(new Case_Wrapper(c,'Process Agent'));
    }
      
    
    getTotals(this.agentWrapper, 'agent');
    
 return this.agentWrapper;
}



public List<CaseDetail_Wrapper> getAgentStatsbyOrigin2 (){
  DateTime maxDT;
  List<CaseDetail_Wrapper> cdw;
  Boolean isCurrent;
  List<User> agent; 
  String caseNumber;
    
  agent = [select name, available__c  from user  where   profile.name = 'CRT Member' 
                    or profile.name = 'CRT Member'  ];
    
 
 
   
  this.crtDetail = [select owner.name , origin, source__c, status, description, Note_Type__c, id, crt_review_dt__c,
                            casenumber, case_age_in_business_hours__c, maxDate__c, priority  
                            from case where owner.profile.name = 'CRT Member' and (status != 'Unassigned' and status != 'Duplicate') 
                            and (maxDate__c = today or crt_review_dt__c = today or closeddate = today)];
    
 User_Wrapper userCase = new User_Wrapper();
   
   
 cdw = new List<CaseDetail_Wrapper>();
 Case tempcase;
 //Loop through agents and get current case number
 
  for(Integer x=0; x < agent.size();x++){
      caseNumber = userCase.getCurrentCaseID(String.valueof(agent[x].get('name')));
  
      for(Integer y=0; y < this.crtDetail.size();y++){
        
         if(agent[x].name == this.crtDetail[y].owner.name){

            cdw.add(new CaseDetail_Wrapper(this.timeId, this.crtDetail[y].owner.name, this.crtDetail[y].origin, this.crtDetail[y].source__c, this.crtDetail[y].status,
            this.crtDetail[y].description, this.crtDetail[y].note_type__c, this.crtDetail[y].id, this.crtDetail[y].crt_review_dt__c, this.crtDetail[y].casenumber,
            casenumber));
         } 
         
      }
 }
   
  /* 
  // for(Case c: this.crtDetail){
        cdw.add(new CaseDetail_Wrapper(c, casenumber));
    }
*/
 return cdw;
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
    Integer avgHandleCounter, minHandleCounter, maxHandleCounter;
    field2 = '';
    field3 = 'Totals';
    
    if(mode=='agent')
      field1='Totals';
    
    List<Case_Wrapper> ctemp = new List<Case_Wrapper>();
    ctemp=cwrapper;
    
    unassigned = 0; inprogress = 0; queue = 0; promoted = 0; closed = 0; 
    avgHandle = 0; minHandle = 0; maxHandle = 0; oldest = 0;  minHandle2 = 0;
    avgHandleCounter = 0; minHandleCounter = 0; maxHandleCounter = 0;
    
    for(Integer x=0; x < ctemp.size(); x++){
            unassigned = unassigned +  Integer.valueof(ctemp[x].unassigned); 
            inprogress = inprogress +  Integer.valueof(ctemp[x].inprogress); 
            queue = queue +  Integer.valueof(ctemp[x].queue);
            promoted = promoted + Integer.valueof(ctemp[x].promoted);
            closed = closed + Integer.valueof(ctemp[x].closed); 
            avgHandle = avgHandle + Integer.valueof(ctemp[x].avgHandle);
            minHandle = minHandle +  Integer.valueof(ctemp[x].minHandle);
            maxHandle = maxHandle +  Integer.valueof(ctemp[x].maxHandle);
            
            if(Integer.valueof(ctemp[x].minHandle) != 0)
               minHandleCounter++;
            
            if(Integer.valueof(ctemp[x].maxHandle) != 0)
               maxHandleCounter++;
            
            if(Integer.valueof(ctemp[x].avgHandle) != 0)
               avgHandleCounter++;


            /* 
            if(Integer.valueof(ctemp[x].maxHandle) > maxHandle)
              maxHandle = Integer.valueof(ctemp[x].maxHandle);
            */
            if(oldest < Integer.valueof(ctemp[x].oldestC))
               oldest = Integer.valueof(ctemp[x].oldestC);
            
    }

    //Loop again to get the MinHandle Time, excluding zero
    /*
    minhandle = maxHandle;
    for(Integer x=0; x < ctemp.size(); x++){
           if(Integer.valueof(ctemp[x].minHandle) > 0 && Integer.valueof(ctemp[x].minHandle) < minHandle)
              minHandle = Integer.valueof(ctemp[x].minHandle);
    }
    */
 
    //calculate the averages 
    //Need to add checks to make sure it does not divide by zero. 
    if (avgHandleCounter == 0) {
        avgHandle = 0;
    } else {
        avgHandle = avgHandle / avgHandleCounter;
    }
    
    if (minHandleCounter == 0) {
       	minHandle = 0; 
    } else {
        minHandle = minHandle / minHandleCounter;
    }
    
    if (maxHandleCounter == 0) {
        maxHandle = 0; 
    } else {
        maxHandle = maxHandle / maxHandleCounter;
    }

    Case_Wrapper caseTotals = new Case_Wrapper(field1, field2, field3, inprogress, queue, promoted, unassigned, closed, avgHandle, minHandle, maxHandle, oldest);

    if(this.CaseWrapper != null){
      cwrapper.add(caseTotals);
    }
    
  return cwrapper;
}

public void retrieveData() {	
	
        
		
		this.JSONString = getAgentStatsbyOrigin3();
		
}
	


public String getAgentStatsbyOrigin3 (){
  DateTime maxDT;
  List<CaseDetail_Wrapper> cdw;
  Boolean isCurrent;
  List<User> agent; 
  String caseNumber;
    
  agent = [select name, available__c  from user  where   profile.name = 'CRT Member' 
                    or profile.name = 'CRT Member'  ];
    
 
 
   
  this.crtDetail = [select owner.name , origin, source__c, status, description, Note_Type__c, id, crt_review_dt__c,
                            casenumber, case_age_in_business_hours__c, maxDate__c, priority  
                            from case where owner.profile.name = 'CRT Member' and (status != 'Unassigned' and status != 'Duplicate') 
                            and (maxDate__c = today or crt_review_dt__c = today or closeddate = today)];
    
 User_Wrapper userCase = new User_Wrapper();
   
   
 cdw = new List<CaseDetail_Wrapper>();
 Case tempcase;
 //Loop through agents and get current case number
 
  for(Integer x=0; x < agent.size();x++){
      caseNumber = userCase.getCurrentCaseID(String.valueof(agent[x].get('name')));
  
      for(Integer y=0; y < this.crtDetail.size();y++){
        
         if(agent[x].name == this.crtDetail[y].owner.name){

            cdw.add(new CaseDetail_Wrapper(this.timeId, this.crtDetail[y].owner.name, this.crtDetail[y].origin, this.crtDetail[y].source__c, this.crtDetail[y].status,
            this.crtDetail[y].description, this.crtDetail[y].note_type__c, this.crtDetail[y].id, this.crtDetail[y].crt_review_dt__c, this.crtDetail[y].casenumber,
            casenumber));
         } 
         
      }
 }
   



 return gen_JSON2(cdw);
}


 public String gen_JSON2(List<CaseDetail_Wrapper> cdw) {  
    
     
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);

        // Write data to the JSON string.
        gen.writeStartObject();
        
        gen.writeFieldName('data');

        gen.writeStartArray();
        
        for (CaseDetail_Wrapper acc : cdw) {  
          gen.writeStartObject();
          
            if (acc.agent != null)
              gen.writeStringField('Agent', acc.agent);
            else gen.writeNullField('agent');
            
         
            if (acc.origin != null)
              gen.writeStringField('origin', acc.origin);
            else gen.writeNullField('origin');
            
            if (acc.source != null)
              gen.writeStringField('source', acc.source);
            else gen.writeNullField('source');
            
            if (acc.status != null)
              gen.writeStringField('status', acc.status);
            else gen.writeNullField('status');
            
            if (acc.casenumber != null)
              gen.writeStringField('casenumber', acc.casenumber);
            else gen.writeNullField('casenumber');
            
            if (acc.description != null)
              gen.writeStringField('description', acc.description);
            else gen.writeNullField('description');
            
           if (acc.noteType != null)
              gen.writeStringField('noteType', acc.noteType);
            else gen.writeNullField('noteType');
            
            if (acc.formattedTime != null)
              gen.writeStringField('caseAge', acc.formattedTime);
            else gen.writeNullField('caseAge');
            
            if (acc.isCurrent != null)
              gen.writeBooleanField('isCurrent', acc.isCurrent);
            else gen.writeNullField('isCurrent');
            
          gen.writeEndObject();
    }
    
        gen.writeEndArray();
        gen.writeEndObject();
    
        return gen.getAsString();            

  }
	
	
		public PageReference getPageRef() {
		PageReference ref = null;
		
	
			Case caseClicked = null;
					
			try {
				caseClicked = [select Id, OwnerId, CaseNumber, Status from Case where CaseNumber = :objId];
				
				if (caseClicked.Status == 'Unassigned' && caseClicked.OwnerId == userName) {
					caseClicked.Status = 'In Progress';
					caseClicked.CRT_Review_DT__c = DateTime.now();
					//caseClicked.OwnerId = userName;
					caseClicked.maxDate__c = DateTime.now();
					update caseClicked;
				}
				
			}
			catch (QueryException e) {
				// no case found
			}
			
			if (caseClicked != null) {
				//ref = new ApexPages.StandardController(caseClicked).view();
				ref = new PageReference('/'+caseClicked.Id);
				ref.setRedirect(true);
				return ref;
			}
	
		
		return ref;
	}


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