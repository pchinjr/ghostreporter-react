public class ErrorTriggerHandler implements TriggerHandler {
    
    public static void handleBeforeInsert(List<Error__c> triggerNew) {
        
    }
    
    //after insert 
    public static void handleAfterInsert(List<Error__c> triggerOld) {
        
    }
    
    public static void handleAfterInsert(List<Error__c> triggerOld, 
                                         List<Error__c> triggerNew) {
        sendEmailToStakeHolders(triggerNew);
    }
    
    /*
     * Mehtods for update triggers
     */
    //before insert
    public static void handleBeforeUpdate(List<Error__c> triggerNew, Map<Id, sObject> oldMap) {

    }
    
    //after update
    public static void handleAfterUpdate(List<Error__c> triggerNew) {

    }
    
    /*
     * Methods for delete triggers
     */
    //before delte
    public static void handleBeforeDelete(List<Error__c> triggerOld) {

    }
 
    //after delete
    public static void handleAfterDelete(List<Error__c> triggerOld) {

    }

    //Specific methods.
    public static void sendEmailToStakeHolders(List<Error__c> triggerNew) {
        // Create new email
        
        // Set toAddress list
        
        // Set ccAdress list
        
        // Attach Error attachments
        
        // Set email subject line
        
        // Set email body
        
        // Send email
        
        // Make sure email was sent
    }
}