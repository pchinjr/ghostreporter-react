/*
 * System.schedule('Unique Schedule Name4', '0 58 13 * * ?', new  CaseOwnerReset());
 
 
 */

global class CaseOwnerReset implements Schedulable {
	global void execute(SchedulableContext sc) {
		user_logout();
	}


	public void user_logout(){
	Integer num;
	  

	List<User> una = new List <User>();
	
	 una =  [select id, name, available__c, profile.name from user where profile.name = 'CRT Member'];
	
	

	     	for (User iter : una) {
					iter.available__c = false; 
					      	
	       }
	       update una;
	
	}
}