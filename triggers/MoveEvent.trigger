//On case closed, take all open tasks and assign them to the sysadmin
//maybe send warning to someone else...
//...another idea, escalate based on the number of contacts
trigger MoveEvent on Case (after update) {
    Set<String> userids = new Set<String>();
    Set<String> taskid = new Set<String>();
    String useradmin = [select id from user where profile.name = 'System Administrator' limit 1].id;
    
    //get set of ownerids that closed case
    for(Case c: trigger.new){
        if(c.isclosed){
            userids.add(c.ownerid);
        }
    }

    //get map of tasks of users that closed case 
    List<Task> tasks = [select whatid, whoid from task where status = 'Not started' and whoid in : userids];
    for(Task t: tasks ){
        
        t.whoid = useradmin;
        
    }
    update tasks;
    
    
    //what do i need?
    /*
      get all cases that closed
      get the task owner id
      reassign the task to the sysadmin- get list of sysadmin
        - 
    
    */
    
     

}