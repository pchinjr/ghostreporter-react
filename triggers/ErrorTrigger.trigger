trigger ErrorTrigger on Error__c (before insert, after insert, before update, 
                                   after update, before delete, after delete) {
                                       
    //Handle all insert triggers. 
    if(Trigger.isInsert)
    {
        if(Trigger.isBefore)
        {
            ErrorTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        else if(Trigger.isAfter)
        {
            ErrorTriggerHandler.handleAfterInsert(Trigger.old, Trigger.new); 
        }
    }
    //Handle all update triggers
    else if(Trigger.isUpdate)
    {
        if(Trigger.isBefore)
        {
            ErrorTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.newMap);
        }
        
        else if(Trigger.isAfter)
        {
            //CaseTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap);
            ErrorTriggerHandler.handleAfterUpdate(Trigger.new);
        }
    }
    //Handle all delete triggers.                             
    else if(Trigger.isDelete)
    {
        if(Trigger.isBefore)
        {
            ErrorTriggerHandler.handleBeforeDelete(Trigger.old);
        }
        
        else if(Trigger.isAfter)
        {
            ErrorTriggerHandler.handleAfterDelete(Trigger.old); 
        }
    }

}