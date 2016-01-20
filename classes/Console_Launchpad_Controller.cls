/** Console_Launchpad_Controller is used by the Launchpad page designed for the console.
  *	It contains global variables and methods required to
  * provide functionality to the launchpad. 
  * @author: Matthew Bald
  */
global with sharing class Console_Launchpad_Controller {
	
    public String JSONString {get; set;}
    public String JSONString_Activities {get; set;}
    public String JSONString_CaseChart {get; set;}
    
	public String userName {get; set;}

    public Integer in_PC {get; set;}
    public Integer unaC {get; set;}
    public Integer promoC {get; set;}
    
    public Boolean userUpdatedStatus {get; set;}
    public Boolean userStatus {get; set;}
    
    public static Case_Allocator shuffler {get; set;}
    
    /** Constructor for the Launchpad_Controller. Populates the class'
	  * variables that provide information for the CRT user.
	  * @author: Matthew Bald
	  */
	public Console_Launchpad_Controller() {
		
		userName = UserInfo.getUserID();
		
		userStatus = [select Id, available__c from User where Id = :userName].available__c;

        retrieveData();
		constructCaseChartJSON_Inverted();
	}
	
	public void checkUserIn() {

		User currentUser = [select Id, available__c from User where Id = :userName];
		currentUser.available__c = true;
		userStatus = true;
		update currentUser;
		
		// Run case shuffler
		shuffler = new Case_Allocator(); 

		retrieveData(); // refresh the JSON string
	}
	
	public void checkUserOut() {

		User currentUser = [select Id, available__c from User where Id = :userName];
		currentUser.available__c = false;
		userStatus = false;
		update currentUser;
		
		// Run case shuffler
		shuffler = new Case_Allocator(); 

		retrieveData(); // refresh the JSON string
	}
	
	@RemoteAction
	global static Boolean getUserStatus() {
		return [select available__c, Id from User where Id = :UserInfo.getUserId()].available__c;
	}
	
	/** findNextCaseUnassigned returns a PageReference for a VisualForce commandButton.
	  * The PageReference will redirect the User clicking the button to the Case detail 
	  * page for the case returned by getNextUnassigned().
	  * @params: none
	  * @returns: PageReference
	  * @author: Matthew Bald
	  */
	@RemoteAction
    global static Case findNextCaseUnassigned() {

    	Case nextCase = getNextUnassigned();
    	
    	if (nextCase == null) return null;
		if (nextCase.Id == null) return null;
		
		return nextCase;
    }
    
    /** getNextUnassigned returns the next highest priority Case that is not closed
      * and is not yet owned by a User.
      * @params: none
      * @returns: Case object
      * @author: Matthew Bald
      */
    @RemoteAction
    global static Case getNextUnassigned() {
    	Case nextCase = null;
    	
    	try { 
    		nextCase = [select Id, OwnerId, Status, CaseNumber from Case where isClosed = false and Status = 'Unassigned'
    																				and OwnerId = :UserInfo.getUserId()
    																				//and OwnerId not in :[select Id from User]
    																		 		order by Priority, CRDate__c limit 1 ];
    		
    		//nextCase.OwnerId = userName; // assign the case to the user
    		nextCase.Status = 'In Progress';
			nextCase.CRT_Review_DT__c = DateTime.now();
    		update nextCase;
    	} catch (Queryexception e) {
    		// found no cases
    	}    	
    	return nextCase;
    }	
	
	/** retrieveData refreshes the JSONString global field. It queries the database for case data
	 *  and constructs a JSON object using the JSON Generator class
	 *  @params: none
	 *  @returns: none
	 *  @author: Matthew Bald
	 */
	public void retrieveData() {	
	
		Case_JSON_Generator caseGenerator = new Case_JSON_Generator();
		
		JSONString = caseGenerator.gen_JSON();
		
	}
	
	/** retrieveActivitiesData refreshes the JSONString_Activities global field.
	 *	It queries the database for case data and constructs a JSON object using
	 *  the JSON Generator class
	 *  @params: none
	 *  @returns: none
	 *  @author: Matthew Bald
	 */
	public void retrieveActivitiesData() {
		
		Activities_JSON_Generator activityGenerator = new Activities_JSON_Generator();
		
		JSONString_Activities = activityGenerator.retrieveActivitiesData();
	}
	
	public void constructCaseChartJSON_Inverted() {
		
		Dash_JSON_Generator dash = new Dash_JSON_Generator();
		
		JSONString_CaseChart = dash.gen_Dash_JSON_Pivoted();
		
		in_PC = dash.get_Progress_Count();
		unaC = dash.get_Unassigned_Count(); 
		promoC = dash.get_Promoted_Count(); 
		
	}
}