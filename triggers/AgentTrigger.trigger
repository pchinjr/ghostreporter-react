trigger AgentTrigger on Agent__c (before insert, after insert, before update, 
                                   after update, before delete, after delete) {
    //Handle all insert triggers. 
    if(Trigger.isInsert)
    {
        if(Trigger.isBefore)
        {
            AgentTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        else if(Trigger.isAfter)
        {
            AgentTriggerHandler.handleAfterInsert(Trigger.old); 
        }
    }
    //Handle all update triggers
    else if(Trigger.isUpdate)
    {
        if(Trigger.isBefore)
        {
            system.debug('Before trigger is firing'); 
            AgentTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.newMap);
        }
        
        else if(Trigger.isAfter)
        {
            //CaseTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap);
            AgentTriggerHandler.handleAfterUpdate(Trigger.new);
        }
    }
    //Handle all delete triggers.                             
    else if(Trigger.isDelete)
    {
        if(Trigger.isBefore)
        {
            AgentTriggerHandler.handleBeforeDelete(Trigger.old);
        }
        
        else if(Trigger.isAfter)
        {
            AgentTriggerHandler.handleAfterDelete(Trigger.old); 
        }
    }
}