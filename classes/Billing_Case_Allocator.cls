global class Billing_Case_Allocator {
	
	public Billing_Case_Allocator() {
		reshuffleCases();
	}
	
	global void execute(SchedulableContext sc) {
		reshufflecases();
	}
	
	@future
	public static void reshuffleCases() {
  	
		List<Billing_Case__c> una = new List <Billing_Case__c>();
		
	  	try {
		    una =  [SELECT Id, OwnerId FROM Billing_Case__c
		                   where Worked__c  = false
		                   order by Date_From__c desc];
	  	} catch(QueryException e) {
	  		// no unassigned cases left!
	  		System.debug('Problem finding cases!');
	  	}
	  	
	  	List<User> user1 = new List<User>();
	  	
	  	try {
			/* for UAT, use the  lastlogindate in the where clause:  lastlogindate = today */
			user1 = [select id, lastlogindate, profile.name, name, available__c from user
								where profile.name = 'CRT Member' and available__c = true];
	  	} catch(QueryException e) {
	  		// no available agents
	  		System.debug('Problem finding users');
	  	} 
		
		if (user1.size() > 0) {
			/* Use the number of logged in users as a modulo
			 * to evenly distribute the unassigned cases
			 */
			for (Integer i = 0; i < una.Size(); i++) {
				System.debug('Case '+i+' Assigned to '+user1.get(math.mod(i, user1.size())).Name);
				una.get(i).OwnerId = user1.get(math.mod(i, user1.size())).id;
			}
			update una; 
		}
	}
}