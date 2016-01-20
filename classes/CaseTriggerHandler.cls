/**
 * Handler for all possible triggers on Case object, 
 * use seperate methods for all possible contexts 
 * @author Mike McGee
 */
public class CaseTriggerHandler implements TriggerHandler{
    
    //Do not want class to ne instantiable
    private CaseTriggerHandler(){}
    
    public static integer enteredShuffleCases = 0; 
    public static integer enteredGetUSerCases = 0; 
    public enum Context {AFTER, BEFORE}
    public static boolean firstRun = true;
    //Handle insert triggers
    public static void handleBeforeInsert(List<Case> triggerNew)
    {
        //setCRTReviewDateOnCaseAssigned(triggerNew, Context.BEFORE);
        //scoreSentiments(triggerNew, Context.BEFORE);
        //setConsolidateExcludeFlag(triggerNew, Context.BEFORE);
        cosnsolidateDuplicateCases(triggerNew, Context.BEFORE);

    }
    
    public static void handleAfterInsert(List<Case> triggerOld)
    {

    }
    
    //handle update triggers
    public static void handleBeforeUpdate(List<Case> triggerNew, Map<Id, sObject> oldMap)
    {
        // updateCaseAgeClosed(triggerNew, Context.BEFORE);
        //setCRTReviewDateOnCaseAssigned(triggerNew, Context.BEFORE);
        //updateOwner(triggerNew, Context.BEFORE);
        //trackStatusChangeHistory(triggerNew, oldMap, Context.BEFORE);
        	if (firstRun) {
                
               if(triggerNew[0].SendSevereEmail__c == True && triggerNew[0].SevereEmailSent__c == False){
                  SendSevereEmailAlert send = new SendSevereEmailAlert(triggerNew);
               }
               firstRun = false;
         }


    }
    

    public static void handleAfterUpdate(List<Case> triggerNew)
    {
       
       //Ready for Prod updateCaseAgeClosed2(triggerNew);
        //shuffleCases();
    }
 
    
    //handle delete triggers. trigger new not available for delete 
    public static void handleBeforeDelete(List<Case> triggerOld)
    {
        
    }
    
    public static void handleAfterDelete(List<Case> triggerOld)
    {
        
    }
    
    
    /////////////////////////// Private methods to handle specific implementation. ///////////////////////////////////////////////
    
    /**
     * Sets consolidate exclusion flag based of origin. 
     */
  /*  private static void setConsolidateExcludeFlag(List<Case> triggerNew, Context context) {
        Map<String, ConsolidationExlusionOrigins__c> excMap = ConsolidationExlusionOrigins__c.getall();
        for (Case c : triggerNew) {
            if (excMap.get(c.Origin) != null) {
                c.ConsolidateExclude__c = true; 
            }
        }
    }*/
    
    
    /**
     * Calls CaseConslidator
     */
    private static void cosnsolidateDuplicateCases(List<Case> triggerNew, Context context)
    {
        if (triggerNew.size() > 50) {
            new CaseConsolidator().startBatch();
        } else {
            for(Case c : triggerNew) {
                if (c.Origin != 'Email' && c.Account_ID__c != null ) {
                    new CaseConsolidator(c);
                }
            }
        }
        
    }
    /*
     private static void updateCaseAgeClosed2(List<Case> triggerNew){
         
        if(CaseController.runOnce())  {
      
        
         //Create list of cases add to list and update list
        List<Case> ucase = [SELECT Id, CRT_Review_DT__c, closeddate, isclosed, Case_Age_In_Business_Hours__c FROM Case WHERE Id IN: Trigger.newMap.keySet()];
         


 
 
        for(Case c: ucase){
            
           
        
            System.debug('In forloop: crt_rev_dt=' + c.crt_review_dt__c + ', closeddate=' + c.closeddate + ', isclosed=' + c.isclosed);
           if(c.crt_review_dt__c != null && c.isclosed == true){
                  c.Case_Age_In_Business_Hours__c = new UpdateClosed().updateHours(c.crt_review_dt__c, DateTime.now());
               
           }
        
   
        }
        

        update(ucase);
        }
    }
    
    
    private static void updateCaseAgeClosed(List<Case> triggerNew, Context triggerContext){
         
        System.debug('Inside trigger');
        for(Case c: triggerNew){
            System.debug('In forloop: crt_rev_dt=' + c.crt_review_dt__c + ', closeddate=' + c.closeddate + ', isclosed=' + c.isclosed);
           if(c.crt_review_dt__c != null ){
               c.Case_Age_In_Business_Hours__c = new UpdateClosed().updateHours(c.crt_review_dt__c, DateTime.now());  
           }
        
   
        }
        
        
    }
    */
     /**
     * Passes all cases, that have not already been analyzed, to be scored
     * 
     * <p>
     * Passing to non Google analyzation. Can potentitally run a batch call if
     * number of cases is greater than 200
     *
     * @author  Mike McGee 
     * @param   triggerNew      list of new cases from trigger. 
     * @param   triggerContext  context that trigger was activaited in.
     * 
     */
/*    private static void scoreSentiments(List<Case> triggerNew, Context triggerContext)
    {
        List<Case> caseList = new List<Case>();
        //add only cases that have not yet been analyzed 
        for(Case c : triggerNew)
        {
            if(c.isAnalyzed__c == false)
            {
                caseList.add(c);
            }
    
        }
        //Send case list to be scored by SentimentAnalysis_B class 
        SentimentAnalysis_B scorer = new SentimentAnalysis_B();
        scorer.caseScorer(caseList);
    } */
    
    
    
    /**
     * Sets CRT review date of case to today if case was previouly unassigned
     * 
     * @param   triggerNew      list of new cases from trgger. 
     * @param   triggerContext  context that trigger was activaited in. 
     *  
     */
/*    private static void setCRTReviewDateOnCaseAssigned(List<Case> triggerNew, Context triggerContext)
    {
        for (Case iter: triggerNew) {
            if (iter.CRT_Review_DT__c == null && iter.Status != 'Unassigned') {
                iter.CRT_Review_DT__c = DateTime.now(); 
            }
        }
    } */
    
    
    /**
     * Reshuffles cases to CRT members
     * <p>
     * should redistribute cases evenly, activates when a new case
     * is creates or when any update occurs on a case i.e case closed
     * 
     */
/*    private static void shuffleCases()
    {
        enteredShuffleCases++; 
        //system.debug(enteredShuffleCases);
         List<User> users = [select Id, Lastlogindate from User where profile.name = 'CRT Member' and available__c = true];
    
        // Loop through the Available CRT Members, check if they have zero cases, redistribute cases if they do
            for (User testUser : users) {
                if (getUserCases(testUser.id) == 0) { 
                    Case_Allocator shuffler = new Case_Allocator();
                    break;
                }
            }

    } 
    // Return the number of Unassigned cases that belong to a user
    public static Integer getUserCases(String userId) {
    
        enteredGetUSerCases++; 
        system.debug(enteredGetUserCases);
        return [select count() from Case where OwnerId = :userId and Status = 'Unassigned' and isClosed = false];
    } */
    
    
   /**
     * Reshuffles cases to CRT members
     * <p>
     * should redistribute cases evenly, activates when a new case
     * is creates or when any update occurs on a case i.e case closed
     * 
     */
/*    private static void shuffleCases()
    {
        enteredShuffleCases++; 
        //system.debug(enteredShuffleCases);
         List<User> users = [select Id, Lastlogindate from User where profile.name = 'CRT Member' and available__c = true];
    
        String test = UserInfo.getProfileId();
        
        String id = [select Id from Profile where Name = 'CRT Member' limit 1].id;
        
        // Only run if the user is a CRT Member
        if (test == id) {
            // Loop through the Available CRT Members, check if they have zero cases, redistribute cases if they do
            for (User testUser : users) {
                if (getUserCases(testUser.id) == 0) { 
                    Case_Allocator shuffler = new Case_Allocator();
                    break;
                }
            }
        }
    }
    // Return the number of Unassigned cases that belong to a user
    public static Integer getUserCases(String userId) {
    
        enteredGetUSerCases++; 
        system.debug(enteredGetUserCases);
        return [select count() from Case where OwnerId = :userId and Status = 'Unassigned' and isClosed = false];
    } 
    
*/
    
    
    /**
     * Track the time that has elapsed between changes in status
     * <p>
     * Create child records when status picklist is changed. 
     * Calculate the time in minutes, between the last modified and current date. 
     * Measure the time in minute increments. 
     * This will be used in a rollup calculation by a parent object. 
     * Execution: On Status (picklist) change
     * 
     * @author Ruben Ortiz
     * @author Mathew Bald
     * @param   triggerNew      all cases including the ones created by the trigger. 
     * @param   oldMap          map from Id to sObject of all cases before new case was created. 
     * @param   triggerContext  context that trigger was activaited in
     */
/*    private static void trackStatusChangeHistory(List<Case> triggerNew, Map<Id, sObject> oldMap , Context triggerContext)
    {
         //loop through every case in the new set of cases 
        for(Case c: triggerNew){
            
            //get every old case with the same Id 
            Case oldCase = (Case)oldMap.get(c.Id);
            
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
                
                
            } //end of if.  
        }//end of for loop 
    } //end of shuffleCases 
*/   
    
        
    /**
     * Used during Prod to Dev refresh to assign record ownership from 
     * default sysadminto the CRT agent working the case
     * 
     * @param   triggerNew      list of all cases including new cases created
     * @param   triggerContext  context that trigger was activaited in
     */
/*    private static void updateOwner(List<Case> triggerNew, Context triggerContext)
    {
        List<User> owner = [select id, name from user where profile.name = 'CRT Member'];
        

        for (Case iter: triggerNew) {
            
            for(Integer i = 0; i < owner.Size(); i++ ){
                
                if(iter.Owner__c == owner.get(i).name){
                    iter.OwnerId = owner.get(i).id;
                }           
            }
        }
    } */
    
    
}