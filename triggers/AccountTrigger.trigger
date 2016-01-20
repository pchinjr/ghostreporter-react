trigger AccountTrigger on Account (before insert, after insert, before update, 
                                   after update, before delete, after delete)  
{
    //Handle all insert triggers. 
    if(Trigger.isInsert)
    {
        if(Trigger.isBefore)
        {
            AccountTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        else if(Trigger.isAfter)
        {
            AccountTriggerHandler.handleAfterInsert(Trigger.old); 
        }
    }
    //Handle all update triggers
    else if(Trigger.isUpdate)
    {
        if(Trigger.isBefore)
        {
            AccountTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        else if(Trigger.isAfter)
        {
            AccountTriggerHandler.handleAfterUpdate(Trigger.old);
        }
    }
    //Handle all delete triggers.                             
    else if(Trigger.isDelete)
    {
        if(Trigger.isBefore)
        {
            AccountTriggerHandler.handleBeforeDelete(Trigger.old);
        }
        
        else if(Trigger.isAfter)
        {
            AccountTriggerHandler.handleAfterDelete(Trigger.old); 
        }
    }        
                                       
}