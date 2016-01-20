/**
 * Trigger to handle on operations on cases casued by trigger
 * 
 * <p>
 * Used to make triggers more manageable and to be able to set order
 * of trigger operation so as to not run into concurency issues.  
 * 
 * @author  Mike McGee
 */
trigger CaseTrigger on Case (before insert, after insert, before update, after update, 
                            before delete, after delete) {
    
    //Handle all insert triggers. 
    if(Trigger.isInsert)
    {
        if(Trigger.isBefore)
        {
            CaseTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        else if(Trigger.isAfter)
        {
             
            CaseTriggerHandler.handleAfterInsert(Trigger.new); 
      
        }
    }
    //Handle all update triggers
    else if(Trigger.isUpdate)
    {
        if(Trigger.isBefore)
        {
            CaseTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        else if(Trigger.isAfter)
        {
            //CaseTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap);
            CaseTriggerHandler.handleAfterUpdate(Trigger.old);
        }
    }
    //Handle all delete triggers.                             
    else if(Trigger.isDelete)
    {
        if(Trigger.isBefore)
        {
            CaseTriggerHandler.handleBeforeDelete(Trigger.old);
        }
        
        else if(Trigger.isAfter)
        {
            CaseTriggerHandler.handleAfterDelete(Trigger.old); 
        }
    }        
}