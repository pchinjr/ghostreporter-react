@isTest
private class Test_CaseTest3 {

 @testSetup static void setup() {
  List<Case> originalCase = new List<Case>();
  for(Integer x=0;x < 100; x++){
        Case tmp = new Case();
        tmp.account_id__c = x +'123454';
        tmp.status = 'In Progress';
        tmp.origin = 'Other';
        tmp.description = 'asdbcew';
        originalCase.add(tmp);
  }
       insert originalCase;
     
 }
 
	private static testMethod void test() {
    //insert the duplicate cases
     List<Case> dupCase = new List<Case>();
         for(Integer x= 0; x< 100; x++){
           Case tmp = new Case();
            tmp.account_id__c = x + '123454';
            tmp.status = 'In Progress';
            tmp.origin = 'Other';
            tmp.description = 'asdbcew';
            dupCase.add(tmp);
            
         }
         insert dupCase;
         
     List<Case> dupInsertCase = [select id from case where status = 'System Cancelled'];
     
     System.assert(dupInsertCase.size() == dupCase.size());
     
	}

}