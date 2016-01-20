public class CaseDispensor {

public String theuserid {get;set;}
public Integer counter {get;set;}


public CaseDispensor(String userid){
    this.theuserid = userid;
    this.counter = 0;
    
}

public string getCaseID(){
    string thecaseid;
    string validateCaseid;
    
    
    List<CaseTracker__c> usr = [select userid__c from CaseTracker__c where userid__c = :theuserid];    
    
    
    thecaseid = [select id from case where status = 'Unassigned' and isclosed = false order by priority, crdate__c limit 1].id;
    
    
    //insert case id into caseDispensor
    
    
    //check if caseid was used, case request gets deleted after processing
    validateCaseid = [select caseid__c from CaseTracker__c where caseid__c = :thecaseid].id;
    
    if(validateCaseid == null && counter <= 10){
        getCaseID();
        counter++;
    
    }
    
    
    
    
    return thecaseid;
}





}