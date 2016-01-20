@isTest
private class Case_Delete_Test {

  static testMethod void testDeleteNullDescription() {

        List<Case> testCase; 
        List<Case> testEmptyCase; 
        
        


        try {
           Case delcase = new Case(status = 'Unassigned', account_id__c = '123', Description = null);
           insert delcase;
           
           testCase = [select Id, Description from Case where account_id__c = '123' limit 1];
        
           System.debug('testCase size:' + testCase.size());
        
           //DeleteEmpty cdel = new DeleteEmpty(testCase);
        
           testEmptyCase = [select Id, Description from Case where account_id__c = '123' limit 1];
           System.debug('testEmptyCase size:' + testEmptyCase.size() + ', null:' + testEmptyCase);
           
           if(testEmptyCase.size() == 0){
               System.assert(true);
           }
        }
        catch(QueryException e) {
            System.debug('Exception:' + e);
        }
        
    if (testEmptyCase.size() > 0)
      System.assert(false);
  }

}