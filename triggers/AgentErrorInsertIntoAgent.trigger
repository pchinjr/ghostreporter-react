trigger AgentErrorInsertIntoAgent on AgentErrors__c (after insert) {
    Agent__c agent = new Agent__c();
    
    agent.agent_name__c = Trigger.new[0].agent__r.fullName__c;
    agent.agentid__c = Trigger.new[0].agent__r.PSERMID__c;
    agent.agent_id__c = Trigger.new[0].agent__r.PSERMID__c;
    agent.Quality_Error_Rate__c = Trigger.new[0].TotalErrors__c / Trigger.new[0].TotalServiceOrders__c;
    

    agent.date__c = Date.newInstance(Trigger.new[0].Date__c.year(), Trigger.new[0].Date__c.month(), 1  );
    
    insert agent;

}