/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Launchpad_Controller_test {

	/** 
	 * testLowPCaseCount
	 * Test Objective:  To test that the Launchpad_Controller counts the correct number of low priority cases
	 * Test Description: Tests the lowPriority Integer in Launchpad_Controller is accurate
	 * Test Conditions: Create one low priority case and insert it into the database. Create a Launchpad_Controller object.
	 * Expected Results: The lowPriority field should be set equal to one.
	 * @author: Matthew Bald
	 */
    static testMethod void testLowPCaseCount() {
        
        // create a low priority test case
        Case lowPrio = TestDataFactory.createOneParentObject();
        lowPrio.Priority = 'Low';
        
        System.Test.startTest();
        
        // insert the case
        insert lowPrio;
        
        // instantiate a launchpad_controller
        Launchpad_Controller lp = new Launchpad_Controller();
        
        System.Test.stopTest();
        
        // check if the controller has the correct number of cases
    	System.assertEquals(lp.lowPriority, 1);
    }
   /** 
	 * testMedPCaseCount
	 * Test Objective:  To test that the Launchpad_Controller counts the correct number of medium priority cases
	 * Test Description: Tests the medPriority Integer in Launchpad_Controller is accurate
	 * Test Conditions: Create one medium priority case and insert it into the database.  Create a Launchpad_Controller object.
	 * Expected Results: The medPriority field should be set equal to one.
	 * @author: Matthew Bald
	 */
    static testMethod void testMedPCaseCount() {
        
        // create a medium priority test case
        Case medPrio = TestDataFactory.createOneParentObject();
        medPrio.Priority = 'Medium';
        
        System.Test.startTest();
        
        // insert the cases
        insert medPrio;
        
        // instantiate a launchpad_controller
        Launchpad_Controller lp = new Launchpad_Controller();
        
        System.Test.stopTest();
        
        // check if the controller has the correct number of cases
    	System.assertEquals(lp.medPriority, 1);
    }
    
    /**
     * testHiPCaseCount
	 * Test Objective:  To test that the Launchpad_Controller counts the correct number of high priority cases
	 * Test Description: Tests the highPriority Integer in Launchpad_Controller is accurate
 	 * Test Conditions: Create one high priority case and insert it into the database.  Create a Launchpad_Controller object.
	 * Expected Results: The highPriority field should be set equal to one.
	 * @author: Matthew Bald     
     */
    static testMethod void testHiPCaseCount() {
        
        // create a low priority test case
        Case hiPrio = TestDataFactory.createOneParentObject();
        hiPrio.Priority = 'High';
        
        System.Test.startTest();
        
        // insert the case
        insert hiPrio;
        
        // instantiate a launchpad_controller
        Launchpad_Controller lp = new Launchpad_Controller();
        
        System.Test.stopTest();
        
        // check if the controller has the correct number of cases
    	System.assertEquals(lp.highPriority, 1);
    }
    
    /**
    * testGetNextCase
	* Test Objective:  To test that the Launchpad_Controller can find an unassigned case.
	* Test Description: Tests that the getNextUnassigned function in Launchpad_Controller returns an unassigned case.
	* Test Conditions: Create one unassigned case and insert it into the database. Create a Launchpad_Controller object. Call the getNextUnassigned function and store the result in a temporary Case variable.
 	* Expected Results: The temporary case variable should contain a case that is unassigned.
    * @author: Matthew Bald
    */
    static testMethod void testGetNextCase() {
    	Case one = TestDataFactory.createOneParentObject();
    	one.Person_ID__c = 'One';
    	one.Status = 'Unassigned';
    	
    	System.Test.startTest();
    	
    	insert one;
    	
    	Launchpad_Controller lp = new Launchpad_Controller();
    	
    	System.Test.stopTest();
    	
    	Case testCase = lp.getNextUnassigned();
    	
    	System.assertEquals('Unassigned', testCase.Status);
    }
    
    /**
     * testGetPageReference
	 * Test Objective:  To test that the Launchpad_Controller can find a PageReference to redirect the User to their next unassigned case’s details page.
 	 * Test Description: Tests that the getPageReference does not return null. 
	 * Test Conditions: Create one unassigned case and insert it into the database. Create a Launchpad_Controller object. Call the getPageReference function and store the result in a temporary PageReference variable.
	 * Expected Results: The temporary PageReference variable should contain a PageReference that is not null.
     * @author: Matthew Bald
     */
    static testMethod void testGetPageReference() {
    	Case one = TestDataFactory.createOneParentObject();
    	one.Person_ID__c = 'One';
    	one.Status = 'Unassigned';
    	
    	System.Test.startTest();
    	
    	insert one;
    	
    	Launchpad_Controller lp = new Launchpad_Controller();
    	
    	System.Test.stopTest();
    	
    	PageReference pR = lp.findNextCaseUnassigned();
    	
    	System.assertNotEquals(pR, null);
    }    
}