/** 
* Controller for Team Management page. 
* <p>
* Performs all actions necessary for 
* <ul>
* <li> Adding a new agent
* <li> Changing an agent's team 
* <li> deactivating an agent
* <li> editing an agent's name	
* </ul>
* 
* @author Mike McGee 
*/
public class TeamManagementController {

	/** sf_uniqueId for selected agent */ 
	public String selectedAgentName{get;set;}

	/** team that was selected */
	public String selectedTeam{get;set;}

	/** The currently selected agent, used in output panel */ 
	public  AgentTeam__c selectedAgent{get;set;}

	
	/**
	* Empty constructor, gets called on page load
	* @author Mike McGee 
	*/
	public TeamManagementController() {
		system.debug('constructor was called');
		Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
	}


	
	/**
	* Resets the agent select list so that it can be renendered by 
	* action function. 
	*
	* @author Mike McGee
	*/
	public void resetAgentSelectList() {
		system.debug('resetAgentSelectList was called');
		getAgentSelectList(); 
	}



	/**
	* Returns agent select list.
	* @author Mike McGee  
	* @return agent select list
	*/
	public List<SelectOption> getAgentSelectList() {
		system.debug('getAgentSelectList was called');
		List<AgentTeam__c> agentList = [SELECT sf_UniqueId__c, isActive__c, fullName__c from AgentTeam__c 
										 WHERE IsActive__c = true ORDER BY fullName__c ASC NULLS LAST]; 
		List<SelectOption> selectList = new List<SelectOption>(); 
		//Place default in list
		selectList.add(new SelectOption('Empty', 'Select Agent', true));
		for (AgentTeam__c a: agentList) {
			selectList.add(new SelectOption(a.sf_UniqueId__c, a.fullName__c));
		}

		return selectList;
	}


	
	/**
	* Returns Team select list
	* <p> 
	* Uses TeamList field on AgentTeam object to populate select list.  
	*
	* @author Mike McGee
	* @return team select list. 
	*/
	public List<SelectOption> getTeamSelectList() {
		system.debug('getTeamSelectList was called');
		List<SelectOption> selectList = new List<SelectOption>(); 
		//Get pick list values 
		Schema.DescribeFieldResult fieldResult = AgentTeam__c.TeamList__c.getDescribe(); 
		List<Schema.PickListEntry> ple = fieldResult.getPicklistValues(); 
		//place pick list values into select list. 
		selectList.add(new SelectOption('Empty', 'Select Team', true));
		for (Schema.PicklistEntry p: ple) {
			selectList.add(new SelectOption(p.getLabel(), p.getLabel()));
		}

		return selectList;
	}



	/**
	* Selects an AgentTeam object based off of select list values. 
	*
	* @author Mike McGee 
	*/
	public void setAgentTeam() {
		system.debug('setAgentTeam was called');
		//Avoid selecting agent if name is null
		if (selectedAgentName == null) {
			return; 
		} 

		selectedAgent = [SELECT fullName__c, PSERMID__c, Team__c, isActive__c from AgentTeam__c WHERE 
							sf_UniqueId__c =:selectedAgentName LIMIT 1 FOR UPDATE]; 

	}



	/**
	* Sets selectedAgent to first agent in agentList
	*/
	public void resetAgentInfo() {
		system.debug('resetAgentInfo was called');
		selectedAgent = [SELECT Id, sf_UniqueId__c, isActive__c, PSERMID__c, Team__c, fullName__c 
						FROM AgentTeam__c WHERE isActive__c = true ORDER BY fullName__c ASC NULLS LAST LIMIT 1]; 
	}



	/**
	* Selects an AgentTeam based off a passed in Id
	*
	* @author Mike McGee 
	*/
	public void setAgentTeamSpecific() {
		system.debug('setAgentTeamSpecific was called');
		String uniqueId = ApexPages.currentPage().getParameters().get('uniqueId');
		selectedAgent = [SELECT fullName__c,  PSERMID__c, Team__c, isActive__c from AgentTeam__c WHERE 
							Id =:uniqueId LIMIT 1];
		system.debug('Selected agent inside of set sepcific is : '+selectedAgent);
	}



	/**
	* Update agent onClickListener
	* <p>
	* updates selectedAgent with new team and/or isActive flag
	*
	* @author Mike McGee
	* @return the updated agents Id
	*/
	@RemoteAction
	public static String updateAgentOnClick(boolean isActive, String selectedAgentName, String selectedTeam) {
		system.debug('updateAgentOnClick was called');
		system.debug('selectedAgentName = '+selectedAgentName);
		system.debug('isActive = '+isActive);
		AgentTeam__c selectedAgent = [SELECT Id, Team__c, isActive__c from AgentTeam__c WHERE 
							sf_UniqueId__c =:selectedAgentName LIMIT 1 FOR UPDATE];
		system.debug('Selected agent is '+selectedAgent);
		selectedAgent.Team__c = selectedTeam; 
		selectedAgent.isActive__c = isActive; 
		update selectedAgent; 
		system.debug(LoggingLevel.INFO, 'selectedAgent.Id = '+selectedAgent.Id);
		return selectedAgent.Id; 
	}



	/**
	* Updates agents name as well as other fields.
	*<p>
	* overloading is not permitted for remoting methods
	*
	* @author Mike McGee
	* @return the  updated agents Id
	*/
	@RemoteAction
	public static String updateAgentWithNameOnClick( boolean isActive, String agentId, String teamName,
													String  newFirstName, String newLastName) {
		AgentTeam__c selectedAgent = [SELECT Id, Team__c, isActive__c from AgentTeam__c WHERE 
							sf_UniqueId__c =:agentId LIMIT 1 FOR UPDATE];
		system.debug('Selected agent is '+selectedAgent);
		selectedAgent.Team__c = teamName; 
		selectedAgent.isActive__c = isActive; 
		selectedAgent.put('FirstName__c', newFirstName); 
		selectedAgent.put('LastName__c', newLastName); 
		update selectedAgent; 
		system.debug(LoggingLevel.INFO, 'selectedAgent.Id = '+selectedAgent.Id);
		return selectedAgent.Id;
	}



	/**
	* Add new agent onClickListener
	* <p>
	* inserts new AgentTeam object with 
	* FirstName, LastName, Team, and isActive values 
	*
	* @author Mike McGee
	*/
	@RemoteAction
	public static String addNewAgentOnClickListener(String firstName, String lastName, Boolean isActive, 
														String selectedTeam, String psermId) {

		system.debug('addNewAgentOnClickListener was called');
		//Make sure there are values for all required fields
		if ( (firstName.length() <= 0) || (lastName.length() <= 0) ) {
			system.debug('Either no first name or last name, returnded without inserting');
			return null;
		}

		AgentTeam__c newAgent = new AgentTeam__c(); 
		newAgent.FirstName__c = firstName; 
		newAgent.LastName__c = lastName;
		newAgent.Team__c = selectedTeam; 
		newAgent.isActive__c = isActive; 
		newAgent.put('PSERMID__c', psermId); 

		insert newAgent; 
		system.debug('Agent Id = '+newAgent.Id);
		return newAgent.Id; 
	} 

}