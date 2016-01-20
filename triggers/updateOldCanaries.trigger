trigger updateOldCanaries on Canary__c (before insert) {
    
    List<Canary__c> can = [select current__c from Canary__c where current__c = True];
    
    for(Canary__c c: can){
        c.current__c = false;
         
    }

    update can;
    
    
    for(Canary__c c: Trigger.new){
        c.current__c = true;
    }
    
    
    
}