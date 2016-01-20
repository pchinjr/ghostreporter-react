public with sharing class test_c {
public List<AggregateResult> crt_rt;
public List<AggregateResult> crt_agent;
public List<Case_Wrapper> cw;
public List<Case_Wrapper> ca;
public List<Case_Totals_Wrapper> ct;
public List<AggregateResult> crtUser;
public List<User_Wrapper> uw;
public List<CaseHour> ch;

public String uj {get;set;}

public Integer count =0;//}{get;set;}
public Integer incrementCount {get;set;}
public Integer availUserCount {get;set;}
public Integer unavailUserCount {get;set;}
public Integer Alex {get;set;}
public Integer Melinda {get;set;}
public Integer Ruben {get;set;}

public String  showBadge {get;set;}

public test_c(){
    availUserCount=0;unavailUserCount=0;
    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
   	getBadge();
    getAgg();
}

public void getBadge(){
    
    String temp;
 
    
    if (DateTime.Now().hour() == 8)
        this.showBadge = '"<vs:badge>8PM</badge>"';
    else if (DateTime.Now().hour() == 8)
        this.showBadge = '8:AM';
    
    if (DateTime.Now().hour() == 9)
        this.showBadge = '"<vs:badge>9PM</badge>"';
    else if (DateTime.Now().hour() == 8)
        this.showBadge = '9:PM';    
    
    if (DateTime.Now().hour() == 1)
        this.showBadge = '<vs:badge>' + '9PM' + '</badge>';
    else if (DateTime.Now().hour() == 10)
        this.showBadge = '9:PM';    
    
    
}
public void json_user(){
    
    uj  = new USER_JSON().makeUserJSON(getUser());
    
}

public List<CaseHour> getHours(){
    /**
     * Would be better to use list of acceptable names (maybe one that can be stored into Custom settings)
     * then you can do a Where IN :<name of list>. This would make it easier to add to list later and keep the SOQL from 
     * growing too long. If it will never grow then leave it as is. 
     */
    this.crtUser = [select name, available__c , count(id) from user  where  name = 'Ruben Ortiz' or profile.name = 'CRT Member' or profile.name = 'CRT Manager' group by name, available__c  ];
    
    
    this.ch = new List<CaseHour>();
    
    for(AggregateResult u: this.crtUser){
        this.ch.add(new CaseHour(String.valueof(u.get('name'))));    
        
    }
    
    for(Integer x=0; x<this.ch.size(); x++){
        if(this.ch[x].agent == 'Ruben Ortiz')
          this.Ruben = this.ch[x].total;
        if(this.ch[x].agent == 'Alex Rivera')
          this.Alex = this.ch[x].total; 
        if(this.ch[x].agent == 'Melinda Lopez')
          this.Melinda = this.ch[x].total;
            
    }
    
    
    //this.ch.add(new CaseHour());
    
    
          // this.temp.add(this.cup);
       

    
    
    return this.ch; 
}

public List<User_Wrapper> getUser(){
    availUserCount = 0;
    unavailUserCount = 0;
     
    this.crtUser = [select name, available__c , count(id) from user  where  name = 'Ruben Ortiz' or profile.name = 'CRT Member' or profile.name = 'CRT Manager' group by name, available__c  ];
    
    
    this.uw = new List<User_Wrapper>();
    System.debug(this.uw);
    for(AggregateResult u: this.crtUser){
        this.uw.add(new User_Wrapper(u));    
    }
    
       for(Integer x=0;x<this.uw.size();x++){
           if(this.uw[x].state == 'Available' && this.uw[x].state != null)
            availUserCount = availUserCount + 1;
            else
             unavailUserCount = unavailUserCount + 1;
       }
 
    
    
    
    return this.uw;
    
}

public PageReference incrementCounter() {
        count++;
        return null;
}

public Integer getCount() {
        return count;
}

//Stats by Origin
public List<Case_Wrapper> getAgg (){
    System.debug('getAgg');
    this.crt_rt = [select origin, source__c, priority, sum(CRT_Ops_InProg__c) inpr, sum(CRT_Ops_Closed__c) clsd, 
                                    sum(CRT_Ops_Promoted__c) prom, sum(CRT_Ops_Queue__c) queue, 
                                    sum(CRT_Ops_Unassigned__c) unass
                                    from case 
                                    group by origin, source__c, priority
                                      ];
         
     System.debug('crt_rt=' + crt_rt);                                  
    this.cw = new List<Case_Wrapper>();
  System.debug('cw=' + crt_rt.size());    

   for(Integer x=0;x<this.crt_rt.size();x++){
       System.debug('rows=' + x);
   }


    for(AggregateResult c: this.crt_rt){
        
        this.cw.add(new Case_Wrapper(c));
        
    }
    
    //getAvg2(this.cw,'asd');  
    //this.cw.add(new Case_Wrapper(this.crt_rt));
    System.debug('cw size=' + this.cw.size());
   
    this.cw = getAvg3(this.cw,'asd');
    getTotals(this.cw,'realtime');
 return this.cw;   // cw;
}

//Agent Stats
public List<Case_Wrapper> getAgentStats (){
    this.crt_agent = [select owner.name, sum(CRT_Ops_InProg__c) inpr, sum(CRT_Ops_Closed__c) clsd, 
                                    sum(CRT_Ops_Promoted__c) prom, sum(CRT_Ops_Queue__c) queue, 
                                    sum(CRT_Ops_Unassigned__c) unass
                                    from case 
                                    group by owner.name];
         
                                      
    this.ca = new List<Case_Wrapper>();

    
    for(AggregateResult c: this.crt_agent){
        System.debug('in da loop');
        this.ca.add(new Case_Wrapper(c,'Process Agent'));
        
    }
      
    
    getTotals(this.ca, 'agent');
    
 return this.ca;
}


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
            //minHandle = minHandle + Integer.valueof(ctemp[x].minHandle);
            //maxHandle = maxHandle + Integer.valueof(ctemp[x].maxHandle);
            
            //System.debug('minHandle[x]= ' + Integer.valueof(ctemp[x].minHandle)  + ', minHandle var=' + minHandle + ', maxhandle=' + maxHandle + ', mode=' + mode);
            

              
            if(Integer.valueof(ctemp[x].maxHandle) > maxHandle)
              maxHandle = Integer.valueof(ctemp[x].maxHandle);
            
            if(Integer.valueof(ctemp[x].minHandle) > 0 && x>0 ){
             
                if(Integer.valueof(ctemp[x].minHandle) > 0)
                   minHandle = Integer.valueof(ctemp[x].minHandle);
                 System.debug('min1=' + Integer.valueof(ctemp[x].minHandle) + ', min2=' + Integer.valueof(ctemp[x - 1].minHandle));
                 
                if(Integer.valueof(ctemp[x - 1].minHandle) > 0  ){
                   minHandle2 = Integer.valueof(ctemp[x - 1].minHandle);
                 System.debug('min1=' + minHandle + ', min2=' + minHandle2);
                 
                 if(minHandle < minHandle2 )
                  minHandle = minHandle;
                }
                //System.debug('minHandle[x]= ' + Integer.valueof(ctemp[x].minHandle)  + ', minHandle var=' + minHandle  + ', minHandle2 var=' + minHandle2 + ', maxhandle=' + maxHandle + ', mode=' + mode);
       
            }
                
          
            
           
          
            if(oldest < Integer.valueof(ctemp[x].oldestC))
               oldest = Integer.valueof(ctemp[x].oldestC);
            
    }
    
    //calculate the averages
    avgHandle = avgHandle / ctemp.size();

    Case_Wrapper ct = new Case_Wrapper(field1, field2, field3, inprogress, queue, promoted, unassigned, closed, avgHandle, minHandle, maxHandle, oldest);
    

    if(this.cw != null){
    cwrapper.add(ct);
   
    }
    
     return cwrapper;
}
public List<Case_Wrapper> getAvg3(List<Case_Wrapper> cwrapper, String mode){

    String field1, field2, field3;
    
    Integer inprogress, queue, promoted, closed, unassigned;
    
    Integer avgHandle, minHandle, maxHandle,  oldest, minHandle2;
    
    List<Case_Wrapper> cwtemp;
 
    field2 = '';
    field3 = 'Totals';
    
    if(mode=='agent')
      field1='Totals';
    
     cwtemp = new List<Case_Wrapper>();
    List<Case_Wrapper> ctemp = new List<Case_Wrapper>();
    ctemp=cwrapper;
    
    unassigned = 0; inprogress = 0; queue = 0; promoted = 0; closed = 0; 
    avgHandle = 0; minHandle = 0; maxHandle = 0;   minHandle2 = 0;
    
     Integer avgage, ccount, max, maxtemp, mintemp, min;
     avgage = 0; ccount=0; max=0; maxtemp = 0; mintemp=0; min=0; oldest=0;
   
     List<AggregateResult> cq = [select origin, source__c, priority, max(case_age_Unassigned__c) oldest,  
                                avg(case_age_in_business_hours__c) avgh, min(case_age_in_business_hours__c) cmin,  max(case_age_in_business_hours__c) cmax  from case where 
                  isclosed = false group by origin, source__c, priority];// and crt_review_dt__c = today
    

    
      for(Integer y=0; y<ctemp.size(); y++){
         System.debug('originx outer=' + ctemp[y].origin + ' ' + ctemp[y].source + ' ' +  ctemp[y].priority);
         
        if(ctemp[y].origin != null && ctemp[y].source != null && ctemp[y].priority != null){
                            inprogress =  Integer.valueof(ctemp[y].inprogress); 
                            queue =  Integer.valueof(ctemp[y].queue);
                            promoted = Integer.valueof(ctemp[y].promoted);
                            closed =   Integer.valueof(ctemp[y].closed);    
                            unassigned =    Integer.valueof(ctemp[y].unassigned);      
                              
            for(Integer x=0;x<cq.size();x++){
                System.debug('originx inner=' + ctemp[y].origin);
 
              if(cq[x].get('origin') != null && cq[x].get('source__c') != null && cq[x].get('priority') != null){
                  
              
                if(  String.valueof(cq[x].get('origin')) == String.valueof(ctemp[y].origin) &&
                     String.valueof(cq[x].get('source__c')) == String.valueof(ctemp[y].source) &&
                     String.valueof(cq[x].get('priority')) == String.valueof(ctemp[y].priority)){
                    
                    minhandle = Integer.valueof(cq[x].get('cmin'));
                    maxhandle = Integer.valueof(cq[x].get('cmax'));
                    oldest = Integer.valueof(cq[x].get('oldest'));
                    avgage = Integer.valueof(cq[x].get('avgh'));
                    
                    
                    
                    
                    if(cq[x].get('avgh') == null){
                        minhandle = 0;//Integer.valueof(cq[x].get('cmin'));
                        maxhandle = 0;//Integer.valueof(cq[x].get('cmax'));
                        avgage = 0;//Integer.valueof(cq[x].get('avgh'));
                        
                    }
                    if(cq[x].get('oldest')==null)
                      oldest = 0;
                    
                         

                    
                    
                   
                     cwtemp.add(new Case_Wrapper(ctemp[y].origin,  ctemp[y].source,  ctemp[y].priority,  inprogress, queue,
                                            promoted, unassigned,  closed, avgage,minhandle, maxhandle, oldest));
         
                           
         
                }
                
   
              }//end if null test     

            }
           
     
         }//end if null test
   

    }
    
    System.debug('originx outer cwtempSize= ' + cwtemp.size());
    
     return cwtemp;
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
    
    Case_Wrapper ct = new Case_Wrapper(field1, field2, field3, inprogress, queue, promoted, unassigned, closed, avgHandle, minHandle, maxHandle, oldest);
    

    if(this.cw != null){
    this.ca.add(ct);
    }
    
    
}
*/

}