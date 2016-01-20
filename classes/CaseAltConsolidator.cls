public class CaseAltConsolidator {
public Case checkCase{get;set;}
public String accountid {get;set;}
public List<Case> dupCases;


public CaseAltConsolidator(Case currentCase){
    this.checkCase = currentCase;
    this.accountid = currentCase.Account_ID__c;
    this.dupCases = new List<Case>();
    consolidate();   
}

public void consolidate(){
    List<Case> ucase = [select id, ownerid, account_id__c, status, contactId, description, createddate 
                        from case where status = 'In Progress' and account_id__c = :accountid order by createddate asc];

    for(Integer x=0; x < ucase.size(); x++){
        if(ucase.size() > 1){
            //anything after zero is dup
            if( x >= 1){
                ucase[0].description = ucase[0].description + '\n Descr from dup: \n' + ucase[x].description;
                this.dupCases.add(ucase[x]);
                
            }
            
            //this is the original case
            if( x == 0){
                //do something here later   
                
            }
        }
    }
    //do something with dups
    for(Case c: this.dupCases){
        c.status = 'System Cancelled';
    }
    update this.dupCases;
    
       
}
}