/**
 * This class contains unit tests for validating the behavior of Apex class
 * ErrorDisputeHelper.
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
public class ErrorDisputeHelper_Test {
	
    /**
     * Sets up data that can be used in all test methods. 
     * Any data that is changed in one test method will be 
     * reset to its original data in the next test mehtod. 
     */
    @testSetup static void setup() {
        //Error needs AgentErrors which needs Agent
        AgentTeam__c aTeam = new AgentTeam__c();
        aTeam.FirstName__c = 'Test';
        aTeam.LastName__c = 'Name';
        aTeam.Supervisor_Email__c = 'fakeEmail@fake.com';
        aTeam.AgentType__c = 'Residential';
        aTeam.Team__c = 'Gigawatts';
        insert aTeam;
        
        // AgentErrors
        AgentErrors__c aErrors = new AgentErrors__c();
        aErrors.Date__c = Date.today();
        aErrors.Agent__c = aTeam.Id;
        insert aErrors;
        
        // Needs an Error object before and an EmailMessage during
        Error__c error = new Error__c();
        error.AgentErrors__c = aErrors.Id;
        error.Error_Type__c = 'Misc';
        error.Example__c = 'Wrong Info given';
        error.Date__c = Date.today();
        insert error;
    }
    
    
    @isTest static void positiveTest() {
        // Create email message with appropriate qualities
        // Subject line with error id 
        // body with dispute
        // fromaddress as error supervisor email
        Id errId = [SELECT Id FROM Error__c limit 1].Id;
        
        EmailMessage email = new EmailMessage();
        //email.ParentId = errId;
        // ParentId is required but must be a case Id. 
        Case tempCase = new Case();
        insert tempCase;
        email.ParentId = tempCase.Id;
        email.FromAddress = 'fakeEmail@fake.com';
        email.Subject = errId;
        email.TextBody = 'Dispute';
        email.ToAddress = 'faker@fake.com';
        insert email;
        
        // Get the error object
        Error__c errObj = [SELECT Id, Disputed__c FROM Error__c WHERE Id =: errId];
        System.assertEquals(true, errObj.Disputed__c);
        
    }
    
    @isTest static void negativeTest() {
        // Create email message with appropriate qualities
        // Subject line with error id 
        // body with dispute
        // fromaddress as error supervisor email
        Id errId = [SELECT Id FROM Error__c limit 1].Id;
        
        
        // Test with wrong subject
        EmailMessage email = new EmailMessage();
        //email.ParentId = errId;
        // ParentId is required but must be a case Id. 
        Case tempCase = new Case();
        insert tempCase;
        email.ParentId = tempCase.Id;
        email.FromAddress = 'fakeEmail@fake.com';
        email.Subject = 'not errId';
        email.TextBody = 'Dispute';
        email.ToAddress = 'faker@fake.com';
        insert email;
        
        // Get the error object
        Error__c errObj = [SELECT Id, Disputed__c FROM Error__c WHERE Id =: errId];
        System.assertEquals(false, errObj.Disputed__c);
        
        // Test with dispute not in body
        EmailMessage email2 = new EmailMessage();
        email2.ParentId = tempCase.Id;
        email2.FromAddress = 'fakeEmail@fake.com';
        email2.Subject = errId;
        email2.TextBody = 'Something else';
        email2.ToAddress = 'faker@fake.com';
        insert email2;
        
        errObj = [SELECT Id, Disputed__c FROM Error__c WHERE Id =: errId];
        System.assertEquals(false, errObj.Disputed__c);
        
        
        // Test with wrong fromaddress
        EmailMessage email3 = new EmailMessage();
        email3.ParentId = tempCase.Id;
        email3.FromAddress = 'agentEmail@fake.com';
        email3.Subject = errId;
        email3.TextBody = 'Dispute';
        email3.ToAddress = 'faker@fake.com';
        insert email3;
        
        errObj = [SELECT Id, Disputed__c FROM Error__c WHERE Id =: errId];
        System.assertEquals(false, errObj.Disputed__c);
    }
}