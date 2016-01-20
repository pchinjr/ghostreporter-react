global with sharing class OpsController {
transient public String uj {get;set;}
public List<AggregateResult> crt_rt;
public List<AggregateResult> crt_agent;
public List<Case_Wrapper> cw;
public List<Case_Wrapper> ca;
public List<Case_Totals_Wrapper> ct;
public List<AggregateResult> crtUser;
public List<User_Wrapper> uw;




public OpsController(){
    
    json_user();
  //  getAgg();
}
public void json_user(){
    
    uj  = new USER_JSON().makeUserJSON(getUser());
    
}

public List<User_Wrapper> getUser(){
    
     
    this.crtUser = [select name, available__c , count(id) from user  where  name = 'Ruben Ortiz' or profile.name = 'CRT Member' or profile.name = 'CRT Manager' group by name, available__c  ];
    
    
    this.uw = new List<User_Wrapper>();
    
    for(AggregateResult u: this.crtUser){
        this.uw.add(new User_Wrapper(u));    
    }
    
    return this.uw;
    
}


//Stats by Origin
public List<Case_Wrapper> getAgg (){
    this.crt_rt = [select origin, source__c, priority, sum(CRT_Ops_InProg__c) inpr, sum(CRT_Ops_Closed__c) clsd, 
                                    sum(CRT_Ops_Promoted__c) prom, sum(CRT_Ops_Queue__c) queue, 
                                    sum(CRT_Ops_Unassigned__c) unass
                                    from case 
                                    group by origin, source__c, priority
                                      ];
         
                                      
    this.cw = new List<Case_Wrapper>();

    
    for(AggregateResult c: this.crt_rt){
        this.cw.add(new Case_Wrapper(c));
        
    }
      
    
    getTotals(this.cw,'realtime');
    
 return cw;
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
    
    Integer avgHandle, minHandle, maxHandle, oldest, oldest2;
    
    
 
    field2 = '';
    field3 = 'Totals';
    
    if(mode=='agent')
      field1='Totals';
    
    
    List<Case_Wrapper> ctemp = new List<Case_Wrapper>();
    ctemp=cwrapper;
    
    unassigned = 0; inprogress = 0; queue = 0; promoted = 0; closed = 0; 
    avgHandle = 0; minHandle = 0; maxHandle = 0; oldest = 0;
    
    for(Integer x=0; x < ctemp.size(); x++){
            unassigned = unassigned +  Integer.valueof(ctemp[x].unassigned); 
            inprogress = inprogress +  Integer.valueof(ctemp[x].inprogress); 
            queue = queue +  Integer.valueof(ctemp[x].queue);
            promoted = promoted + Integer.valueof(ctemp[x].promoted);
            closed = closed + Integer.valueof(ctemp[x].closed); 
            avgHandle = avgHandle + Integer.valueof(ctemp[x].avgHandle);
            minHandle = minHandle + Integer.valueof(ctemp[x].minHandle);
            maxHandle = maxHandle + Integer.valueof(ctemp[x].maxHandle);
            
            if(oldest < Integer.valueof(ctemp[x].oldestC))
               oldest = Integer.valueof(ctemp[x].oldestC);
            
    }
    
    //calculate the averages
    avgHandle = avgHandle / ctemp.size();
    minHandle = minHandle / ctemp.size();
    maxHandle = maxHandle / ctemp.size();
  
    
    Case_Wrapper ct = new Case_Wrapper(field1, field2, field3, inprogress, queue, promoted, unassigned, closed, avgHandle, minHandle, maxHandle, oldest);
    

    if(this.cw != null){
    cwrapper.add(ct);
   
    }
    
     return cwrapper;
}
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