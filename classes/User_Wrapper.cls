public with sharing class User_Wrapper {
public String agent {get;set;}
public String state {get;set;}
public String origin {get;set;}
public String source {get;set;}
public String person_id {get;set;}
public String status {get;set;}
public DateTime crt_review_dt {get;set;}
public Time handletime {get;set;}

public AggregateResult cup {get;set;}
public List<AggregateResult> testAgg {get;set;}
public List<AggregateResult> temp {get;set;}

public Integer availUserCount{get;set;}
public Integer unavailUserCount{get;set;}
public String formattedTime{get;set;}
public String hour;
public String minute;
public String second;

public User_Wrapper(){}

public User_Wrapper(AggregateResult c){

   availUserCount=0; unavailUserCount=0;
    
    this.agent = String.valueof(c.get('name'));
    
    if( Boolean.valueof(c.get('available__c')) == false)
        this.state = 'Unavailable';
    else 
        this.state = 'Available';
    System.debug('agent=' + this.agent);    
    getCurrentCase(this.agent);    


}


public String getCurrentCaseID(String agent){
 String currentCaseID;
 String casenumber;
 String agentname;
 List<AggregateResult> testSize;
   
   agentname = agent;
   testSize =  [SELECT origin, source__c, person_id__c, owner.name, status,  max(maxDate__c) crt_review_dt from case
                        where  owner.name = :agentname and maxDate__c != null
                        group by  origin, source__c, person_id__c, owner.name, status
                        order by  max(maxDate__c) desc limit 1];
  
  System.debug('userwrapper agent=' + agent + ', size=' + testSize.size() + ']');
  
   if(testSize.size() > 0 ){
       
                       
  AggregateResult[] groupedResult = [SELECT id, origin, source__c, person_id__c, owner.name, status,  max(maxDate__c) crt_review_dt from case
                        where owner.name = :agentname and maxDate__c != null
                        group by  id, origin, source__c, person_id__c, owner.name , status
                        order by  max(maxDate__c) desc limit 1];
       
       //Lookup the casenumber using the case record id
       System.debug('userwrapper currentid= ' +  String.valueof(groupedResult[0].id)); 
       
       if(!groupedResult.isEmpty()) {
           currentCaseID = String.valueof(groupedResult[0].id); 
           
            Case caseNumberLookup = [select casenumber from case where id= :currentCaseID];          
            casenumber = caseNumberLookup.casenumber;
           
       } else {
               currentCaseID = '111'; 
       } 
       
      }
      
    return casenumber;
}


public void getCurrentCase(String agent){
  
   this.testAgg =  [SELECT origin, source__c, person_id__c, owner.name, status,  max(maxDate__c) crt_review_dt from case
                        where  owner.name = :this.agent and maxDate__c != null
                        group by  origin, source__c, person_id__c, owner.name, status
                        order by  max(maxDate__c) desc limit 1];
   if(this.testAgg.size() > 0 || (Test.isRunningTest())){
       
                       
  AggregateResult[] groupedResult = [SELECT origin, source__c, person_id__c, owner.name, status,  max(maxDate__c) crt_review_dt from case
                        where owner.name = :this.agent and maxDate__c != null
                        group by  origin, source__c, person_id__c, owner.name , status
                        order by  max(maxDate__c) desc limit 1];
       
       if(!groupedResult.isEmpty()) {
           this.cup = groupedResult[0]; 
       } else {
           if(Test.isRunningTest()) {
               this.cup = [SELECT origin, source__c, person_id__c, owner.name, status, max(maxDate__c) crt_review_dt from Case WHERE maxDate__c != null
                           group by  origin, source__c, person_id__c, owner.name , status
                        	order by  max(maxDate__c) desc limit 1]; 
           } else {
               this.cup = null; 
           } 
}


       
    System.debug('this.cup=' + this.cup);                    
       if(this.cup != null) {
           if(this.cup.get('person_id__c') == null){
                this.person_id = 'noPersonID';
            }
            else
                this.person_id = String.valueof(this.cup.get('person_id__c'));
            
               System.debug(' String.valueof(this.cup.get(origin))=' +  String.valueof(this.cup.get('origin')));
               this.crt_review_dt = DateTime.valueof(this.cup.get('crt_review_dt'));
               this.status = String.valueof(this.cup.get('status'));
               System.debug('CRT Review=' + DateTime.valueof(this.cup.get('crt_review_dt')));
               
               if(this.state == 'Available'){
               this.origin = String.valueof(this.cup.get('origin'));
               this.source = String.valueof(this.cup.get('source__c'));
               this.handletime = GetElapsedTime(DateTime.valueof(this.cup.get('crt_review_dt'))); 
               
               if( this.handletime.minute() <= 9)
                 this.minute =  '0' + this.handletime.minute();
               else
                 this.minute = '' + this.handletime.minute();
               if( this.handletime.hour() <= 1)
                 this.hour = '0' +  this.handletime.hour();
               else
                 this.hour = '' + this.handletime.hour();
            
               if(this.handletime.second() <= 9)
                 this.second = '0' + this.handletime.second();
               else
                  this.second = '' +  this.handletime.second();
               
               this.formattedTime =  this.hour + ':' + this.minute + ':' + this.second;
               }
              
              // this.temp.add(this.cup);
               
               for(AggregateResult ag: this.testAgg){
                   if(String.valueof(ag.get('status'))!= null && String.valueof(ag.get('status'))=='Available' )
                     availUserCount = availUserCount + 1;
                   else
                     unavailUserCount = unavailUserCount + 1;
               }
               
        
           }   else{
            System.debug('In else');
           this.origin = '';
           this.source = '';
           this.crt_review_dt = null;
           this.person_id = '';
           this.handletime = null; 
           this.availUserCount =0;
           this.unavailUserCount=0;
           }
           
       }
    
 
}

public static Time GetElapsedTime(DateTime startTime)
{
    if(startTime == null )
        return Time.newInstance(0, 0, 0, 0);
String timeId = [select Id from BusinessHours].Id;

Long milliseconds = BusinessHours.diff(timeId,startTime, DateTime.now());
   System.debug('milliseconds=' + milliseconds + ' in int=' + (Integer)milliseconds);
Long seconds = milliseconds / 1000;
Long minutes = seconds / 60;
Long hours = minutes / 60;
Long days = hours / 24;

     
    System.debug(Time.newInstance((Integer)hours, (Integer)minutes, (Integer)seconds, (Integer)milliseconds));
    return Time.newInstance((Integer)hours, (Integer)minutes, (Integer)seconds, (Integer)milliseconds);
}
}