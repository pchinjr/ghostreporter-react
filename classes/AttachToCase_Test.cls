@isTest
private class AttachToCase_Test {
 
  @isTest static void test1() {
        User thisUser = [SELECT Id FROM User WHERE profile.name = 'System Administrator' limit 1];
       // System.runAs() allows mixed DML operations in test context
        System.runAs(thisUser) {
            // startTest/stopTest block to run future method synchronously
            Test.startTest();        
            AttachToCase.moveFileToCase('das');
            Test.stopTest();
        }
        // The future method will run after Test.stopTest();
    
        // Verify account is inserted
        Account[] accts = [SELECT Id from Account WHERE Name='Acme'];
        System.assertEquals(1, accts.size());
        // Verify user is inserted
        User[] users = [SELECT Id from User where username='mruiz@awcomputing.com'];
        System.assertEquals(1, users.size());
    }

}