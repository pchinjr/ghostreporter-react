trigger AgentErrorsTrigger on AgentErrors__c (before insert, after insert,
											  before update, after update, 
											  before delete, after delete)  
{
    //Handle all insert triggers. 
    if(Trigger.isInsert)
    {
        if(Trigger.isBefore)
        {
            AgentErrorsTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        else if(Trigger.isAfter)
        {
            AgentErrorsTriggerHandler.handleAfterInsert(Trigger.new); 
        }
    }
    //Handle all update triggers
    else if(Trigger.isUpdate)
    {
        if(Trigger.isBefore)
        {
            AgentErrorsTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        else if(Trigger.isAfter)
        {
            AgentErrorsTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    //Handle all delete triggers.                             
    else if(Trigger.isDelete)
    {
        if(Trigger.isBefore)
        {
            AgentErrorsTriggerHandler.handleBeforeDelete(Trigger.old);
        }
        
        else if(Trigger.isAfter)
        {
            AgentErrorsTriggerHandler.handleAfterDelete(Trigger.old); 
        }
    }        
                                       
}