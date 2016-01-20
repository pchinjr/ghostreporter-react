/**
 * This class contains unit tests for validating the behavior of Apex class
 * CurrentCase, which is a controller extension for Case_Emails_Page.vfp
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
public class CurrentCase_Test {
    
    /**
     * Inserts all data needed to properly test.
     * Set's all data values to their initial configurations.
     * All values set in this method will persist throughout
     * all test methods to be executed in the running context. 
     */
    @testSetup static void setup() {
        // Need to insert a Case object with a related email.
        Case testCase = new Case();
        insert testCase; 
        
        // Related email
        EmailMessage oldEmail = new EmailMessage();
        oldEmail.Subject = 'Old email test subject';
        oldEmail.TextBody = 'Old email test text body';
        oldEmail.ParentId = testCase.Id;
        oldEmail.FromAddress =  'OldTestFrom@Test.com';
        oldEmail.ToAddress = 'OldTestTo@Test.com';
        oldEmail.MessageDate = Date.today();
        oldEmail.CcAddress = 'OldTestCc@Test.com';
        insert oldEmail;
    }
    
    
    @isTest static void positiveTest() {
        // Select the only case
        Case onlyCase = [SELECT id from Case limit 1];
        
        // Set current page to tercaseid.
        PageReference pref = Page.Case_Emails_Page;
        
        // Set some page parameters
        ApexPages.currentPage().getParameters()
                 .put('id', onlyCase.Id);
        
        // Call constructor
        CurrentCase emptyCon = new CurrentCase();
        // Call controller with standard controller
        ApexPages.StandardController con = new ApexPages.StandardController(onlyCase);
        CurrentCase controller = new CurrentCase(con);
        controller.newEmail();
        controller.replyAll();
    }
    
}