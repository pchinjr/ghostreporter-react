public with sharing class CRT_PickList {
 	private final CRT_Ops_Dash_Cont u; //User sobject
	
	//initializes the private member variable u by using the getRecord method from the standard controller
	public CRT_PickList(CRT_Ops_Dash_Cont stdController) {
	//	this.u = stdController.getRecord();
	}
	
	//builds a picklist of user names based on their profile
	public List<selectOption> getMgrs() {
		List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
		options.add(new selectOption('', '- None -')); //add the first option of '- None -' in case the user doesn't want to select a value or in case no values are returned from query below
		for (User users : [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator']) { //query for User records with System Admin profile
			options.add(new selectOption(users.Id, users.Name)); //for all records found - add them to the picklist options
		}
		return options; //return the picklist options
	}
}