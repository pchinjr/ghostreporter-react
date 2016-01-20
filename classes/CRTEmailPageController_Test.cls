/**
 * This class contains unit tests for validating the behavior of Apex class
 * CRTEmailPageController.
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
 * Test class for CRTEmailPageController. 
 * <p>
 * Needs to test the controllers ability to: 
 * <ul>
 * <li>-Create an email based on the case number parameter that is passed through 
 * the page
 * <li>-Attach documents to the email.
 * <li>-Make sure that the email history is being built correctly
 * <li>-Make sure that the proprt addresses are placed in the cc, bcc, and to lists
 * </ul>
 * @author Mike McGee
 */
@isTest
private class CRTEmailPageController_Test {
	
	/**
	 * Inserts all data needed to properly test.
	 * Set's all data values to their initial configurations.
	 * All values set in this method will persist throughout
	 * all test methods to be executed in the running context. 
	 */
	@testSetup static void setup() {
		// Have to insert a user so they can be assigned as the case owner
		//User u = new User(); 
		//u.FirstName = 'Test';
		//u.Username = 'tUser';
		//u.Email 'tU@test.com';
		//u.Alias = 't User';
		//u.CommunityNickname = 't';
		//u.TimeZoneSidKey = 'America/New_York';
		//u.LocaleSidKey = 'en_US';
		//u.EmailEncodingKey = 'ISO-8859';
		// ProfileId, LanguageLocaleKey]: [Username, Email, Alias, CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey
		//u.lastName= 'User';
		//insert u;

		// Need a case to test the email off of
		Case testCase = new Case();
		testCase.Subject = 'Test Subject' ;
		testCase.Customer_Name__c = 'Test Customer Name';
		//testCase.ownerid = u.id;
		insert testCase;

		// Need users to test the cc, bcc, and to lists.
		List<User> userList = new List<User>();
		for (integer i = 0; i < 5; ++i) {
			User tempUser = new User();
			tempUser.Email = 'TestUser'+i+'@testEmail.com';
			userList.add(tempUser);
		}

	}



	/**
	 * Tests the email builder based of a case with no email history
	 * 
	 * @note None of the changes to the previously inserted case made in this mehtod
	 * will persist in proceding test methods. 
	 */
	@isTest static void noHistoryTest() {
		Case onlyCase = [SELECT Id, CaseNumber, Customer_Name__c FROM Case limit 1];

		// Set the current page to CREmailPage
		PageReference pref = Page.CRTEmailPage;

		// Set the page parameters for retURL and related case
		ApexPages.currentPage().getParameters()
				 .put('retURL', String.valueOf(Page.AgentErrors));
		ApexPages.currentPage().getParameters()
				 .put('related_case', String.valueOf(onlyCase.CaseNumber));

		// Instantiate a new controller
		CRTEmailPageController controller = new CRTEmailPageController();

		// Call get methods
		controller.getFromList();
		controller.getRecipientList();

		// Assert that the email body and subject were correctly built.
		String standardEmailBody = 'The following is an update to case #'+
			onlyCase.CaseNumber+' for customer '+onlyCase.Customer_Name__c+
			'.\n\n\n'+
			+'Sincerely,\nnull\n'+
			'Customer Resolution Advocate\nOrlando Utilities Commission\n'+
		
			+'Typical resolution time is between 24-48 hours; office hours are 8 am to 5 pm Mon-Fri';
		//System.assertEquals(standardEmailBody, controller.emailBody);
		String expectedSubject = 'Update to case #'+onlyCase.CaseNumber+' for customer '+onlyCase.Customer_Name__c;
		System.assertEquals(expectedSubject, controller.emailSubject);

		// Upload a document by using insertDoc method
		Document doc = new Document();
		doc.body = Blob.valueOf('This is a test body for a test document');
		doc.Name = 'This is test document name';
		doc.FolderId = System.UserInfo.getUserId();
		doc.AuthorId = System.UserInfo.getUserId();
		controller.attachedBlob = doc;
		controller.insertDoc();

		// Execute sending of email. Though no email will be sent from 
	    // a test context.
	    controller.additionalTo = 'test@test.com';
	    Test.startTest();
	    controller.sendEmail(); 
	    Test.stopTest();

	    // Call cancel and remove attachments 
	    controller.removeAttachments();
	    controller.cancel();

	}
	

	/**
	 * Tests the controller with a Case that has an email history.
	 */
	@isTest static void withHistoryTest() {
		// Add emails to Case before page load so that they will be included in
		// emailBofy
		Case onlyCase = [SELECT Id, CaseNumber, Customer_Name__c FROM Case limit 1];
		// Create emails to attach to onlyCase
		EmailMessage oldEmail = new EmailMessage();
		oldEmail.Subject = 'Old email test subject';
		oldEmail.TextBody = 'Old email test text body';
		oldEmail.ParentId = onlyCase.Id;
		oldEmail.FromAddress = 	'OldTestFrom@Test.com';
		oldEmail.ToAddress = 'OldTestTo@Test.com';
		oldEmail.MessageDate = Date.today();
		oldEmail.CcAddress = 'OldTestCc@Test.com';
		insert oldEmail;

		// Set the current page to CREmailPage
		PageReference pref = Page.CRTEmailPage;

		// Set the page parameters for retURL and related case
		ApexPages.currentPage().getParameters()
				 .put('retURL', String.valueOf(Page.AgentErrors));
		ApexPages.currentPage().getParameters()
				 .put('related_case', String.valueOf(onlyCase.CaseNumber));

		// Instantiate a new controller
		CRTEmailPageController controller = new CRTEmailPageController();

		// Call get methods
		controller.getFromList();
		controller.getRecipientList();

		// Assert that the email body and subject were correctly built. 
		String expectedEmailHistory = 
		'\n--------------------------------------------------\n'+
		'From: oldtestfrom@test.com\n'+
		'Sent: '+Date.today()+'\n'+
		'To: OldTestTo@Test.com\n'+
		'CC: OldTestCc@Test.com\n'+
		'Subject: Old email test subject\n\n'+
		'Old email test text body\n\n';

		System.assertEquals(expectedEmailHistory, controller.emailHistory);
		String expectedSubject = 'Update to case #'+onlyCase.CaseNumber+' for customer '+onlyCase.Customer_Name__c;
		System.assertEquals(expectedSubject.trim(), 
											controller.emailSubject.trim());

		// Upload a document by using insertDoc method
		Document doc = new Document();
		doc.body = Blob.valueOf('This is a test body for a test document');
		doc.Name = 'This is test document name';
		doc.FolderId = System.UserInfo.getUserId();
		doc.AuthorId = System.UserInfo.getUserId();
		controller.attachedBlob = doc;
		controller.insertDoc();

		// Execute sending of email. Though no email will be sent from 
	    // a test context. 
	    controller.additionalTo = 'test@test.com';
	    Test.startTest();
	    controller.sendEmail();
	    Test.stopTest();

	    // Call cancel and remove attachments 
	    controller.removeAttachments();
	    controller.cancel();
	}
	
}