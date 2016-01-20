@isTest
global class CaseConsolidator_Test {
	
    public CaseConsolidator_Test () {
        runPositiveTestCases();
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
        String query = 'SELECT Id, Account_ID__c, casenumber, ConsolidateExclude__c, Description, Priority, Origin, Status From Case';
        //create cases to be consolidated
        List<Case> caseList = new List<Case>(); 
        for (integer i = 0; i < 10; i++) {
            caseList.add(new Case(Account_ID__c = '00002',   Priority = 'Medium', Description = 'Test Description')); 
        }
        insert caseList;

        Test.startTest(); 
		CaseConsolidator_Batch testBatch = new CaseConsolidator_Batch(query); 
        Database.executeBatch(testBatch);
        Test.stopTest(); 
        
        CaseConsolidator testConsolidator = new CaseConsolidator(); 
        testConsolidator.startBatch();
        
        //after the test delete all newly made cases
        List<Case> casesToDelete = [SELECT ID From case WHERE Account_ID__c = '00002'];
        delete casesToDelete;
    }
   
}