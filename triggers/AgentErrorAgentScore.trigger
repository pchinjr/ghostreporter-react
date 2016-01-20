trigger AgentErrorAgentScore on AgentErrors__c (after insert) {
    Agent__c agent = new Agent__c();
    AgentErrors__c ar = Trigger.new[0];
    Date pdate;
 
    
    pdate = Date.newInstance(ar.Date__c.year(), ar.Date__c.month(), 1);

    List<Agent__c> agentTest = [select id from agent__c where agentid__c = :ar.agent__r.psermid__c and date__c =:pdate];
    
    if(agentTest.size() == 0){
        //insert
        agent.agent_name__c = ar.agent__r.fullName__c;
        agent.agentid__c = ar.agent__r.PSERMID__c;
        agent.agent_id__c = ar.agent__r.PSERMID__c;
        
        if(ar.TotalErrors__c > 0 && ar.TotalServiceOrders__c > 0){
           agent.Quality_Error_Rate__c = ar.TotalErrors__c / ar.TotalServiceOrders__c;
        }else
        agent.Quality_Error_Rate__c = 0;
        
        agent.date__c = Date.newInstance(ar.Date__c.year(), ar.Date__c.month(), 1  );
        
        insert agent;
    
    }
    else{
    //update record    
        if(ar.TotalErrors__c > 0 && ar.TotalServiceOrders__c > 0){
           agent.Quality_Error_Rate__c = ar.TotalErrors__c / ar.TotalServiceOrders__c;
        }else
        agent.Quality_Error_Rate__c = 0;
        
        update agent;
    }
    
    
}