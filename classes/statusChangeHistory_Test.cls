/*	This class contains tests for statusChangeHistory trigger
 *	which is used to track the hours that a case remains unassigned 
 *	as well as how long the case is inProgress 
 * 
 *  This class will test whether or not the statusChangeHistory trigger is exuctued 
 *  on any update in status to a case. 
 * 
 * This class will test to make sure correct values are being calculated *********
 * based on manually inserted creation dates, toInprogressDates, and ClosedDates ************
 * 	(As of right now, no way to manualy insert CreaedDates and ClosedDate)
 * 
*/

/* Written by Mike McGee 10/30/14 */

@isTest
private class statusChangeHistory_Test {
	
    //run tests on positive cases (cases with expected input)
    static testMethod void runPositiveTestCases(){
        
            //Single action test (test to make sure single case returns required result)
            //Step 1 create case 
            Case test_case = new Case(); //Case defaults to created date of today (read only)
        	insert test_case;
        	update test_case; 
            
            System.debug('Inserting one case,  Id: '+ test_case.Id); 
           
        //Change test case to inProgress and check that the trigger was run
            test_case.Status = 'In Progress';  
        	update test_case; 
        	
            System.debug('Changing case '+test_case.Id + ' to In Progress');
        
        	Case t1 = [SELECT Id, Status, Hours_Until_inProgress__c, Minutes_Until_inProgress__c FROM Case WHERE Id = :test_case.Id];
            System.debug('Test Case hours until inprogress = : '+ t1.Hours_Until_InProgress__c);
        	System.debug('Test Case Id  = : '+ t1.Id); 
        	System.debug('Test Case Status  = : '+ t1.Status); 
        	
        
        	System.assertEquals('In Progress',  test_case.Status); 
             // Check to make sure hours until in progress was updated   
            System.assert(t1.Hours_Until_InProgress__c != null);
            System.assert(t1.Minutes_Until_InProgress__c != null); 
             
            //Change to closed and make sure that hours until closed was updated     
            test_case.Status = 'Closed'; 
        	update test_case; 
        	System.debug('Changing case '+test_case.Id + ' to Closed');
        
        	t1 = [SELECT Id, Status, Hours_Until_inProgress__c, Minutes_Until_inProgress__c, Hours_UntilClosed__c, Minutes_Until_Closed__c FROM Case WHERE Id = :test_case.Id];
			System.debug('Test Case hours until inprogress = : '+ t1.Hours_UntilClosed__c);
        	System.debug('Test Case Id  = : '+ t1.Id);
        
        
       		System.assertEquals('Closed',  t1.Status); 
             // Check to make sure hours until closed was updated 
            System.debug('Test Case hours until inprogress = : '+ t1.Hours_Until_InProgress__c);  
            System.assert(t1.Hours_UntilClosed__c != null); 
            System.assert(t1.Minutes_Until_Closed__c != null);   
        
        	//Check for when case was created before trigger was activates 
        	Case test_case2 = new Case(); 
        	insert test_case2; 
        	test_case2.Status = 'Closed'; 
        	update test_case2; 
        	Case t2 =  [SELECT Id, Status, Hours_UntilClosed__c FROM Case WHERE Id = :test_case2.Id];
        	System.debug('Case2 hours until closed : '+ t2.Hours_UntilClosed__c);
        	System.assert(t2.Hours_UntilClosed__c != null);
        
        	//Check for specific value 
        	Case test_case3 = new Case(TestCreatedDate__c = DateTime.newInstance(2014, 10, 21, 15, 0, 0),
                                      					 CloseDateTest__c = DateTime.newInstance(2014, 10, 30, 10, 0, 0)); 
        	
        	Integer expectedHours = 52; 
        	insert test_case3;
        	update test_case3;
        
        	test_case3.Status = 'In Progress'; 
        	update test_case3; 
        	Case t3 = [SELECT Id, Hours_Until_InProgress__c, Minutes_Until_InProgress__c FROM Case WHERE Id = :test_case3.Id];
        	System.debug('test_case3 Id: '+test_case3.Id);
        	System.debug('t3 Id: '+ t3.Id);
        	System.debug('T3 hours until in progress: ' + t3.Hours_Until_InProgress__c);
        	System.debug('T3 minutes until in progress: ' + t3.Minutes_Until_InProgress__c);
        	
        	System.assertEquals(expectedHours, t3.Hours_Until_InProgress__c); 
        	
        	test_case3.Status = 'Closed'; 
        	update test_case3;
                    
            
            //Bulk vlaidation 
            System.debug('Inserting 200 test cases');
           //add 200 test cases              
            List<Case> testCases = new List<Case>();
            for(integer i = 0; i < 200; i++)
            {
            	testCases.add(new Case(Status = 'Unassigned'));     
            }
        
        	insert testCases; 
			
        	
            //Switch status of all 200 to In Progress
            for(Case c : testCases)
            {
                c.Status = 'In Progress'; 
            }
            
        	update testCases; 
        	
        	List<Case> list1= [SELECT Id, Hours_Until_InProgress__c, Minutes_Until_InProgress__c FROM Case WHERE CreatedDate = TODAY];	
        
            //loop through all cases asserting that hours_until_inProgrss and minutes_until_inPrgress are not null 
            for(Case c : list1)
            {
                System.assert(c.Hours_Until_InProgress__c != null); 
                System.assert(c.Minutes_Until_InProgress__c != null); 
            }
            
            //repeat above process for switching to closed 
            //Switch status of all 200 to closed 
            for(Case c : testCases)
            {
                c.Status = 'Closed'; 
            }
            update testCases; 
        
        	 list1= [SELECT Id, Hours_Until_InProgress__c, Minutes_Until_InProgress__c, Hours_UntilClosed__c, Minutes_Until_Closed__c FROM Case WHERE CreatedDate = TODAY];	
        
            //loop through all cases asserting that hours_until_inProgrss and minutes_until_inPrgress are not null 
            for(Case c : list1)
            {
                System.assert(c.Hours_UntilClosed__c != null); 
                System.assert(c.Minutes_Until_Closed__c != null); 
            }

    }
    
   /* 
    //Negative test cases (incorrect userinput)
    static testMethod void runNegativeTestCases(){
        //Insert a previously closed method that already has Hours Unassigned and Hours Until Closed fields 
        Case failCase = new Case(Hours_Until_InProgress__c = 5, Hours_UntilClosed__c = 5, Status = 'Closed'); 
        insert failCase; 
        
        failCase.Status = 'In Progress'; 
        update failCase; 
        
        Case f1 = [SELECT Id, Status, Hours_Until_InProgress__c, Hours_UntilClosed__c FROM Case WHERE Id = : failCase.Id]; 
      	System.debug('Fail Case hours until in progress = ' + failcase.Hours_Until_InProgress__c);
        System.debug('F1 Hours until in progress =' + f1.Hours_Until_InProgress__c);
        System.debug('Fail Case hours until Closed = ' + failcase.Hours_UntilClosed__c);
        System.debug('F1 Hours until Closed =' + f1.Hours_UntilClosed__c);
        
        System.assertEquals(f1.Hours_Until_InProgress__c, failCase.Hours_Until_InProgress__c); 
        System.assertEquals(f1.Hours_UntilClosed__c, failCase.Hours_UntilClosed__c);
        
    } */
	
}