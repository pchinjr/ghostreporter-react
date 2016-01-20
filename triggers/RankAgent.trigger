trigger RankAgent on AgentRankStarter__c (before update) {
    
     List<AggregateResult> agent = [select date__c from Agent__c group by date__c];

     for (Integer i = 0; i < Trigger.old.size(); i++) {
          AgentRankStarter__c old = Trigger.old[i];
          AgentRankStarter__c nw = Trigger.new[i];
    
        
         if (nw.LastRankDateTime__c > old.LastRankDateTime__c) {
 

            for(AggregateResult ag: agent){
                 AgentRankDistinct agr = new AgentRankDistinct(Date.valueof(ag.get('date__c')));
                 agr.rankPercentile(true); 
		         agr.rankPercentile(false); 
             }
              
              
              
         }
     }
    
    
}