public class Case_Wrapper {
public String agent {get;set;}
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
public List<AggregateResult> avg;
public List<AggregateResult> old;

public AggregateResult avgHandleTime {get;set;}
public AggregateResult minHandleTime {get;set;}
public AggregateResult maxHandleTime {get;set;}
public AggregateResult oldestCase {get;set;}


public Case_Wrapper(AggregateResult c, String option){
    

    this.agent = String.valueof(c.get('name'));
    this.agent = this.agent.left(this.agent.indexof(' '));
    if(c.get('inpr')!=null)
        this.inprogress = Integer.valueof(c.get('inpr'));
    else this.inprogress = 0;
    
    if(c.get('unass')!=null)
      this.unassigned = Integer.valueof(c.get('unass'));
    else this.unassigned = 0;
    
    if(c.get('clsd')!=null)
     this.closed = Integer.valueof(c.get('clsd'));
    else this.closed=0;
    
    if(c.get('prom')!=null)
     this.promoted = Integer.valueof(c.get('prom'));
    else this.promoted=0;
    if(c.get('queue')!=null)
     this.queue = Integer.valueof(c.get('queue'));
    else this.queue=0;
 
      If(Integer.valueof(c.get('avgh'))!=null)
     this.avgHandle = Integer.valueof(c.get('avgh'));
    else
     this.avgHandle = 0;
    
    if(Integer.valueof(c.get('cmin'))!=null)
    this.minHandle = Integer.valueof(c.get('cmin'));
    else
     this.minHandle = 0;
     
    if(Integer.valueof(c.get('cmax'))!=null) 
     this.maxHandle = Integer.valueof(c.get('cmax'));
    else
     this.maxHandle = 0;
     
    if(Integer.valueof(c.get('oldest'))!=null)
     this.oldestC = Integer.valueof(c.get('oldest'));
    else
     this.oldestC = 0;
 
 
 
 
    //this.getAgentAvgs();
    }
 


 
 //field1, field2, field3, inprogress, queue, promoted, unassigned, closed, avgHandle, minHandle, maxHandle, oldest
public Case_Wrapper(String p_field1, String p_field2, String p_field3, Integer p_inprogress, Integer p_queue, Integer p_promoted, Integer p_unassigned,
                    Integer p_closed, Integer p_avgHandle, Integer p_minHandle, Integer p_maxHandle, Integer p_oldest ){
    
    System.debug('In Case_Wrapper' + this.origin + ' ' + this.source + ' ' + this.priority);
    this.agent = p_field1;
    this.origin = p_field1;
    this.source = p_field2;
    this.priority = p_field3;
    this.inprogress = p_inprogress;
    this.queue = p_queue;
    this.closed = p_closed;
    this.promoted = p_promoted;
    this.unassigned = p_unassigned;
    this.avgHandle = p_avgHandle;
    this.minHandle = p_minHandle;
    this.maxHandle = p_maxHandle;
    this.oldestC = p_oldest;
    
    
} 

public Case_Wrapper(List<AggregateResult> c){
    
 for(Integer x=0;x<c.size();x++){
     
    system.debug('Agg Res Origin: '+c[x].get('origin'));
     
    if(c[x].get('origin')!=null){
    this.origin = String.valueof(c[x].get('origin'));
    this.source = String.valueof(c[x].get('source__c'));
    this.priority = String.valueof(c[x].get('priority'));
    this.inprogress = Integer.valueof(c[x].get('inpr'));
    this.unassigned = Integer.valueof(c[x].get('unass'));
    this.closed = Integer.valueof(c[x].get('clsd'));
    this.promoted = Integer.valueof(c[x].get('prom'));
    this.queue = Integer.valueof(c[x].get('queue'));
  
    If(Integer.valueof(c[x].get('avgh'))!=null)
     this.avgHandle = Integer.valueof(c[x].get('avgh'));
    else
     this.avgHandle = 0;
    
    if(Integer.valueof(c[x].get('cmin'))!=null)
    this.minHandle = Integer.valueof(c[x].get('cmin'));
    else
     this.minHandle = 0;
     
    if(Integer.valueof(c[x].get('cmax'))!=null) 
     this.maxHandle = Integer.valueof(c[x].get('cmax'));
    else
     this.maxHandle = 0;
     
    if(Integer.valueof(c[x].get('oldest'))!=null)
     this.oldestC = Integer.valueof(c[x].get('oldest'));
    else
     this.oldestC = 0;
     
    System.debug('origin=' + this.origin);
    }
 }   
 
  //  this.getAvgs();

}


public Case_Wrapper(AggregateResult c){

    this.origin = String.valueof(c.get('origin'));
    this.source = String.valueof(c.get('source__c'));
    this.priority = String.valueof(c.get('priority'));
    this.inprogress = Integer.valueof(c.get('inpr'));
    this.unassigned = Integer.valueof(c.get('unass'));
    this.closed = Integer.valueof(c.get('clsd'));
    this.promoted = Integer.valueof(c.get('prom'));
    this.queue = Integer.valueof(c.get('queue'));
    System.debug('origin=' + this.origin);
     If(Integer.valueof(c.get('avgh'))!=null)
     this.avgHandle = Integer.valueof(c.get('avgh'));
    else
     this.avgHandle = 0;
    
    if(Integer.valueof(c.get('cmin'))!=null)
    this.minHandle = Integer.valueof(c.get('cmin'));
    else
     this.minHandle = 0;
     
    if(Integer.valueof(c.get('cmax'))!=null) 
     this.maxHandle = Integer.valueof(c.get('cmax'));
    else
     this.maxHandle = 0;
     
    if(Integer.valueof(c.get('oldest'))!=null)
     this.oldestC = Integer.valueof(c.get('oldest'));
    else
     this.oldestC = 0;
     
 
    //this.getAvgs();

}




public void getAvgs(){
   System.debug('priority=' + this.priority + ', source=' + this.source + ', origin=' + this.origin);

   
   
   List<Case> cq = [select id, case_age_Unassigned__c, case_age_in_business_hours__c, origin, source__c, priority, status from case where priority = :priority and source__c = :source 
                     and origin = :origin and isclosed = false  and crt_review_dt__c = :Date.today()];
  
   System.debug('List Size=' + cq.size());
   
   Integer avgage, ccount, max, maxtemp, mintemp, min, oldest;
   avgage = 0; ccount=0; max=0; maxtemp = 0; mintemp=0; min=0; oldest=0;
  
   System.debug('cq getAvgs=' + cq.size());



   if(cq.size() > 0){
       
   
           for(Integer x=0; x < cq.size(); x++){
              if(cq[x].status != 'Unassigned'){
                  System.debug('age=' + cq[x].Case_Age_In_Business_Hours__c );
                  if(cq[x].Case_Age_In_Business_Hours__c != null){
                  ccount = ccount + 1;
                  avgage = avgage + Integer.valueof(cq[x].Case_Age_In_Business_Hours__c);
                  System.debug('caseAge=' + cq[x].Case_Age_In_Business_Hours__c);
                  
                  if(Integer.valueof(cq[x].Case_Age_In_Business_Hours__c) > max){
                     max = Integer.valueof(cq[x].Case_Age_In_Business_Hours__c);
                       
                  }
                  
                  if(Integer.valueof(cq[x].Case_Age_In_Business_Hours__c) < max)
                     min = Integer.valueof(cq[x].Case_Age_In_Business_Hours__c);
                  }
                                      System.debug('X1 caseageunassigned=' + Integer.valueof(cq[x].Case_Age_Unassigned__c) );
              }
              else if(cq[x].Case_Age_Unassigned__c != null  ){
                    System.debug('X1 caseageunassigned=' + Integer.valueof(cq[x].Case_Age_Unassigned__c) );
                 if(Integer.valueof(cq[x].Case_Age_Unassigned__c) > oldest){
                     oldest = Integer.valueof(cq[x].Case_Age_Unassigned__c);
                        System.debug('Unassigned caseAge=' + cq[x].Case_Age_In_Business_Hours__c); 
                  } 
                  
              }
              
              
          }

     if(ccount > 0)
      this.avgHandle = avgage / ccount;
     else 
      this.avgHandle = 0;
      this.minHandle = min;
      this.maxHandle = max;
      this.oldestC = oldest;
    
     System.debug('min=' + min + ', max=' + max + ',oldesC=' + oldestC);


   }else {
     System.debug('skipped zero count');
     this.avgHandle = 0;//avgage / ccount;
     this.minHandle = 0;//min;
     this.maxHandle = 0;//max;
     this.oldestC = 0;//;
       
   }
    
  /*
    if(Database.query(q1) != null){
         this.avgHandleTime = Database.query(q1);
          if(this.avgHAndleTime.get('avghandle') == null)
          this.avgHandle = 0;
           else 
           this.avgHandle = Integer.valueof(this.avgHAndleTime.get('avghandle'));

  
   if(this.avgHandleTime.get('minHandleTime') == null)
       this.minHandle = 0;
   else 
       this.minHandle = Integer.valueof(this.avgHandleTime.get('minHandleTime'));
   
   if(this.avgHandleTime.get('maxHandleTime')==null)
       this.maxHandle = 0;
   else 
       this.maxHandle = Integer.valueof(this.avgHandleTime.get('maxHandleTime'));
    }
     
  
    if(Database.query(q2) != null){
         this.oldestCase = Database.query(q2);
         
       
       if(this.oldestCase.get('oldestCase')==null)
          this.oldestC = 0;
       else 
        this.oldestC = Integer.valueof(this.oldestCase.get('oldestCase'));
    
    }
    */ 

   
  

     
                
    
    
}

public Integer notNull(Integer num){
    Integer temp = num;
    if(num == null)
       temp = 0;
       
    return temp;
}


}