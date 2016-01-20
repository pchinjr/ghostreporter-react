/**
 * Classed used to regulate error disputes.
 * Created on: 01/19/2016
 * @author Mike McGee
 */
public class ErrorDisputeHelper {

    /**
     * Gets Error object with corresponding Id
     * 
     * Uses 1 Query
     *
     * @param errorId The Id of the Error to return
     * @return The Error object with the corresponding Id
     */
    public static Error__c getErrorFromId(Id errorId) {
        try{
            return [SELECT Id FROM Error__c WHERE Id =: errorId LIMIT 1];
        } catch (QueryException e) {
            return null;
        }
    }


    
    /**
     * Checks if the passed in email is disputing an Error object
     * The method checks for three conditions: 
     * 1.) That disputed is contained in the body of the email
     * 2.) That the Id referenced in the subject is an Error object
     * 3.) That the supplied email is the supervisor email for the Error
     * Returns a true DisputeHolder if all 3 are true
     * 
     * Uses 1 Query 
     * 
     * @param message The email being checked
     * @return The Id of the 
     */
    public static DisputeCheckResult isDispute(Messaging.InboundEmail message) {
        // Check for 'dispute' in body
        if (!message.plainTextBody.toLowerCase().contains('dispute')) {
            System.debug('Dispute not in body');
            return new DisputeCheckResult(false, null);
        }
        
        // Check if error object
        List<Error__c> errList = [SELECT Id, AgentErrors__r.Agent__r.Supervisor_Email__c
                                FROM Error__c WHERE Id =: message.Subject];
        if (errList.isEmpty()) {
            System.debug('Subject line is not Id of an Error');
            return new DisputeCheckResult(false, null);
        }
        
        // Check if the supplied email is the supervisor email
        String supEmail = errList.get(0).AgentErrors__r.Agent__r.Supervisor_Email__c;
        if (!message.FromAddress.equalsIgnoreCase(supEmail)) {
            System.debug('FromAddress is not the supervisor email');
            return new DisputeCheckResult(false, null);
        } 
            
        // Getting here means all checks returned true
        return new DisputeCheckResult(true, errList.get(0).Id);
        
    }
    
    
    /**
     * Used in return for isDispute method. 
     * Allows for returning two values.
     */
    public class DisputeCheckResult {
        public Boolean isDisputed;
        public Id disputedId;
        
        public DisputeCheckResult(Boolean isDisputed, Id disputedId) {
            this.isDisputed = isDisputed;
            this.disputedId = disputedId;
        }
    }
    
    
    /**
     * Updated err object to disputed = true
     *
     * Uses 1 dml statement
     *
     * @param err The error object to update
     */
    public static void markAsDisputed(Error__c err) {
        err.Disputed__c = true;
        update err;
    }


	/**
	 * Executes entire process for marking an Error as disputed
	 * including all checks.
	 */
    public static void processDispute(Messaging.InboundEmail email) {
        DisputeCheckResult result = isDispute(email);
        if (result.isDisputed) {
            markAsDisputed(getErrorFromId(result.disputedId));
        }
    }
}