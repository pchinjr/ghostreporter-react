@isTest
	
public with sharing class EmailMessage_Test {
 static testMethod void EmailMessage_Test() {
    	
        User crtmember = [select id from user where name = 'Alex Rivera'];
        
        System.runAs(crtmember) {
	        
	        List<Case> cases = new List<Case>();
	        
	        for (Integer i = 0; i < 10; i++) {
	        	Case newCase = new Case();
	        	newCase.Status = 'Unassigned';
	        	newCase.Description = 'nulls are bad';
	        	newCase.OwnerId = crtmember.Id;
	        	cases.add(newCase);
	        }
	          
	        System.test.startTest();
	        
	        insert cases;
	        
	        User testUser = [select Id from User where Name = 'Ruben Ortiz' limit 1];
	        
	        cases = [select Id from Case];
	        
	        for (Case i : cases) 
	        	i.OwnerId = testUser.Id;
	        		        
	        update cases;
	        
	        System.test.stopTest();
        }
        
    }
       static testMethod void Case_Shuffle_EmailTest() {
       	  User crtmember = [select Id from User where Profile.Name = 'CRT Member' limit 1];
        
       System.runAs(crtmember) {
	        
	        List<Case> cases = new List<Case>();
	        
	        	Case newCase = new Case();
	        	newCase.Origin = 'Email';
	        	newCase.Status = 'Unassigned';
	        	newCase.Account_id__c = '123456789';
	        	newCase.Description = 'nono ';
	      
	        	newCase.Priority = 'High';
	        	cases.add(newCase);
	            insert cases;
	            
	          
 
	    
			    EmailMessage em = new EmailMessage();
			    em.FromAddress = 'test@example.com';
			    em.Incoming = true;
			    em.ToAddress = 'rortiz@r-tybxa3k94zzjkxpnpq4kmh8fydu47xntb1q1dphmo66k0nlv5.e-5ofbmeaw.cs15.case.sandbox.salesforce.com';
			    em.Subject = 'Test email';
			    em.TextBody = 'Hello';
			    em.ParentId = newCase.Id; // The inserted test Case Id that you created above
			
			    System.Test.startTest();
			    insert em;
			    System.Test.stopTest();
	 
	        		        
	   
	        
	      
       	
       	
       }
       }
}