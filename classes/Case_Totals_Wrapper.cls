public class Case_Totals_Wrapper {
public String origin {get;set;}
public String source {get;set;}
public String priority {get;set;}
public Integer inprogress {get;set;}
public Integer unassigned {get;set;}
public Integer closed {get;set;}
public Integer promoted {get;set;}
public Integer queue {get;set;}

public Integer avgHandle {get;set;}
public Integer minHandle {get;set;}
public Integer maxHandle {get;set;}
public Integer oldestC {get;set;}

public List<AggregateResult> result;
public AggregateResult avgHandleTime {get;set;}
public AggregateResult minHandleTime {get;set;}
public AggregateResult maxHandleTime {get;set;}
public AggregateResult oldestCase {get;set;}
 
 

public Case_Totals_Wrapper(){

    this.origin = '';
    this.source = '';
    this.priority = 'Total';
    this.inprogress = 4;
    this.unassigned = 5;
    this.closed = 6;
    this.promoted = 7;
    this.queue = 8;
    
    this.getAvgs();
    }

public void getAvgs(){
    
   	
   	//Need to add checks to make sure that a result is returned. 
   	//Try catch can slow down execution. If noticable slow down then switch to casting to a list and checking that the list is not empty before adding list[0] 
   	//to value that you need to use.
   	AggregateResult[] groupedAvg =  [select avg(Case_Age_In_Business_Hours__c) avghandle from case where priority = :priority and source__c = :this.source and origin = :this.origin and isclosed = false  and createddate = today  group by origin, source__c, priority] ;
    if (!groupedAvg.isEmpty()) {
        this.avgHandleTime = (AggregateResult)groupedAvg[0].get('avghandle'); 
    } else {
        this.avgHandleTime = null; 
    }
    
    AggregateResult[] groupedMinHandleTime =  [select origin, source__c, priority, min(Case_Age_In_Business_Hours__c) minHandleTime from case where priority = :priority and source__c = :this.source and origin = :this.origin and isclosed = false  and createddate = today   group by origin, source__c, priority] ;
    if (!groupedMinHandleTime.isEmpty()) {
        this.minHandleTime = (AggregateResult)groupedMinHandleTime[0].get('minHandleTime');
  	} else {
        this.minHandleTime = null; 
    }
    
    AggregateResult[] groupedMaxHandleTime =  [select origin, source__c, priority, max(Case_Age_In_Business_Hours__c) maxHandleTime from case where priority = :priority and source__c = :this.source and origin = :this.origin and isclosed = false  and createddate = today group by origin, source__c, priority] ;
    if (!groupedMaxHandleTime.isEmpty()) {
        this.maxHandleTime = (AggregateResult)groupedMaxHandleTime[0].get('maxHandleTime'); 
    } else {
        this.maxHandleTime = null; 
    }
    
    AggregateResult[] groupedOldestCase  =    [select origin, source__c, priority, max(Case_Age_In_Business_Hours__c) oldestCase from case where priority = :priority and source__c = :this.source and origin = :this.origin and isclosed = false group by origin, source__c, priority] ;
    if (!groupedOldestCase.isEmpty()) {
        this.oldestCase = (AggregateResult)groupedOldestCase[0].get('oldestCase'); 
    } else {
        this.oldestCase = null; 
    }
    
   	this.avgHandle = 12;
   	this.minHandle = 3;
   	this.maxHandle = 1;
   	this.oldestC = 44;
                
    
    
}


}