/**
 * Interface used to force basic implementation in triggers.
 * @author Mike McGee
 */

public interface TriggerHandler {
	
    /*
     * Methods to handle insert triggers.
     */
    //Before insert
    void handleBeforeInsert(List<sObject> triggerNew);
    
    //after insert 
    void handleAfterInsert(List<sObject> triggerOld);
    
    /*
     * Mehtods for update triggers
     */
    //before insert
    void handleBeforeUpdate(List<sobJect> triggerNew, Map<Id, sObject> oldMap);
    
    //after update
    void handleAfterUpdate(List<sObject> triggerOld);
    
    /*
     * Methods for delete triggers
     */
    //before delte
    void handleBeforeDelete(List<sObject> triggerOld);
 
    //after delete
    void handleAfterDelete(List<sObject> triggerOld);
    
}