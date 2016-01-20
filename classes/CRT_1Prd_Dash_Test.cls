@isTest
global class CRT_1Prd_Dash_Test {
	
    static User ruben;
    static User alex;
    
    static testMethod void runPositiveTestCases() {
        
        //Add case to test caseHour
        Case caseHourTest = new Case(); 
        ruben = [select Id, name from user where username = 'arivera@ouc.com'];
        caseHourTest.OwnerId = ruben.Id; 
        caseHourTest.CRT_Review_DT__c = Date.today(); 
        system.debug('Inserting case: '+caseHourTest);
        insert caseHourTest;
        //For test, need to pass in an OwnerId 
        new CaseHour(ruben.Id); 
        
        //Put a case in with Alex as user
        alex = [select Id, name from user where username = 'arivera@ouc.com'];
        
        
        /**
         * Need to put some data in salesforce so that it can be used for the test. 
         * 
         */
        List<Case> caseList = new List<Case>(); 
        //add 30 cases to list of cases. 
        for (integer i = 0; i < 30; ++i) {  
            CaseList.add(buildCase(alex.Id));
        }
        insert caseList;
        
        
        new Case_Totals_Wrapper();
        
        List<AggregateResult> aggregateResults = [select origin, source__c, priority, sum(CRT_Ops_InProg__c) inpr, sum(CRT_Ops_Closed__c) clsd, 
                                sum(CRT_Ops_Promoted__c) prom, sum(CRT_Ops_Queue__c) queue, 
                                sum(CRT_Ops_Unassigned__c) unass,  max(case_age_Unassigned__c) oldest,  
                                avg(case_age_in_business_hours__c) avgh, min(case_age_in_business_hours__c) cmin,  max(case_age_in_business_hours__c) cmax 
                                from case 
                                group by origin, source__c, priority limit 1];
        
        Case_Wrapper caseWrapper = new Case_Wrapper(aggregateResults);
        caseWrapper.getAvgs();
        
        CaseDetail_Wrapper caseDet = new CaseDetail_Wrapper();
        caseDet.getOne();
        
        User_Wrapper.GetElapsedTime(Datetime.now());
       
        User_Wrapper uw1 = new User_Wrapper();
        uw1.getCurrentCaseID('Alex Rivera');
        
        CRT_1Prd_Dash test = new CRT_1Prd_Dash();
        test.MelindaHours = 10; 
        test.RubenHours = 10; 
        test.AlexHours = 10;
        test.incrementCount = 10; 
        test.showBadge = ''; 
        test.getAgentTotals(); 
        test.getUser(); 
        test.getHours(); 
        test.getAgentStats();   
        
        test.incrementCounter();
        test.getCount();
        test.getAgentStatsbyOrigin2();
    } 
    
    private static Case buildCase(String Id) {
       /**
        *select origin, source__c, priority, sum(CRT_Ops_InProg__c) inpr, sum(CRT_Ops_Closed__c) clsd, 
                                sum(CRT_Ops_Promoted__c) prom, sum(CRT_Ops_Queue__c) queue, 
                                sum(CRT_Ops_Unassigned__c) unass,  max(case_age_Unassigned__c) oldest,  
                                avg(case_age_in_business_hours__c) avgh, min(case_age_in_business_hours__c) cmin,  max(case_age_in_business_hours__c) cmax 
                                from case 
                                group by origin, source__c, priority
         */
        List<String> statusList = new List<String>(); 
        statusList.add('Unassigned'); 
        statusList.add('In Progress'); 
        statusList.add('Promoted'); 
        statusList.add('Prevented'); 
        statusList.add('Resolved');
        statusList.add('Cancelled'); 
        statusList.add('Closed'); 
        statusList.add('Completed'); 
        
        Case tempCase = new Case(source__c = 'CRT', origin = 'ProActive', priority = 'medium', case_age_Unassigned__c = getRandomInt(), 
                                case_age_in_business_hours__c = getRandomInt(), OwnerID = Id, maxDate__c = Date.today(), crt_review_dt__c = Date.today() ); 
        tempCase.Status = statusList.get(Math.mod(statusList.size() - 1, getRandomInt()));
        return tempCase;
    }
    /*
    	static testMethod void test_positive() {
        List<Case> assertCase;
        List<AggregateResult> testMaxCase;
        List<User_Wrapper> userTest;
        
        alex = [select Id, name from user where username = 'arivera@ouc.com'];
        
        Case testCase = new Case(); 
        alex = [select Id, name from user where username = 'arivera@ouc.com'];
        testCase.OwnerId = alex.Id; 
        testCase.CRT_Review_DT__c = Date.today();
        testCase.maxDate__c = DateTime.Now();
        testCase.source__c = 'test class';
        testCase.origin = 'Email';
        
        
        List<Case> caseList = new List<Case>(); 
        CaseList.add(testCase);
        insert caseList;

        CRT_1Prd_Dash test = new CRT_1Prd_Dash();
      
        testMaxCase = [SELECT origin, source__c, person_id__c, owner.name, status,  max(maxDate__c) crt_review_dt from case
                        where   maxDate__c != null 
                        and owner.name = 'Alex Rivera'
                        group by  origin, source__c, person_id__c, owner.name, status
                        order by  max(maxDate__c) desc limit 1];
        
      
        
        userTest = test.getUser();
        
        System.debug('Size=' + userTest.size());
        
        for(User_Wrapper c: userTest){
            System.assertEquals('test class', c.source);
        }
        
        
	}
*/
    
    
    
    private static integer getRandomInt() {
        return Math.round( 1+ 10 * Math.random() );
    }
}