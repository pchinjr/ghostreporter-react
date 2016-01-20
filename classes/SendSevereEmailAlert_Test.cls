@isTest
private class SendSevereEmailAlert_Test {

static testmethod void emailAttachmentVisibleOnParentTest() {
	EmailMessage em = new EmailMessage();
	
	Contact con = new Contact();
	con.firstName = 'Ruben';
	con.lastname = 'Ortiz';
	con.email = 'rortiz@ouc.com';
   
	insert con;
	
	 
	
	Case testCase = new Case();
	testCase.origin = 'Email';
	testCase.status = 'Unassigned';
	testCase.Priority = 'Severe';
	testCase.contactid = con.id;
	testCase.Description = 'test email';
	
	insert testCase;
	em.parentid = testCase.id;
	em.FromAddress = 'rortiz@r-tybxa3k94zzjkxpnpq4kmh8fydu47xntb1q1dphmo66k0nlv5.e-5ofbmeaw.cs15.case.sandbox.salesforce.com';
	em.toAddress = 'rortiz@ouc.com';
	em.ccAddress = 'rortiz@ouc.com';
	insert em;

    String emailIds = [select id from EmailMessage where fromAddress = 'rortiz@r-tybxa3k94zzjkxpnpq4kmh8fydu47xntb1q1dphmo66k0nlv5.e-5ofbmeaw.cs15.case.sandbox.salesforce.com'].id;

    System.debug('emailid = ' + emailIds);

	Attachment a = new Attachment();
	a.name = 'test attachment';
	a.body = blob.valueof('attachment body');
	a.parentid = em.id;            
	insert a;   

	update testCase;
	System.debug('before future call attachmentid = ' + a.id + ', parentid=' + a.parentid);
	

	
	   User thisUser = [SELECT Id FROM User WHERE profile.name = 'System Administrator' limit 1];
       // System.runAs() allows mixed DML operations in test context
        //System.runAs(thisUser) {
            // startTest/stopTest block to run future method synchronously
            Test.startTest();    
            Attachment updatedAttachment = [select id, parentid from Attachment where id = :a.id];


            //AttachToCase.moveFileToCase(em.id);
            SendSevereEmailAlert.sendEmail(testcase.id, testcase.contactid);
            Test.stopTest();
       // }
        System.debug('after future call attachmentid = ' + a.id + ', parentid=' + a.parentid);

        //assert that the count of attached files to the case is equal to the number attached
        
		//System.assertEquals( testCase.id, updatedAttachment.ParentId );
}

}