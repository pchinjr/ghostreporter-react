@isTest
private class Alert_Test {

	private static testMethod void test_positive() {
        Jitterbit_Monitor jm = new Jitterbit_Monitor();
        List<Case> assertCase;
        Case testCase =  new Case(inERM__c = false, JitterbitAlert__c = false, status = 'In Progress', crt_review_dt__c = DateTime.now() );
        insert testCase;
        
        jm.alert();
        
        assertCase = [select JitterbitAlert__c from case where id = :testCase.id limit 1];
        
        for(Case c: assertCase){
            System.assertEquals(true, c.JitterbitAlert__c);
        }
        
        
	}

	private static testMethod void test_reset() {
        Jitterbit_Monitor jm = new Jitterbit_Monitor();
        List<Case> assertCase;
        Case testCase =  new Case(JitterbitAlert__c = true );
        insert testCase;
        
        jm.resetAlert();
        
        assertCase = [select JitterbitAlert__c from case where id = :testCase.id limit 1];
        
        for(Case c: assertCase){
            System.assertEquals(false, c.JitterbitAlert__c);
        }
        
        
	}


}