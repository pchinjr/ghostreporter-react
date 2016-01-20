trigger statusChangeHistory on Case (before update) {
    /*
       Author: Ruben Ortiz
       Date: 4/24
       Purpose: Track the time that has elapsed between changes in status
       Design: Create child records when status picklist is changed. Calculate the 
       time in minutes, between the last modified and current date. Measure the time
       in minute increments. This will be used in a rollup calculation by a parent object.
       Execution: On Status (picklist) change
       
       Revised: 6/2/2014 by Matthew Bald
       Renamed variables to reflect their purposes more clearly
    */
    
    //loop through every case in the new set of cases 
    for(Case c: trigger.new){
        
        //get every old case with the same Id 
        Case oldCase = Trigger.oldMap.get(c.Id);
        
        //check that status has changed
        if (oldCase.Status != c.Status) {

            //trigger.new should give us new status of case
            //if it is in progress we should have just come from unassigned  
            if(c.Status == 'In Progress')
            {                                                                                                                       //Closed date test used for testng purposes only should not occur durring regular use
                DateTime toInProgress = System.now();                                                       //Test created date for testing purposes only
                c.Minutes_Until_InProgress__c = BusinessHours.diff('01mi0000000HldpAAC',  ((c.TestCreatedDate__c != null) ? c.TestCreatedDate__c: c.CreatedDate), (c.CloseDateTest__c != null) ? c.CloseDateTest__c : toInProgress)/ 1000 / 60;
                c.Hours_Until_InProgress__c = BusinessHours.diff('01mi0000000HldpAAC', ((c.TestCreatedDate__c != null) ? c.TestCreatedDate__c: c.CreatedDate),  (c.CloseDateTest__c != null) ? c.CloseDateTest__c : toInProgress)/ 1000 / 60/60; //comes in in millis. /1000 for seconds /60 for minutes / 60 for hours
                
                  
                  //in order to use an 8 hour work day, need to subtract 1 hour for every full business day (business day defined as 9 hours in salseforce)
                  Integer totalBusinessDays = ((Integer)c.Hours_Until_InProgress__c / 9); 
                  //subtract 1 hour for each business day 
                  c.Hours_Until_InProgress__C -= totalBusinessDays; 
                  
                  //For minutes subtract 60 * totalBusinessDays from Minutes_Until_Closed
                  c.Minutes_Until_InProgress__c -= (totalBusinessDays *60); 
            }
            
            else if(c.Status == 'Closed' || c.Status == 'Prevented' || c.Status == 'Resolved' || c.Status == 'Cancelled'){
                 c.testCloseDate__c = System.now();
                 
                 //If case was created before this trigger was activated, set HoursUntilInProgress and MinutesUntilInProgress
                 if(c.Minutes_Until_InProgress__c == null)
                 {
                     c.Minutes_Until_InProgress__c = BusinessHours.diff('01mi0000000HldpAAC',  c.CreatedDate, oldCase.LastModifiedDate)/ 1000 / 60;
                     c.Hours_Until_InProgress__c = BusinessHours.diff('01mi0000000HldpAAC',  c.CreatedDate, oldCase.LastModifiedDate)/ 1000 / 60/60; //comes in in millis. /1000 for seconds /60 for minutes / 60 for hours
                     
                     
                   
                  //in order to use an 8 hour work day, need to subtract 1 hour for every full business day (business day defined as 9 hours in salseforce)
                  Integer totalBusinessDays = ((Integer)c.Hours_Until_InProgress__c / 9); 
                  //subtract 1 hour for each business day 
                  c.Hours_Until_InProgress__C -= totalBusinessDays; 
                  
                  //For minutes subtract 60 * totalBusinessDays from Minutes_Until_Closed
                  c.Minutes_Until_InProgress__c -= (totalBusinessDays *60); 
                 }
                                                                                                                                                                                 
                 c.Hours_UntilClosed__c = BusinessHours.diff('01mi0000000HldpAAC', oldCase.LastModifiedDate,  c.testCloseDate__c)/ 1000 / 60/60;
                 c.Minutes_Until_Closed__c = BusinessHours.diff('01mi0000000HldpAAC', oldCase.LastModifiedDate,c.testCloseDate__c)/ 1000 / 60;
                 
                 
                 //Testing using CRT_Review date                 
                 //c.Hours_UntilClosed__c = BusinessHours.diff('01mi0000000HldpAAC', c.CRT_Review_DT__c, c.testCloseDate__c)/ 1000 / 60/60;
                 //c.Minutes_Until_Closed__c = BusinessHours.diff('01mi0000000HldpAAC', c.CRT_Review_DT__c, c.testCloseDate__c)/ 1000 / 60;
                  
                  //Minutes and untilInProgress are still using 9 hour work day at the moment 
                  //in order to use an 8 hour work day, need to subtract 1 hour for every full business day (business day defined as 9 hours in salseforce)
                  Integer totalBusinessDays = ((Integer)c.Hours_UntilClosed__c / 9); 
                  //subtract 1 hour for each business day 
                  c.Hours_UntilClosed__C -= totalBusinessDays; 
                  
                  //For minutes subtract 60 * totalBusinessDays from Minutes_Until_Closed
                  c.Minutes_Until_Closed__c -= (totalBusinessDays *60); 
            
                 
           }           
            
            
        } 
    }
    
}