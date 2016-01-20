public class CaseQueue {

public CaseQueue(Case request){
    
    
}

//public insert makeRequest(Case request){
public Case makeRequest(User auser){
    Case creq = new Case();
    User requser;
    
    requser = auser;
    CaseTracker__c ct = new CaseTracker__c();
    ct.caseid__c = auser.id;
    ct.requestTime__c = DateTime.Now();
    //Make Request
    insert ct;
    
    return creq;
}



}