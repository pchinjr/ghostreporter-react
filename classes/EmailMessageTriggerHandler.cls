public class EmailMessageTriggerHandler implements TriggerHandler{

    //Do not want class to ne instantiable
    private EmailMessageTriggerHandler(){}
    
    //Handle insert triggers
    
    public static void handleBeforeInsert(List<EmailMessage> triggerNew)
    {
       getDuplicateCasesGenerated(triggerNew, ContextEnum.BEFORE);
        //new AttachToCase(triggerNew);
    }
    
    public static void handleAfterInsert(List<EmailMessage> triggerNew)
    {
      removeDuplicatesAndReshuffle(triggerNew, ContextEnum.AFTER);
    //check for attachments
    //new AttachToCase(triggerNew);
    //resend email alert after attaching to case
    
    }
    
    //handle update triggers
    public static void handleBeforeUpdate(List<EmailMessage> triggerNew, Map<Id, sObject> oldMap)
    {
       
    }
    
    public static void handleAfterUpdate(List<EmailMessage> triggerOld)
    {

    }
    
    //handle delete triggers. trigger new not available for delete 
    public static void handleBeforeDelete(List<EmailMessage> triggerOld)
    {
        
    }
    
    public static void handleAfterDelete(List<EmailMessage> triggerOld)
    {
        
    }
    
    
    //Private methods to handle specific implementation. 
    
    private static void getDuplicateCasesGenerated (List<EmailMessage> triggerNew, ContextEnum triggerContext) {
        DuplicateEmailCaseHandler.getDuplicateCasesGenerated(triggerNew, triggerContext);
    }
    
    
    private static void removeDuplicatesAndReshuffle(List<EmailMessage> triggerNew, ContextEnum triggerContext) {
        DuplicateEmailCaseHandler.removeDuplicatesAndReshuffle(triggerNew, triggerContext);
    }
}