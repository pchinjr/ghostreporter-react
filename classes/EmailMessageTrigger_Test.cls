@isTest
global class EmailMessageTrigger_Test {
	//run Positive test cases 
	static testMethod void runPositiveTestCases()
    {

        //Create case to attach message to
        Case testCase = new Case(Origin = 'Email', Description = 'This is a test body ', SuppliedEmail = 'run_test@test.com'); 
        insert testCase; 
        
        
        Case testCase2 =  new Case(Origin = 'Email', Description = 'This is a test body ', SuppliedEmail = 'run_test@test.com');
        insert testCase2; 
        
        //Create email message to insert
        EmailMessage message = new EmailMessage();
        
        message.TextBody = 'This is a test body '; 
        //Will maybe need to change this each time test is run. 
        message.FromAddress = 'run_test@test.com';
        //Probably have to change this to production email2case address when uploading
        message.toAddress = 'rortiz@r-tybxa3k94zzjkxpnpq4kmh8fydu47xntb1q1dphmo66k0nlv5.e-5ofbmeaw.cs15.case.sandbox.salesforce.com';
        message.Subject = 'Test';
        message.ParentId = testCase.Id; 
        //message.Status = 'draft';
       	
        //insert email
        insert message; 
        //List<Messaging.SendEmailResult> results =  Messaging.sendEmailMessage(new ID[] { message.id });
        
        
        EmailMessage message2 = new EmailMessage();
        message2.Subject = 'test';
        message2.ToAddress = 'rortiz@r-tybxa3k94zzjkxpnpq4kmh8fydu47xntb1q1dphmo66k0nlv5.e-5ofbmeaw.cs15.case.sandbox.salesforce.com';
        message2.FromAddress = 'run_test@test.com';
        message2.ParentId = testCase.Id; 
        insert message2; 
        
        
        Case case1 = [SELECT Id, CaseNumber From Case WHERE ID = :testCase.Id];
        
        EmailMessage message3 = new EmailMessage();
        message3.Subject = case1.CaseNumber;
        message3.ToAddress = 'rortiz@r-tybxa3k94zzjkxpnpq4kmh8fydu47xntb1q1dphmo66k0nlv5.e-5ofbmeaw.cs15.case.sandbox.salesforce.com';
        message3.FromAddress = 'run_test@test.com';
        message3.ParentId = testCase2.Id;
        insert message3; 


        //test for update 
        /*
         * Cannot make an update call in the trigger, Will throw DmlException INVALID_OPERATION error. 
         */
        
        //test for delete. 
        delete message; 
        

    }
    
}