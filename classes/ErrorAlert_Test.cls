/**
 * This class contains unit tests for validating the behavior of Apex class
 * ErrorAlert.
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
 *
 * @author Mike McGee
 */
@isTest
private class ErrorAlert_Test {
    
    /**
     * Sets up data that can be used in all test methods. 
     * Any data that is changed in one test method will be 
     * reset to its original data in the next test mehtod. 
     */
    @testSetup static void setup() {
        // Will need AgentTeam AgentErrors and Errors objects to test against.
        // Will also need a Contact record with a non null email
        AgentTeam__c aTeam = new AgentTeam__c();
        aTeam.Agent_Email__c = 'fakeEmail@fakeEmail.com';
        aTeam.Supervisor_Email__c = 'fakeEmail@fakeEmail.com';
        insert aTeam;
        
        AgentErrors__c aErrors = new AgentErrors__c();
        aErrors.Date__c = Date.today();
        aErrors.Agent__c = aTeam.Id;
        insert aErrors;
        
        Contact con = new Contact();
        con.Email = 'fakeEmail@fakeEmail.com';
        con.LastName = 'Fake';
        insert con;
        
        // Errors object will be inserted in the test methods
    }
    
    
    /**
     * Tests with expected input
     */
    @isTest static void positiveTest() {
        Error__c err = new Error__c();
        err.Error_Type__c = 'ATO';
        err.Date__c = Date.today();
        err.AgentErrors__c = [SELECT Id FROM AgentErrors__c limit 1].Id;
        insert err;
        
        Attachment att = new Attachment();
        att.Name = 'Temp name';
        att.Body = Blob.valueOf('This is a text body');
        att.ParentId = err.Id;
        insert att;
        
        // Now update err to be completed
        Error__c insertedError = [SELECT Id FROM Error__c WHERE Id =: err.Id];
        insertedError.Error_Completed__c = true;
        update insertedError;
    }
    
    
    /**
     * Tests with unexpected input
     */
    @isTest static void negativeTest() {
        
    }
}