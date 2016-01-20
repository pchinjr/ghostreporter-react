public class AgentTriggerHandler implements TriggerHandler {
	public static void handleBeforeInsert(List<Agent__c> triggerNew) {
        //rankAgentStats(triggerNew);  
    }
    
    //after insert 
    public static void handleAfterInsert(List<Agent__c> triggerOld) {
    }
    
    /*
     * Mehtods for update triggers
     */
    //before insert
    public static void handleBeforeUpdate(List<Agent__c> triggerNew, Map<Id, sObject> oldMap) {
        system.debug('Before update executed'); 
    }
    
    //after update
    public static void handleAfterUpdate(List<Agent__c> triggerNew) {
        system.debug('After update executed'); 
        //rankAllStats(triggerNew); 
    }
    
    /*
     * Methods for delete triggers
     */
    //before delte
    public static void handleBeforeDelete(List<Agent__c> triggerOld) {

    }
 
    //after delete
    public static void handleAfterDelete(List<Agent__c> triggerOld) {

    }

    //Specific methods.
    
    public static void rankAllStats(List<Agent__c> triggerNew) {
        //Set date on agent ranker as date from agent 
        //new AgentRanker(triggerNew.get(0).Date__c).setRanksConsec();
        //new AgentRanker(triggerNew.get(0).Date__c).denseRank();
    }

}