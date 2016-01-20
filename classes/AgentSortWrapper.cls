public class AgentSortWrapper implements Comparable {
	
	public Agent__c agent; 
	private String statName; 

	public AgentSortWrapper(Agent__c agent, String statName) {
		this.agent = agent; 
		this.statName = statName;
	}

	public Integer compareTo(Object compareTo) {
		AgentSortWrapper compareToAgent = (AgentSortWrapper) compareTo; 

		Integer returnValue = 0; 



		if (statName.equalsIgnoreCase('Call_Over_7_Minutes_Percent__c')) {
			if (agent.Call_Over_7_Minutes_Percent__c > compareToAgent.agent.Call_Over_7_Minutes_Percent__c) {
				returnValue = 1; 
			} else if (agent.Call_Over_7_Minutes_Percent__c < compareToAgent.agent.Call_Over_7_Minutes_Percent__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Communication_with_Sup__c')) {
			if (agent.Communication_with_Sup__c > compareToAgent.agent.Communication_with_Sup__c) {
				returnValue = 1; 
			} else if (agent.Communication_with_Sup__c < compareToAgent.agent.Communication_with_Sup__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Contacts_Per_Day__c')) {
			if (agent.Contacts_Per_Day__c > compareToAgent.agent.Contacts_Per_Day__c) {
				returnValue = 1; 
			} else if (agent.Contacts_Per_Day__c < compareToAgent.agent.Contacts_Per_Day__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Average_Call_Handle_Time__c')) {
			if (agent.Average_Call_Handle_Time__c > compareToAgent.agent.Average_Call_Handle_Time__c) {
				returnValue = 1; 
			} else if (agent.Average_Call_Handle_Time__c < compareToAgent.agent.Average_Call_Handle_Time__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Dependability__c')) {
			if (agent.Dependability__c > compareToAgent.agent.Dependability__c) {
				returnValue = 1; 
			} else if (agent.Dependability__c < compareToAgent.agent.Dependability__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Follow_up_time_percent__c')) {
			if (agent.Follow_up_time_percent__c > compareToAgent.agent.Follow_up_time_percent__c) {
				returnValue = 1; 
			} else if (agent.Follow_up_time_percent__c < compareToAgent.agent.Follow_up_time_percent__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Hold_Time_Percent__c')) {
			if (agent.Hold_Time_Percent__c > compareToAgent.agent.Hold_Time_Percent__c) {
				returnValue = 1; 
			} else if (agent.Hold_Time_Percent__c < compareToAgent.agent.Hold_Time_Percent__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Quality_Score_BPA__c')) {
			if (agent.Quality_Score_BPA__c > compareToAgent.agent.Quality_Score_BPA__c) {
				returnValue = 1; 
			} else if (agent.Quality_Score_BPA__c < compareToAgent.agent.Quality_Score_BPA__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Quality_Error_Rate__c')) {
			if (agent.Quality_Error_Rate__c > compareToAgent.agent.Quality_Error_Rate__c) {
				returnValue = 1; 
			} else if (agent.Quality_Error_Rate__c < compareToAgent.agent.Quality_Error_Rate__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Schedule_Adherence_Percent__c')) {
			if (agent.Schedule_Adherence_Percent__c > compareToAgent.agent.Schedule_Adherence_Percent__c) {
				returnValue = 1; 
			} else if (agent.Schedule_Adherence_Percent__c < compareToAgent.agent.Schedule_Adherence_Percent__c) {
				returnValue = -1; 
			}
		} else if (statName.equalsIgnoreCase('Teamwork__c')) {
			if (agent.Teamwork__c > compareToAgent.agent.Teamwork__c) {
				returnValue = 1; 
			} else if (agent.Teamwork__c < compareToAgent.agent.Teamwork__c) {
				returnValue = -1; 
			}
		} else {
			if (agent.Name__c > compareToAgent.agent.Name__c) {
				returnValue = 1; 
			} else if (agent.Name__c < compareToAgent.agent.Name__c) {
				returnValue = -1; 
			}
		}


		return returnValue; 
	}

}