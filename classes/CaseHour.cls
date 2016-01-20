public class CaseHour {

public Integer h7 {get;set;}
public Integer h8 {get;set;}
public Integer h9 {get;set;}
public Integer h10 {get;set;}
public Integer h11 {get;set;}
public Integer h12 {get;set;}
public Integer h1 {get;set;}
public Integer h2 {get;set;}
public Integer h3 {get;set;}
public Integer h4 {get;set;}
public Integer h5 {get;set;}
public Integer h6 {get;set;}
public Integer total {get;set;}
public List<Case> caseCountbyHour{get;set;}
public String agent{get;set;}


public CaseHour(String agent){
    
    this.h7=0;
    this.h8=0;
    this.h9=0;
    this.h10=0;
    this.h11=0;
    this.h12=0;
    this.h1=0;
    this.h2=0;
    this.h3=0;
    this.h4=0;
    this.h5=0;
    this.h6=0;
    this.agent = agent;
    calcHours(agent);
    this.total = h1+h2+h3+h4+h5+h6+h7+h8+h9+h10+h11+h12;
    
    System.debug('hour7=' + this.h10);
    
}

  

public void calcHours(String agent){
       DateTime tm;
    if (Test.isRunningTest()) {
        system.debug('Tetsing against Id: '+agent);
        this.caseCountbyHour = [select id, crt_review_dt__c, closeddate from case where status != 'Duplicate' and owner.name = :agent and crt_review_dt__c != null and crt_review_dt__c = :Date.today()];
        system.debug('Size of test list: '+this.caseCountbyHour.size());
    } else {
        this.caseCountbyHour = [select id, crt_review_dt__c, closeddate from case where status != 'Duplicate' and owner.name = :agent and crt_review_dt__c != null and crt_review_dt__c = TODAY];
    }
         
       
       for(Case c: this.caseCountbyHour){
          //System.debug('crt_review_dt__c=' + Type.forName(c.get('crt_review_dt__c')));
          
          if((DateTime)c.get('closeddate') != null)
           tm = (DateTime)c.get('closeddate');
          else
           tm = (DateTime)c.get('crt_review_dt__c');
           
           /**
            * Add else in front of if so compiler does not 
            * needlessly evaluate all these branches 
            * (Switch statements are supposed to come to Apex this year, 
            * 							still not here as of 05/07/2015)
            * Also combine [if (tm.hour() == 17's into one clause.)]
            */
            if(tm.hour() == 7)
              this.h7 = this.h7 + 1;
            else if(tm.hour() == 8)
              this.h8 = this.h8 + 1;
            else if(tm.hour() == 9)
              this.h9 = this.h9 + 1;
            else if(tm.hour() == 10)
              this.h10 = this.h10 + 1;
            else if(tm.hour() == 11)
              this.h11 = this.h11 + 1;
            else if(tm.hour() == 12)
              this.h12 = this.h12 + 1;
            else if(tm.hour() == 13)
              this.h1 = this.h1 + 1;
            else if(tm.hour() == 14)
              this.h2 = this.h2 + 1;
            else if(tm.hour() == 15)
              this.h3 = this.h3 + 1;
            else if(tm.hour() == 16)
              this.h4 = this.h4 + 1;
            else if(tm.hour() == 17)
              this.h5 = this.h5 + 1;
            else if(tm.hour() == 18)
              this.h6 = this.h6 + 1;
            
              
              
       }
       
   }
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   

}