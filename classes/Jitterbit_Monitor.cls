/*
   Author: Ruben Ortiz
   
   Description:
   This class will check for the presence of a flag that is set by Jitterbit as a case is 
   sent to the SOAP API.
   If Jitterbit is down, the flag (inERM__c) will not be set.
   This class will execute on a scheduler and if no inERM flags have been set, then we 
   can assume that Jitterbit is down.
   This class work in conjunction with a declarative work flow that issues an email alert.

*/


global class Jitterbit_Monitor implements Schedulable  {
    global void execute(SchedulableContext sc) {
       resetAlert();
       alert();
    }
    
    
 public Integer inERM_count{get;set;}
  public Integer flag_count{get;set;}

 
 public Jitterbit_Monitor(){

 }
 
 public void resetAlert(){
     List<Case> cup = [select id, JitterbitAlert__c from case where JitterbitAlert__c = true];
     
     for(Case c: cup){
         c.jitterbitAlert__c = false;
     }
     update cup;
 }
 
 //Here we count the number of flags that have been set.
 //A total count of zero indicates a potential issue.
 public void alert(){
     List<Case> checkHealth = [select id, inERM__c from case where crt_review_dt__c = today];
     this.inERM_count = 0;
     this.flag_count = 0;
     
     for(Case c: checkHealth){
         if(c.inERM__c == true){
            inERM_count = inERM_count + 1;
         }
 }

 
 List<Case> alert1;
 alert1 = [select id, JitterbitAlert__c from case where crt_review_dt__c = today and status <> 'Duplicate' and inERM__c = false order by lastmodifieddate desc limit 1];
 
 
 
 //This will update the JitterbitAlert flag which will trigger an email alert workflow.
 //For this to execute all cases loaded for the day must not have inERM checked.
 if(inERM_count == 0){
   for(Case c: alert1){
          c.JitterbitAlert__c = true;  
   }
 update alert1;
 }
 }
 
 /*
 public void resetInERM(){
     List<Case> cup = [select id, inERM__c from case where inERM__c = true];
   
     for(Case c: cup){
         c.inERM__c = false;
     }
     update cup;
 }
 */
 
 
 
 
}