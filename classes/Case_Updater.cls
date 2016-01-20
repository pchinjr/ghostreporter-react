/* Execute Anonymous script:
 * System.schedule('Unique Schedule Name4', '0 35 10 * * ?', new Case_Updater());
 */
global class Case_Updater implements Schedulable {
	
	public String hoursId;
	
	public Case_Updater() {
		hoursId = [select Id from BusinessHours].Id;
	}
	
	global void execute(SchedulableContext sc) {
		hoursId = [select Id from BusinessHours].Id;
		updateCaseObjects();
	}
	
	public void updateCaseObjects() { 
		
		List<Case> caseList = [select Id,   CreatedDate,
											CRDate__c,
											CRT_Review_DT__c,
											Case_Age_In_Business_Hours__c from Case where   IsClosed = true and
																							Status != 'Unassigned'];
        

		List<Case> updatedCaseList = new List<Case>(); 		
		for (Case iter : caseList) {
			 // find the age of the case in business hours
			Double hours =  hoursSinceCreation(iter);
			System.debug('hours: ' + hours + ', case_age: ' +iter.Case_Age_In_Business_Hours__c);
		 
				iter.Case_Age_In_Business_Hours__c = hours;
				updatedCaseList.add(iter);
		 

		} 

		update updatedCaseList;
	}
    
	public double hoursSinceCreation(Case inputCase) {
		
		if (inputCase.CRT_Review_DT__c == null)
			return 0;
		
		// convert milliseconds to hours : millis/1000 => seconds/60 => minutes/60 => hours
		return BusinessHours.diff(hoursId, inputCase.CRT_Review_DT__c, dateTime.now()) / 1000 / 60 / 60;	
	}
	
}