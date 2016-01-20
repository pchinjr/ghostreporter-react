trigger Update_Owner on Case (before update) {
        /*
        Author: Ruben Ortiz
        Date: 8/27/2014
        Description: Used during Prod to Dev refresh to assign record ownership from default sysadmin
        to the CRT agent working the case. 
        
        
        */


        List<User> owner = [select id, name from user where profile.name = 'CRT Member'];
        

        for (Case iter: trigger.new) {
            
            for(Integer i = 0; i < owner.Size(); i++ ){
                
                if(iter.Owner__c == owner.get(i).name){
                    iter.OwnerId = owner.get(i).id;
                }           
            }
        }

          
}