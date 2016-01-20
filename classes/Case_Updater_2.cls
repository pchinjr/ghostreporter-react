/*
 * System.schedule('Unique Schedule Name4', '0 35 10 * * ?', new Case_Updater_2());
 *  This class should not be used since it's using CRDATE field
 */
global class Case_Updater_2 implements Schedulable {
    global void execute(SchedulableContext sc) {
        updateCaseObjects();
    }
    
    public void updateCaseObjects() { 
        
        List<Case> caseList = [select Id, CRDate__c, Case_Age_In_Business_Hours__c from Case where IsClosed = false];
        
        for (Case iter : caseList) {
             // find the age of the case in business hours
            iter.Case_Age_In_Business_Hours__c = hoursSinceCreation(iter);
            update iter;
        }
    }
    
    public double hoursSinceCreation(Case inputCase) {
        // convert milliseconds to hours : millis/1000 => seconds/60 => minutes/60 => hours
        return BusinessHours.diff('01mi0000000HldpAAC', inputCase.CRDate__c, dateTime.now()) / 1000 / 60 / 60;  
    }
    
}