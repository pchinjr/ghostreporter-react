/* Execute Anonymous script:
 * System.schedule('Unique Schedule Name4', '0 35 10 * * ?', new Case_Updater());
 */
global class Case_Updater_Closed implements Schedulable {
  global void execute(SchedulableContext sc) {
    updateCaseObjects();
  }
  
  public void updateCaseObjects() { 
    
    List<Case> caseList = [select Id, closeddate, CreatedDate, CRDate__c, CRT_Review_DT__c, Case_Age_In_Business_Hours__c, Description from Case where IsClosed = true];
        
    for (Case iter : caseList) {
       // find the age of the case in business hours
      iter.Case_Age_In_Business_Hours__c = hoursSinceCreation(iter);
      //update iter;
    } 
    update caseList;
  }
  
   public void updateClosedCaseObjects() { 
    
    List<Case> caseList = [select Id, closeddate, CreatedDate, CRDate__c, CRT_Review_DT__c, Case_Age_In_Business_Hours__c from Case 
                           where   IsClosed = true and status <> 'Duplicate' and CRT_Review_DT__C != null];
        
    for (Case iter : caseList) {
        
       System.debug('CRT_Review_DT=' + iter.CRT_Review_DT__c + ' , ClosedDate=' + iter.closeddate ); 
       System.debug('BusinessHours.Diff=' + BusinessHours.diff([select Id from BusinessHours].Id, iter.CRT_Review_DT__c, iter.closeddate));
  
       // find the age of the case in business hours
      iter.Case_Age_In_Business_Hours__c = hoursSinceCreation(iter);
      //update iter;
    } 
    update caseList;
  }
  
  
  
  public double hoursSinceCreation(Case inputCase) {
    
    if (inputCase.CRT_Review_DT__c == null)
      return 0;
    
    // convert milliseconds to hours : millis/1000 => seconds/60 => minutes/60 => hours
    return BusinessHours.diff([select Id from BusinessHours].Id, inputCase.CRT_Review_DT__c, inputCase.closeddate) / 1000 / 60 / 60;  
  }
  
}