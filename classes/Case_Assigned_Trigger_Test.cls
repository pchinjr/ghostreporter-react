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
private class Case_Assigned_Trigger_Test {

    static testMethod void testUnassignedInsert() {
        Case newCase = new Case();
        
        newCase.Status = 'Unassigned';
        
        System.test.startTest();
        insert newCase;
        System.test.stopTest();
        
        Case unaCase = [select Id, CRT_Review_DT__c, Status from Case limit 1];
        
        if (unaCase.CRT_Review_DT__c == null)
        	System.assert(true);
        
        else {
        	System.debug(unaCase.Status);
        	System.debug(unaCase.CRT_Review_DT__c);
        	System.assert(false);
        }
    }
    
    static testMethod void testInProgressInsert() {
    	Case newCase = new Case();
        
        newCase.Status = 'In Progress';
        
        System.test.startTest();
        insert newCase;
        System.test.stopTest();
        
        Case inPCase = [select Id, CRT_Review_DT__c, Status from Case limit 1];
        
        if (inPCase.CRT_Review_DT__c != null)
        	System.assert(true);
        
        else {
        	System.debug(inPCase.Status);
        	System.debug(inPCase.CRT_Review_DT__c);
        	System.assert(false);
        }
    }
    
    static testMethod void testInProgressUpdate() {
    	Case newCase = new Case();
        
        newCase.Status = 'Unassigned';
        
        System.test.startTest();
        insert newCase;
        
        Case unaCase = [select Id, CRT_Review_DT__c, Status from Case limit 1];
        
        Boolean check1 = false;
        
        if (unaCase.CRT_Review_DT__c == null)
        	check1 = true;
        
        else {
        	System.debug('Failed first checkpoint');
        	System.debug(unaCase.Status);
        	System.debug(unaCase.CRT_Review_DT__c);
        	System.assert(false);
        }
        
        unaCase.Status = 'In Progress';
        
        update unaCase;
        
        System.test.stopTest();
        
        Case inPCase = [select Id, CRT_Review_DT__c, Status from Case limit 1];
        
        Boolean check2 = false;
        
        if (inPCase.CRT_Review_DT__c != null)
        	check2 = true;
        
        else {
        	System.debug(inPCase.Status);
        	System.debug(inPCase.CRT_Review_DT__c);
        	System.assert(false);
        }
        
        System.assert(check1 && check2);
    }
}