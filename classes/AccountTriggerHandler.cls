public class AccountTriggerHandler implements TriggerHandler{
    
    //Do not want class to ne instantiable
    private AccountTriggerHandler(){}
    
	public enum Context {AFTER, BEFORE}
    
    //Handle insert triggers
    public static void handleBeforeInsert(List<Account> triggerNew)
    {
        
    }
    
    public static void handleAfterInsert(List<Account> triggerOld)
    {

    }
    
    //handle update triggers
    public static void handleBeforeUpdate(List<Account> triggerNew, Map<Id, sObject> oldMap)
    {
       
    }
    
    public static void handleAfterUpdate(List<Account> triggerOld)
    {

    }
    
    //handle delete triggers. trigger new not available for delete 
    public static void handleBeforeDelete(List<Account> triggerOld)
    {
        
    }
    
    public static void handleAfterDelete(List<Account> triggerOld)
    {
        
    }
    
    
    //Private methods to handle specific implementation. 
    
}