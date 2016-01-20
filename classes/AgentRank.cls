/**
 * Helper class used to rank Agent__c objects statistics
 * This class used the custom setting AgentsRankedStats to get the 
 * Stats to be ranked, their name, the name of their associated 
 * rank field, and the style in which to rank that stat. 
 *
 * There are two ranking styles, Ascending and Descending. 
 * Ascending is used when a lower stat value is better and 
 * Descending is used when a higher stat value is better. 
 *
 * This classes uses the Rank class in order to perform the
 * ranking of the statistics and to update the rank fields in 
 * the Agent__c object. 
 *
 * @author Mike McGee 
 */
public with sharing class AgentRank {
	
	/** Map from name of stat to the custom setting for the stat */
	private Map<String, AgentsRankedStats__c> statsToRank = AgentsRankedStats__c.getAll();

	/** The list of agents to be ranked */
	List<Agent__c> agentList; 

	/** 
	 * Creates a ranker for the given Date 
	 * Also queries for the list of agents to rank where the Date__c
	 * field is the passed in date 
	 *
	 * @param dateToRank 	The Date to rate the objects for
	 */
	public AgentRank(Date dateToRank) {
		String queryString = makeQueryString(); 
		agentList = Database.query(queryString); 		
	}


	/** 
	 * Ranks all stats in the custom setting 
	 * according to the dense ranking style. 
	 * i.e (1, 1, 1, 2)
	 */
	public void denseRank() {
		for (AgentsRankedStats__c s: statsToRank.values()) {
			Rank tempRank = new Rank(s.Name, s.rankName__c, this.agentList, s.rankStyle__c);
			tempRank.rank('dense');
		}
	}

	/** 
	 * Ranks all stats in the custom setting 
	 * according to the competition ranking style. 
	 * i.e (1, 1, 1, 4)
	 */
	public void competitionRank() {
		for (AgentsRankedStats__c s: statsToRank.values()) {
			Rank tempRank = new Rank(s.Name, s.rankName__c, this.agentList, s.rankStyle__c);
			tempRank.rank('competition');
		}
	}	

	/**
	 * Makes string to be used in query for agent objects. 
	 * Creates the string based off of the stas in the 
	 * AgentRankedStats custom setting
	 *
	 * @return the string used for the Agent query. 
	 */
	private String makeQueryString() {
		// Start query string with SELECT
		String tempString = 'SELECT Id, ';
		// Get a list of the stats to be queried
		List<AgentsRankedStats__c> statList = statsToRank.values();  
		for (Integer i = 0; i < statList.size(); ++i) {
			// If at the end of the list don't put a comma 
			if (i == statList.size() -1 ) {
				tempString += statList[i].Name + ',' + statList[i].rankName__c;
			} else {
				tempString += statList[i].Name + ',' + statList[i].rankName__c + ',';
			}	
		}

		// finish string
		tempString += ' FROM Agent__c WHERE Date__c = :dateToRank';

		system.debug(tempString);

		return tempString; 
	}

}