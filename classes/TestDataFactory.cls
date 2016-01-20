@isTest
public class TestDataFactory {
	
	// Create parent object
	public static Case createOneParentObject() {
		
		Case testParent = new Case( Person_ID__c = 'test',
									Status = 'Unassigned',
									CC_ID__c = 'test',
									Account_ID__c = 'test',
									Description = 'nonononull');
		
		return testParent;
	}
	/*
	public static Status__c createOneStatus2Object(Case testP) {
		
		Status__c newStatus = new Status__c ( lmod__c = Datetime.now(),
												CreateDT__c = datetime.now(),
												Case__c = 'statustest',
												Status__c = 'status',
												Parent_Key__c = testP.Id );
		
		return newStatus;		
	}
	*/
}