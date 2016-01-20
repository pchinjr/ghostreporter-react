@isTest
global class CaseHour_Test {
    static testMethod void runPositiveTestCases() { 
        /**
         * Since this is a test then soql does not have access to previously loaded data, need to 
         * create new data to insert in order for soql to return results. 
         */
         
        Case test = new Case(); 
        User ruben = [select Id, name from user where name = 'Ruben Ortiz'];
        test.OwnerId = ruben.Id; 
        test.CRT_Review_DT__c = Date.today(); 
        system.debug('Inserting case: '+test);
        insert test;
        //For test, need to pass in an OwnerId 
        new CaseHour(ruben.Id); 
    }
}