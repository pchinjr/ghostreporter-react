trigger accountTestTrggr on Account (before insert, before update) {
	  
 Set<String> aid = new Set<String>();
 
 for(Account a: trigger.new){
     aid.add(a.id);
 }
 
   List<Contact> contacts = [select id, salutation, firstname, lastname, email 
                        from Contact where accountId in :aId];
 
   List<Contact> cup = new List<Contact>();
   //For loop to iterate through all the incoming Account records
   for(Account a: Trigger.new) {
      for(Contact c: contacts) {
         c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
 	  	 cup.add(c);                 	      
         
      }    	  
   }
   update cup;
}