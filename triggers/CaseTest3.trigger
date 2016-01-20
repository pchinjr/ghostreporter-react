trigger CaseTest3 on Case (after insert) {
Set<String> newaccountids = new Set<String>();
Set<String> dupids = new Set<String>();

for(Case c: trigger.new){
   newaccountids.add(c.id);
} 

List<Case> InsertedDups = [select id, account_id__c, description from case where status = 'In Progress'
                    and id in :newaccountids order by account_id__c];

for(Case c: InsertedDups){
    dupids.add(c.id);
}

List<Case> origCase =  [select id, account_id__c, description from case 
                        where status = 'In Progress' and id not in :dupids order by account_id__c];

List<Case> updateOrig = new List<Case>();
List<Case> close = new List<Case>();

    //update original case
    for(Case x : origCase){
        for(Case c: InsertedDups){
            System.debug('orig:' + x.account_id__c + ', new:' + c.account_id__c);
            
            if(x.account_id__c == c.account_id__c){
                x.description = x.description + '\n Case Descr From Dup\n' + c.description;
                c.status = 'System Cancelled';
                close.add(c);
            }
            
        }
     updateOrig.add(x); 
    }
    update updateOrig;
    update close;
    
    //update new dups
}