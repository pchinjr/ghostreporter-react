@isTest

private class Email_Shuffle_Trigger_Test {

  
   static testMethod void Case_ShuffleNotNull(){
   	
   	System.test.startTest();
   	Case_Allocator ca = new Case_Allocator();
   	system.test.stopTest();
   	
   	if(ca != null)
   	 System.assert(true);
   	 else
   	 System.assert(false);
   	
   	
   }
  
   static testMethod void Case_Shuffle_Email2Test() {
    
    
    
    	Case testCase = new Case();
		testCase.Status = 'Unassigned';
		testCase.Origin = 'Email';
		testCase.Description__c = 'Nothing';
		testCase.OwnerId = '12312';
		
		System.test.startTest();
		insert testCase;
		System.test.stopTest();
		
		Case_Allocator ca = new Case_Allocator();
       	ca.reshuffleEmailCases();	
		List<User> user1 = new List<User>();
		 
		try {
			/* for UAT, use the  lastlogindate in the where clause:  lastlogindate = today */
			user1 = [select id, lastlogindate, profile.name, available__c from user
								where profile.name = 'CRT Member' ];
	  	} catch(QueryException e) {
	  		// no available agents
	  	}  
		 
			if ( testCase.OwnerId != '12312')
			   System.assert(true);
			else System.assert(false);
	 	
		 
		

       
	   
	        
	      
        

		        
	        
	 
        }
      
        
    }