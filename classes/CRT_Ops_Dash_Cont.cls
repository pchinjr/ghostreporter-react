public with sharing class CRT_Ops_Dash_Cont {
 public integer count_closed{get;set;}
 public integer count_open{get;set;}
 public integer count_today_una{get;set;}
 public List<AggregateResult> test1{get;set;}
 public List<AggregateResult> closed_today{get;set;}
 public List<AggregateResult> total_unassigned{get;set;}
 public List<AggregateResult> summary_unassigned{get;set;}
 public List<AggregateResult> total_inProgress{get;set;}
 public List<AggregateResult> summary_inProgress{get;set;}
 public List<AggregateResult> caseAge{get;set;}
 public List<AggregateResult> closeDailyAvg{get;set;}
 public List<AggregateResult> createDailyAvg{get;set;}
 public List<AggregateResult> crt_rt {get;set;}
 public List<AggregateResult> avgHandleTime {get;set;}
 public List<AggregateResult> minHandleTime {get;set;}
 public List<AggregateResult> maxHandleTime {get;set;}
 public List<AggregateResult> oldestCase {get;set;}
   
 public List<SelectOption> crt_users{get;set;}
 
 public string username {get;set;}
 public string crtusers {get;set;}
 public integer ccounter{get;set;}
 public string test {get;set;}
 
 public string selectedOptionValue{get;set;}
 
 public Date start_dt{get;set;}
 public decimal int_closeDailyAvg {get;set;}
 public decimal int_createdDailyAvg {get;set;}
 public decimal caseTurnover{get;set;}
 
 public integer count40L{get;set;}
 public integer count40O{get;set;}
 public decimal totalCount{get;set;}
 public decimal percL40{get;set;}
 public string dateTest{get;set;}
 
 public Date fDate { get; set; }
 public List<Cases> tcase{get;set;}

 public string soql{get;set;}
 
 public List<Case> queryResult { get{return queryResult;}set{ queryResult = value ;}}

 
 
 public CRT_Ops_Dash_Cont(){
     count40L = 0;
     count40O = 0;
     ccounter = 0;
     totalCount = 0;
     percL40 = 0;
     test = 'In constructor';
     //start_dt = Date.Today();
     
     getStats();
     
     
     
     caseAge = [select origin, status, max(Case_Age_CRT_Review__c) maxCaseAgeInHours, count(id) caseCount from case where 	Case_Age_CRT_Review__c > 0 
        and (status = 'unassigned' or status ='in progress') 
        group by  origin, status
        order by max(Case_Age_CRT_Review__c) desc limit 10];
    
     
    List<AggregateResult> ccount = [select owner.name name, count(id) ccount from case where   isclosed = True group by owner.name];
    List<AggregateResult> ocount = [select count(id) from case where isclosed = False and status = 'In Progress' ];
    List<AggregateResult> q1 = [select origin, count(id) ccount from case where isclosed = True group by origin];
    
    total_unassigned = [select origin, count(id) ccount from case where status = 'Unassigned' and isclosed = False group by origin];
    total_inProgress = [select origin, count(id) ccount from case where status = 'In Progress' and isclosed = False group by origin];
    summary_inProgress = [select count(id) ccount from case where status = 'In Progress' and isclosed = False];
    summary_unassigned = [select count(id) ccount from case where status = 'Unassigned' ];    
    caseAge = [select origin, status, max(Case_Age_CRT_Review__c) maxCaseAgeInHours, count(id) caseCount from case where 	Case_Age_CRT_Review__c > 0 
        and (status = 'unassigned' or status ='in progress') 
        group by  origin, status
        order by max(Case_Age_CRT_Review__c) desc limit 10]; 
    
    
    closeDailyAvg = [select count(id) dailyavg from case where isclosed=true and closeddate >= LAST_N_DAYS:30];
    int_closeDailyAvg = (integer)closeDailyAvg[0].get('dailyavg') / 30;
    
   
    
    createDailyAvg = [select count(id) dailyavg from case where createddate >= LAST_N_DAYS:30];
    
    int_createdDailyAvg = (integer)createDailyAvg[0].get('dailyavg') / 30;
    caseTurnover = (int_closeDailyAvg / int_createdDailyAvg) ;
 
   
    System.debug('IntClose:' + int_closeDailyAvg + ' , intCreated:' + int_createdDailyAvg);
    
    closed_today = ccount;
    
    
     crt_users = new List<selectOption>(); //new list for holding all of the picklist options
	
	for(Case c: [select id, case_age_crt_review__c from case where closeddate >= LAST_N_DAYS:30]){
	    if(c.case_age_crt_review__c <= 48){
	        count40L = count40L + 1;
	    }
	    else{
	        count40O = count40O + 1;
	    }
	    totalCount = totalCount + 1;
	}
	
	
	percL40 = count40L / totalCount;
	
    getOptions();
	
    
     
     
 }
 
 
 public void getStats(){
 
     
   this.crt_rt = [select origin, source__c, priority, sum(CRT_Ops_InProg__c) inpr, sum(CRT_Ops_Closed__c) clsd, 
                                    sum(CRT_Ops_Promoted__c) prom, sum(CRT_Ops_Queue__c) queue, 
                                    sum(CRT_Ops_Unassigned__c) unass
                                    from case 
                                    group by origin, source__c, priority
                                      ];
                                    
   this.avgHandleTime =  [select avg(Case_Age_In_Business_Hours__c) avghandle from case where isclosed = false  and createddate = today  group by origin, source__c, priority] ;
   this.minHandleTime =  [select origin, source__c, priority, min(Case_Age_In_Business_Hours__c) avghandle from case where isclosed = false  and createddate = today   group by origin, source__c, priority] ;
   this.maxHandleTime =  [select origin, source__c, priority, max(Case_Age_In_Business_Hours__c) avghandle from case where isclosed = false  and createddate = today group by origin, source__c, priority] ;
   this.oldestCase  =    [select origin, source__c, priority, max(Case_Age_In_Business_Hours__c) avghandle from case where isclosed = false group by origin, source__c, priority] ;

 
 }
 
 public Account getCase(){
     Account acc = new Account();
     
    return acc;
     
 }
 	 public List<selectOption> getOptions(){
	         
	         crt_users.add(new selectOption('CRT Team', 'CRT Team')); 
        	 crt_users.add(new selectOption('Ruben Ortiz', 'Ruben Ortiz'));  
        	 crt_users.add(new selectOption('Heather Harris','Heather Harris'));  
        	 for (User users : [SELECT Id, Name FROM User WHERE Profile.Name = 'CRT Member']) { //query for User records with System Admin profile
        			 crt_users.add(new selectOption(users.Name, users.Name)); //for all records found - add them to the picklist options
        	 }
                 
	     return crt_users;
	 }
 
 public string increment(){
    
      
    test = selectedOptionValue;
    ccounter = ccounter + 1;
    
     return null;
 }
 
 
public PageReference buildQueryString() {

    String name = Apexpages.currentPage().getParameters().get('name');
    String event_start_date = Apexpages.currentPage().getParameters().get('event_start_date_alternate');
    Date sdate;
    soql = event_start_date;
    sdate = Date.valueOf( event_start_date);
    
    closed_today = [select owner.name name, count(id) ccount from case where createdDate  > :sdate group by owner.name limit 1000];
 
 
return null;
}
 

 public List<AggregateResult> getCount( ){
    if(selectedOptionValue == 'CRT Team'){
        
        closed_today = [select owner.name name, count(id) ccount from case  group by owner.name limit 1000];
        total_unassigned = [select origin, count(id) ccount from case where  status = 'Unassigned' and isclosed = False group by origin limit 1000];
        total_inProgress = [select origin, count(id) ccount from case where  status = 'In Progress' and isclosed = False group by origin limit 1000];
        summary_inProgress = [select count(id) ccount from case where  status = 'In Progress' and isclosed = False ];
        summary_unassigned = [select count(id) ccount from case where status = 'Unassigned' ];    
        caseAge = [select origin, status, max(Case_Age_CRT_Review__c) maxCaseAgeInHours, count(id) caseCount from case where 	Case_Age_CRT_Review__c > 0 
        and (status = 'unassigned' or status ='in progress') 
        group by  origin, status
        order by max(Case_Age_CRT_Review__c) desc limit 10];    
        
            
        closeDailyAvg = [select count(id) dailyavg from case where isclosed=true and closeddate >= LAST_N_DAYS:30];
        int_closeDailyAvg = (integer)closeDailyAvg[0].get('dailyavg') / 30;
        caseTurnover = (int_closeDailyAvg / int_createdDailyAvg) * 100;
        
    }else{
        closed_today = [select owner.name name, count(id) ccount from case where owner.name = :selectedOptionValue  group by owner.name limit 100];
        total_unassigned = [select origin, count(id) ccount from case where owner.name = :selectedOptionValue and status = 'Unassigned' and isclosed = False group by origin limit 1000];
        total_inProgress = [select origin, count(id) ccount from case where owner.name = :selectedOptionValue and status = 'In Progress' and isclosed = False group by origin limit 1000];
        summary_inProgress = [select count(id) ccount from case where owner.name = :selectedOptionValue and status = 'In Progress' and isclosed = False];
        summary_unassigned = [select count(id) ccount from case where owner.name = :selectedOptionValue and status = 'Unassigned' ];    
        caseAge = [select origin, status, max(Case_Age_CRT_Review__c) maxCaseAgeInHours, count(id) caseCount from case where owner.name = :selectedOptionValue and
        Case_Age_CRT_Review__c > 0 and (status = 'unassigned' or status ='in progress') 
        group by  origin, status
        order by max(Case_Age_CRT_Review__c) desc limit 10];     
        
            
        closeDailyAvg = [select count(id) dailyavg from case where isclosed=true and closeddate >= LAST_N_DAYS:30];
        int_closeDailyAvg = (integer)closeDailyAvg[0].get('dailyavg') / 30;
        caseTurnover = (int_closeDailyAvg / int_createdDailyAvg) * 100;
   
    }
    
    
    
  
      
     return null;
 }
 
}