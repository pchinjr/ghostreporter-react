trigger updateJmonPing on JmonAlert__c (after insert) {
    
    DateTime canaryTime;
    //decimal decMinutes = ((endDate.getTime())/1000/60) - ((sameDayEndDate.getTime())/1000/60);


    List<Canary__c> can = [select createdDate from Canary__c where current__c = True order by createdDate desc limit 1];
    
	List<JmonDelay__c> jds = JmonDelay__c.getall().values();


    canaryTime = DateTime.valueof(can[0].createdDate);
		
	
	System.debug('diff:' + ((DateTime.Now().getTime()/1000/60) - (canaryTime.getTime() / 1000/60)));

    System.debug('canaryTime:' + canaryTime + ', now:' + DateTime.Now() + ',delay:' + jds[0].variance__c);
    
    Decimal jmonPing;
    
    
    for(JmonAlert__c c: Trigger.new){
    
        if((c.createdDate.getTime()/1000/60) - (canaryTime.getTime() / 1000/60) > jds[0].variance__c){  
          //do something;
        
        }
        
    }
    
    
    
}