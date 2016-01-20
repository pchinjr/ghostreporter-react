@isTest
global class Batch_Age_Test {
	
    public  Batch_Age_Test () {
       // runPositiveTestCases();
        runBatchTestCase(); 
    }
    
    static testMethod void runPositiveTestCases() {
        Case c = new Case (Account_ID__c = '12345', Priority = 'Low', Description = 'Test Description3'); 
        insert c; 
        Case c1 = new Case (Account_ID__c = '12345', Priority = 'High', Description = 'Test Description2');
        insert c1; 
        Case c2 = new Case (Account_ID__c = '12345', Priority = 'Severe', Description = 'Test Description1'); 
        insert c2; 
        
        Case c3 = new case(Account_ID__c = '12345', Priority = 'Medium', Description = 'Test Description');
        insert c3; 
        new CaseConsolidator(c3);
    }
    
    static testMethod void runBatchTestCase() {
        DateTime dt;
        String query = 'select Id, closeddate, CreatedDate, CRDate__c, CRT_Review_DT__c, ' +
                'Case_Age_In_Business_Hours__c from Case where IsClosed = true and status <> \'Duplicate\'';
        Batch_CaseAgeUpdater bu = new Batch_CaseAgeUpdater();
        bu.query = query;
        
        dt = DateTime.now() - 1;
        
        //create cases to be aged
        List<Case> caseList = new List<Case>(); 
        for (integer i = 0; i < 10; i++) {
            caseList.add(new Case(Account_ID__c = '0000123', CRT_Review_DT__c = dt, Status = 'Promoted')); 
        }
        insert caseList;

        Test.startTest(); 
		
        Database.executeBatch(bu);
        Test.stopTest(); 
        

        
        //after the test delete all newly made cases
        List<Case> casesToDelete = [SELECT ID From case WHERE Account_ID__c = '0000123'];
        delete casesToDelete;
    }
   
}