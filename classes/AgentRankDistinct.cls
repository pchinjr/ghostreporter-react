/**
 * Class used for ranking Agent__c object fields. 
 * Can only rank in the dense ordering styl. 
 * 
 * @author Mike McGee
 */
public with sharing class AgentRankDistinct {
	
	/** The date to rank the agents for */	
	private Date dateToRank; 

	/** Map from name of stat to the custom setting for the stat */
	private Map<String, AgentsRankedStats__c> statsToRank = AgentsRankedStats__c.getAll();

	/**
	 * Creates ranker with specified date
	 * @param dateToRank The date to rank the agents on 
	 */
	public AgentRankDistinct(Date dateToRank) {
		this.dateToRank = dateToRank; 
	}

	/**
	 * Ranks all stats listed in custom setting AgentsRankedStats
	 * for every agent object 
	 */
	public void rankAgents() {
		
		rank(true); 
		rank(false); 

	}


	/**
	 * Ranks only email, or only non email agents based off of
	 * boolean value passed in. 
	 * @param isEmail true if ranking email agents, false otherwise. 
	 */
	public void rank(Boolean isEmail) {
		// Get list of all agent objects. 
		String allAgentsQuery = getAllAgentsString( isEmail ); 
		List<Agent__c> allAgents = Database.query(allAgentsQuery);
		// Loop through all statistics in AgentStatsRanked cs 
		// and query for values. put into temp Agent list 
		List<Agent__c> statOrderedList;
		for (AgentsRankedStats__c stat : statsToRank.values()) {

			// if currently not ranking email agents, and ranking
			// an email stat, then do not rank. Mark zero and move to next loop. 
			if (stat.Name.toLowerCase().contains('email') && !isEMail) {
				//loop through all agents setting the curent stat rank to 0
				for (Agent__c a: allAgents) {
					a.put(stat.rankName__c, 0); 
				}

				// move to next itteration in loop. 
				continue; 
			}

			system.debug('Ranking '+stat.Name);
            
			// query for stat in the order needed. 
			String queryString = getStatOrdered(stat.Name, stat.rankStyle__c, isEmail);
			statOrderedList = Database.query(queryString);

			// Put all stat values into a temp map to get distinct. 
			// This is used because it results in a dense ordering of the scores
			// Leading to a dense rank when ranking based of the users score's 
			// position. 
			Map<Double, Double> distinctSet = new Map<Double, Double>();
			for (Agent__c a: statOrderedList) {
				double sValue = Double.valueOf(a.get(stat.Name));
				distinctSet.put(sValue, sValue);
			}
            
			// Get distinct values for temp double list. Put values from map into list
			// so that the position can be determined. List will be in order because the 
			// .values() will return a list in the order in which the values were inserted. 
			// which should be the desired order due to the query
			List<Double> orderedList = distinctSet.values();

			// could order again here to be safe. 

			// Find each agents stat value in list. assign poisition in list to integer index
			for (Agent__c a: allAgents) {
				Integer rankIndex = getIndex(Double.valueOf(a.get(stat.Name)), orderedList);
				// assign index to agents associated rank value.
				if (a.get(stat.Name) == null) {
					a.put(stat.rankName__c, 0); 
				} else {
					a.put(stat.rankName__c, rankIndex + 1);
				} 
			}

			
		}

		// update all agent objects. 
		update allAgents;
	}
	
	
	/**
	 * Sets the Agent's rank fields to their percentile rank amongst the group 
	 * of agents. 
	 * @param isEmail	True if ranking email agents, false otherwise. 
	 */
	public void rankPercentile(Boolean isEmail) {
		// Get list of all agent objects. 
		String allAgentsQuery = getAllAgentsString( isEmail ); 
		List<Agent__c> allAgents = Database.query(allAgentsQuery);
		// Loop through all statistics in AgentStatsRanked cs 
		// and query for values. put into temp Agent list 
		List<Agent__c> statOrderedList;
		for (AgentsRankedStats__c stat : statsToRank.values()) {

			// if currently not ranking email agents, and ranking
			// an email stat, then do not rank. Mark zero and move to next loop. 
			if (stat.Name.toLowerCase().contains('email') && !isEMail) {
				//loop through all agents setting the curent stat rank to 0
				for (Agent__c a: allAgents) {
					a.put(stat.rankName__c, 0); 
				}

				// move to next itteration in loop. 
				continue; 
			}

			system.debug('Ranking '+stat.Name);
            
			// query for stat in the order needed. 
			String queryString = getStatOrdered(stat.Name, stat.rankStyle__c, isEmail);
			statOrderedList = Database.query(queryString);
			
			// Extract the list of scores as doubles only in desired order
			List<Double> scoreList = getScoreValueList(statOrderedList, stat.Name);
			
			// Calculate percentile rank from ordered stat list and agent score
			// for every agent in allAgents list
			for (Agent__c agent: allAgents) {
				Double agentScore = Double.valueOf(agent.get(stat.Name)); 
				if (agentScore == null) {
					agent.put(stat.rankName__c, 0);
					continue;
				} else {
					Double agentPercentRank = calcPercentileRank(agentScore, scoreList);
					agent.put(stat.rankName__c, Integer.valueOf(agentPercentRank * 100));
					system.debug(LoggingLevel.ERROR, 'Score: '+agentScore+' is ranked: '+(agentPercentRank * 100));	
				}
			}
		}
		
		update allAgents;
	}
	
	
	/**
	 * Builds a list of doubles from the agentList passed in. 
	 * @param agentList	The list to convert to a double list.
	 * @param stat		The stat to build the double list off of. 
	 * @return The list of doubles in the same order as the agentList. 
	 */
	public List<Double> getScoreValueList(List<Agent__c> agentList, String stat) {
		List<Double> doubleList = new List<Double>();
		for (Integer i = 0, j = agentList.size(); i < j; ++i) {
			Double scoreValue = Double.valueOf(agentList[i].get(stat));
			if (scoreValue == null) {
				doubleList.add(0);
			} else {
				doubleList.add(scoreValue);
			}
		}
		
		return doubleList; 
	} 
		
	
	
	/**
	 * Returns the percentile rank of a score contained in an orderd list. 
	 * <p> List is assumed to be in descending order according to the stat
	 * 	   being ranked
	 * <p>
	 * @param score		The score to be ranked. 
	 * @param scoreList	The list to rank against. 
	 * @return The percentile rank of the score 
	 */
	public Double calcPercentileRank(Double score, List<Double> scoreList) {
		Integer numWorse = getNumWorse(scoreList, score); 
		Integer numEqual = getNumEqual(scoreList, score);
		return getPercentileRank(scoreList.size(), numWorse, numEqual);
	}	
	
	
	
	/**
	 * Gets the number of scores that are equal to the score passed in. 
	 * <p> Doesn't assume list ordering </p>
	 * @param scoreList	The list of scores to check through. 
	 * @param score		The score to look for. 
	 * @return	The number of matching scores in the list. 
	 */
	public Integer getNumEqual(List<Double> scoreList, Double score) {
		Integer numEqual = 0; 
		for (Integer i = 0, j = scoreList.size(); i < j; ++i) {
			if (scoreList[i] == score) {
				numEqual++; 
			} else {
				continue;
			}
		}
		
		return numEqual; 
	}
	
	
	
	/**
	 * Gets the number of scores in the list that are worse than score passed in
	 * <p> Assumes that the list passed in is in descending order with the best 
	 *     scores at the top
	 * </p>
	 * 
	 * @param scoreList	The list that is in desc order to evaluate against
	 * @param score		The score that is being evaluated. 
	 * @return	The number of scores that are worse than the score passed in. 
	 */
	public Integer getNumWorse (List<Double> scoreList, Double score) {
		Integer numWorse = 0; 
		// Start from bottom of list and count until you hit an equal score. 
		for (Integer j = scoreList.size() - 1; j >= 0; --j) {
			// If you get to the matching score than you are done counting. 
			if (scoreList[j] == score) {
				break; 
			} else {
				numWorse++; 
			}
		}
		
		return numWorse; 
	}
	
	
	
	/**
	 * Gets the percentile rank associated with the values passed in. 
	 * @param numScores	The total number of scores that are in the set. 
	 * @param numWorse	The number of scores that are worse than the score being evaluated
	 * @param numEqual	The number of scores that are equal to the score being evaluated. 
	 * @return 	The percentile based on the values passed in. 
	 */
	public Double getPercentileRank(Integer numScores, Integer numWorse,
								  Integer numEqual) {
		
		Double numerator = (numWorse + 0.5*numEqual);
		return numerator / numScores; 
	}
	
	

	/**
	 * Gets the position of the value in the list
	 * @param value the value to search for
	 * @param valueList to list to search through
	 * @return the index of the value in the list. 
	 */
	private Integer getIndex(Double value, List<Double> valueList ) {
		for (Integer i = 0; i < valueList.size(); ++i) {
			if (valueList[i] == value) {
                //system.debug('The index for '+value +' in '+ valueList +' is ' +i);
				return i; 
			}
		}

		// value is not in list. (Should not happen)
		return null;
	}


	/**
	 * Creates string for querying for all agents in db.
	 * need to select all stats and the rank for all stats.
	 * @param isEMail ture if should select only email agents, false otherwise.  
	 */
	private String getAllAgentsString(boolean isEmail) {
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

		tempString += ' AND isEmailAgent__c = ' +isEmail;

		system.debug(tempString);

		return tempString; 
	}


	/**
	 * Creates the string used to query for the given statistic
	 * @param statName the name of the stat being queried for
	 * @param rankName the name of the rank associated with the stat
	 * @param rankStyle the style in which to order the stat (ASC | DESC)
	 */
	private String getStatOrdered(String statName, String rankStyle, Boolean isEmail) {
		String statQueryString = 'SELECT Id, '+statName + ' FROM Agent__c WHERE Date__c =:dateToRank AND isEmailAgent__c = '+ isEmail +' ORDER BY '+
				statName+ ' '+ rankStyle + ' NULLS LAST';
		return statQueryString; 
	}


}