/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AJAXController_Test {
	
	static testMethod void testCheckingInOutNoCases() {
		AJAXController aC = new AJAXController();
		
		aC.checkUserIn(); 
		
		Boolean trueStatus = aC.userStatus;
		
		aC.checkUserOut();
		
		Boolean falseStatus = aC.userStatus;
		
		if (trueStatus != falseStatus)
			System.assert(true);
			
		else System.assert(false);
	}
	
	static testMethod void testCheckingInOut() {
		Case testCase = new Case();
		testCase.Status = 'Unassigned';
		testCase.Description = 'nulls are bad';
		
		System.test.startTest();
		insert testCase;
		System.test.stopTest();
		
		AJAXController aC = new AJAXController();
		
		aC.checkUserIn(); 
		
		Boolean trueStatus = aC.userStatus;
		
		aC.checkUserOut();
		
		Boolean falseStatus = aC.userStatus;
		
		if (trueStatus != falseStatus)
			System.assert(true);
			
		else System.assert(false);
		
	}
	
	static testMethod void testGetActivityPageRef() {
		Event testEvent = new Event();
		testEvent.ActivityDateTime = DateTime.now();
		testEvent.DurationInMinutes = 10;
		testEvent.Subject = 'Call';
		
		System.test.startTest();
		insert testEvent;
		System.test.stopTest();
		
		AJAXController tC = new AJAXController();
		
		AJAXController.retrieveActivitiesData(); 
		
		tC.objType = 'Activity';
		tC.objId = testEvent.Id;
		
		PageReference ref = tC.getPageRef();
		
		// the event wasn't found
		if (ref == null) {
			System.assert(false);
		}
		// the event was found
		else System.assert(true);
	}
	
	static testMethod void testGetCasePageRef() {
		
		Case testCase = new Case();
		testCase.Status = 'Unassigned';
		testCase.Description = 'never null';
		testCase.OwnerId = UserInfo.getUserId();
		
		System.test.startTest();
		insert testCase;
		System.test.stopTest();
		
		AJAXController tC = new AJAXController();
		
		tC.objType = 'Case';
		tC.objId = [select Id, CaseNumber from Case limit 1].CaseNumber;
			
		PageReference ref = tC.getPageRef();
		
		// the case wasn't found
		if (ref == null) {
			System.assert(false);
		}
		// the case was found
		else System.assert(true);
		
	}
	
	static testMethod void testNullCaseRetrieval() {
		
		AJAXController tC = new AJAXController();
		
		PageReference ref = tC.findNextCaseUnassigned();
		
		// no case is found
		if (ref == null)
			System.assert(true);
		
		// somehow a case was returned
		else System.assert(false);
		
	}
	/*
	static testMethod void testControllerPriorityCounts() {
		AJAXController tC = new AJAXController();
		
		// controller (calling JSON generating class) counted 0 cases
		if ((tC.in_PC + tC.unaC + tC.promoC) == 0)
			System.assert(true);
		
		// counted > 0 cases
		else System.assert(false);
	}
	*/
	/*
    static testMethod void testControllerWhenEmpty() {
        
        AJAXController tC = new AJAXController();
        
        // counted 0 cases
        if ((tC.highPriority +
			 tC.medPriority +
			 tC.lowPriority) == 0)
			 System.assert(true);
		// found some cases
		else System.assert(false);
    }
    */
    /*
    static testMethod void testControllerWithCases() {
    	
    	List<Case> cList = new List<Case>();
    	
    	Case lowP = new Case();
    	lowP.Priority = 'low';
    	cList.add(lowP);
    	
    	Case medP = new Case();
    	medP.Priority = 'medium';
    	cList.add(medP);
    	
    	Case hiP = new Case();
    	hiP.Priority = 'high';
    	cList.add(hiP);
    	
    	System.test.startTest();
    	insert cList;
    	System.test.stopTest();
    	
    	AJAXController tC = new AJAXController();
    	
    	// found 1 case of each priority
    	if (tC.lowPriority == 1 && tC.medPriority == 1 && tC.highPriority == 1)
    		System.assert(true);
    		
    	// found something different
    	else System.assert(false);	
    }
	*/
}