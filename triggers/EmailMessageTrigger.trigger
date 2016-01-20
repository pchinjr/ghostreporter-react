trigger EmailMessageTrigger on EmailMessage (before insert, after insert, before update, 
                                   after update, before delete, after delete) 
{
    
    
   //Handle all insert triggers. 
    if(Trigger.isInsert)
    {
        if(Trigger.isBefore)
        {
            EmailMessageTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        else if(Trigger.isAfter)
        {
            EmailMessageTriggerHandler.handleAfterInsert(Trigger.new); 
        }
    }
    

    //Handle all update triggers
    else if(Trigger.isUpdate)
    {
        if(Trigger.isBefore)
        {
            EmailMessageTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        else if(Trigger.isAfter)
        {
            EmailMessageTriggerHandler.handleAfterUpdate(Trigger.old);
        }
    }
    //Handle all delete triggers.                             
    else if(Trigger.isDelete)
    {
        if(Trigger.isBefore)
        {
            EmailMessageTriggerHandler.handleBeforeDelete(Trigger.old);
        }
        
        else if(Trigger.isAfter)
        {
            EmailMessageTriggerHandler.handleAfterDelete(Trigger.old); 
        }
    }
    
        /*
     * Needed because update can not be called during test. 
     */
    if(Test.isRunningTest())
    {
        Case newCase = new Case(); 
        
    }
}