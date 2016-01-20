public class AgentRanker {

	private Agent__c currentAgent; 
	private Map<String, Agent__C> updateList;
	private static Date currentDate; 
	private static List<Agent__c> agentRankList; 
	
	//Ordered lists
	private static List<Agent__c> achtlist; 
	private static List<Agent__C> cpdList; 
	private static List<Agent__c> htList; 
	private static List<Agent__c> co7mList; 
	private static List<Agent__c> qbpaList; 
	private static List<Agent__c> qerrList; 
	private static List<Agent__c> futList; 
	private static List<Agent__c> saList; 
	private static List<Agent__c> commList;
	private static List<Agent__c> twList; 
	private static List<Agent__c> depList; 
	private static List<Agent__c> epdList; 
	private static List<Agent__c> ehtList; 
	private static List<Agent__c> otList; 
	private static boolean isRecursive = false; 

	
	
	public AgentRanker() {
	    setCurrentDate(); 
	    setAgentList();
		setACHTList(); 
		setCPDList(); 
		setHTList(); 
		setCO7MList();
		setQBPAList(); 
		setQERRList(); 
		setFUTList();
		setSAList(); 
		setCOMMList();
		setTWList();
		setDEPList();
		setEHTList();
		setEPDList(); 
		setOTList();
	}
	
	public AgentRanker(Date updateDate) {
	    currentDate = updateDate;  
	    system.debug('Ranking dates for '+updateDate); 
	    setAgentList(); 
		setACHTList(); 
		setCPDList(); 
		setHTList(); 
		setCO7MList();
		setQBPAList(); 
		setQERRList(); 
		setFUTList();
		setSAList(); 
		setCOMMList();
		setTWList();
		setDEPList(); 
		setEHTList(); 
		setOTList(); 
	}


	/**
	* Sets static boolean isRecursive
	* @param boolean isRecursive
	*/
	public void setIsRecursive(boolean isRec) {
		AgentRanker.isRecursive = isRec; 
	}
	
	
	/**
	 * Moves index back until the stat value at that position in the list is 
	 * no longer equal to the value at the position before it in the lis. 
	 *
	 * @author Mike McGee 
	 * @param   index   the current index of the list. 
	 * @param   agentList   the ordered list of agents. 
	 * @param   statName    the name of the stat being evaluated
	 */
	public Integer moveBack2(Integer index, List<Agent__c> agentList, String statName) {
	    if (index == 0) return 0; 
	    Integer toMove = 0; 
	    while ( (index != 0) && (Integer.valueOf(agentList[index].get(statName)) == Integer.valueOf(agentList[index - 1].get(statName))) ) {
	         index--; 
	         toMove++; 
	    }
	    
	    return toMove; 
	} 
	
	/**
	 * Ranks agent by the competition ranking style. (i.e: 1, 1, 1, 4)
	 * 
	 * @author Mike McGee 
	 * 
	 */
	public void competitionRank() {
	    //Don't execute if it is second time throufh update. 
	    if (isRecursive) {
	        return; 
	    } else {
	        isRecursive = true;
	    }
	    
	    fillUpdateMap(); 
	    
	    //Temp agent to avoid GC events. 
        Agent__c tempAgent;
	    
	    //Rank each list
        competRank(tempAgent, achtList, 'ACHT_Rank__c', 'Average_Call_Handle_Time__c'); 
        competRank(tempAgent, co7mList, 'CO7M_Rank__c', 'Call_Over_7_Minutes_Percent__c'); 
        competRank(tempAgent, commList, 'COMM_Rank__c', 'Communication_with_Sup__c'); 
        competRank(tempAgent, depList, 'DEP_Rank__c', 'Dependability__c'); 
        competRank(tempAgent, cpdList, 'CPD_Rank__c', 'Contacts_Per_Day__c'); 
        competRank(tempAgent, futList, 'FUT_Rank__c','Follow_up_time_percent__c'); 
        competRank(tempAgent, htList, 'HTP_Rank__c','Hold_Time_Percent__c'); 
        competRank(tempAgent, qbpaList, 'QBPA_Rank__c', 'Quality_Score_BPA__c'); 
        competRank(tempAgent, qerrList,'QERR_Rank__c', 'Quality_Error_Rate__c'); 
        competRank(tempAgent, saList, 'SA_Rank__c', 'Schedule_Adherence_Percent__c'); 
        competRank(tempAgent, twList, 'TW_Rank__c', 'Teamwork__c'); 
        
        //Update agentList
        update updateList.values();
	}
	
	/**
	 * Computes ranking for the passed in statName for each agent and updates 
	 * the agent in the update map. 
	 * 
	 * @author Mike McGee 
	 * @param   tempAgent   holder agent object for agents to be ranked.  
	 * @param   agentList   list of agents sorted by the current stat being ranked
	 * @param   rankName    the name of the rank field corresponding to the stat
	 * @param   statName    the name of the stat field being ranked.
	 */
	public void competRank(Agent__c tempAgent, List<Agent__c> agentList, String rankName, String statName) {
	    for (integer i = 0; i < agentList.size(); ++i) {
            tempAgent = updateList.get(agentList[i].Agent_Id__c);
            integer rank = (i + 1) - moveBack2(i, agentList, statName);
            tempAgent.put(rankName, rank); 
            updateList.put(agentList[i].Agent_Id__c, tempAgent); 
        }
	}

    
    
    /**
     * Fills map with agents to be updated. 
     */
    public void fillUpdateMap() {
        updateList = new Map<String, Agent__c>(); 
        for (Agent__c a : agentRankList) {
            updateList.put(a.Agent_Id__c, a); 
        }
    } 
    
    /**
     * Ranks agents according to the dense ranking style (i.e: 1, 1, 1, 2)
     * 
     * @author Mike McGee 
     */
    public void denseRank() {
       //Don't execute if it is second time through update. 
        if (isRecursive) {
            return; 
        } else {
            isRecursive = true; 
        }
        //populate agent Map (Called updateList for some reason) 
        fillUpdateMap(); 
        //Temp agent to avoid GC events. 
        Agent__c tempAgent;
        //Rank each list
        consecRank(tempAgent, achtList, 'ACHT_Rank__c', 'Average_Call_Handle_Time__c'); 
        consecRank(tempAgent, co7mList, 'CO7M_Rank__c', 'Call_Over_7_Minutes_Percent__c'); 
        consecRank(tempAgent, commList, 'COMM_Rank__c', 'Communication_with_Sup__c'); 
        consecRank(tempAgent, depList, 'DEP_Rank__c', 'Dependability__c'); 
        consecRank(tempAgent, cpdList, 'CPD_Rank__c', 'Contacts_Per_Day__c'); 
        consecRank(tempAgent, futList, 'FUT_Rank__c','Follow_up_time_percent__c'); 
        consecRank(tempAgent, htList, 'HTP_Rank__c','Hold_Time_Percent__c'); 
        consecRank(tempAgent, qbpaList, 'QBPA_Rank__c', 'Quality_Score_BPA__c'); 
        consecRank(tempAgent, qerrList,'QERR_Rank__c', 'Quality_Error_Rate__c'); 
        consecRank(tempAgent, saList, 'SA_Rank__c', 'Schedule_Adherence_Percent__c'); 
        consecRank(tempAgent, twList, 'TW_Rank__c', 'Teamwork__c'); 
        consecRank(tempAgent, ehtList, 'EHT_Rank__c', 'Email_Handle_Time__c'); 
        consecRank(tempAgent, otList, 'OT_Rank__c', 'Other_Time__c'); 
        
        //Update agentList
        update updateList.values(); 
        
        
    } 
    
    
    /**
     * Computes ranking of the stat that is passed in for each agent in the list 
     * according to the dense ordering style. Then updates the agent in the 
     * updateList map. 
     * 
     * @author  Mike McGee 
     * @param   tempAgent   the holder agent for the agents in the list. 
     * @param   agentList   the agent list ordered by the stat to be ranked. 
     * @param   rankName    the name of the rank field corresponding to the stat
     * @param   statName    the name of the stat being ranked. 
     * 
     */
    public void consecRank(Agent__c tempAgent, List<Agent__c> agentList, String rankName, String statName) {
        for (integer i = 0; i < agentList.size(); ++i) {
            //Set holder agent. 
            tempAgent = updateList.get(agentList[i].Agent_Id__c); 
            
            //move indexed rank back so that it is the same as the
            //index of the agents with the same score. 
            integer indexedRank = i - moveBack2(i, agentList, statName);
            
            //if the indexedRank is already at 0 then the agent should 
            //be ranked 1, Otherwise check what the agent in the position 
            //before the indexedRank is ranked and assign the current agent the 
            //next rank.
            if (indexedRank != 0) {
                Agent__c aboveAgent = updateList.get(agentList[i-1].Agent_Id__c); 
                Integer rank = (Integer.valueOf(aboveAgent.get(rankName))) + 1;
                tempAgent.put(rankName, rank); 
                //tempAgent.ACHT_Rank__c = (updateList.get(achtlist[i-1].Agent_Id__c).ACHT_Rank__c) + 1; 
            } else {
                tempAgent.put(rankName, indexedRank + 1); 
                //tempAgent.ACHT_Rank__c = indexedRank + 1; 
            }
            
            //Put the tempAgent (now with his new ranking) back into the map.
            updateList.put(agentList[i].Agent_Id__c, tempAgent); 
        }
    } 
    


	/*public Integer rank( String statName, String sortStyle) {
		//Need to chack if agentList is empty before attempting to access
		if (agentList.isEmpty()) return 0; 

		//Sort list with wrapper
		List<AgentSortWrapper> wrapperList = new List<AgentSortWrapper>();
		for (Agent__c a: agentList) {
			wrapperList.add(new AgentSortWrapper(a, statName));
		}

		wrapperList.sort(); 

		if (sortStyle.equalsIgnoreCase('asc')) {
			Integer i = 0; 
			// While the name of the current agent being evaluated is not the same as the name of the agent in
			// wrapper list itterate forward. 
			while ( !(currentAgent.Name__c.equalsIgnoreCase(wrapperList.get(i).agent.Name__c)) ) {
				i++;
			}

			return (i + 1); 

		} else {
			Integer i = wrapperList.size() - 1; 
			// While the name of the current agent being evaluated is not the same as the name of the agent in
			// wrapper list itterate backwards. 
			while ( !(currentAgent.Name__c.equalsIgnoreCase(wrapperList.get(i).agent.Name__c)) ) {
				i--; 
			}

			return (wrapperList.size() - i); 
		}

	} */
	
	/**
	 * sets the current date field to the first day of the previuos month, 
	 * only runs if no current date was passed in. 
	 */
	public void setCurrentDate() {
	    if (currentDate == null) {
	        Date todayDate = Date.today();
	        currentDate = Date.newInstance(todayDate.year(), todayDate.addMonths(-1).month(), 1);
	    }
	}

    /**
     * Builds the agentRankList so that it may be updated after the rankings 
     * are computed. 
     */
	private void setagentList() {
		if (agentRankList == null) {
			agentRankList = [SELECT Agent_Id__c, ACHT_Rank__c, CPD_Rank__c, HTP_Rank__c, 
			            CO7M_Rank__c, QBPA_Rank__c, QERR_Rank__c, FUT_Rank__c, 
			            SA_Rank__c, COMM_Rank__c, TW_Rank__c, DEP_Rank__c
			            FROM Agent__C WHERE Date__c = :currentDate]; 
		}
	} 
	
	/*************************************************************************
	 * All individual stat lists are ordered according to whether it needs an 
	 * ascending ranking or a descending ranking
	 *************************************************************************/
	
	private void setACHTList() {
	    if (achtList == null) {
	        achtList = [SELECT Agent_Id__c, Average_Call_Handle_Time__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Average_Call_Handle_Time__c ASC NULLS LAST];
	    }
	}
	
	private void setCPDList() {
	    if (cpdList == null) {
	        cpdList = [SELECT Agent_Id__c, Contacts_Per_Day__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Contacts_Per_Day__c DESC NULLS LAST];
	    }
	}
	
	private void setOTList() {
	    if (otList == null) {
	        otList = [SELECT Agent_Id__c, Other_Time__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Other_Time__c ASC NULLS LAST];
	    }
	}
	
	private void setEHTList() {
	    if (ehtList == null) {
	        ehtList = [SELECT Agent_Id__c, Email_Handle_Time__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Email_Handle_Time__c ASC NULLS LAST];
	    }
	}
	
	private void setHTList() {
	    if (htList == null) {
	        htList = [SELECT Agent_Id__c, Hold_Time_Percent__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Hold_Time_Percent__c ASC NULLS LAST];
	    }
	}
	
	private void setEPDList() {
	    if (epdList == null) {
	        epdList = [SELECT Agent_Id__c, Emails_Per_Day__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Emails_Per_Day__c DESC NULLS LAST];
	    }
	}
	
	private void setCO7MList() {
	    if (co7mList == null) {
	        co7mList = [SELECT Agent_Id__c, Call_Over_7_Minutes_Percent__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Call_Over_7_Minutes_Percent__c asc NULLS LAST];
	    }
	}
	
	private void setQBPAList() {
	    if (qbpaList == null) {
	        qbpaList = [SELECT Agent_Id__c, Quality_Score_BPA__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Quality_Score_BPA__c DESC NULLS LAST];
	    }
	}
	
	private void setQERRList() {
	    if (qerrList == null) {
	        qerrList = [SELECT Agent_Id__c, Quality_Error_Rate__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Quality_Error_Rate__c asc NULLS LAST];
	    }
	}
	
	private void setFUTList() {
	    if (futList == null) {
	        futList = [SELECT Agent_Id__c, Follow_up_time_percent__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Follow_up_time_percent__c asc NULLS LAST];
	    }
	}
	
	private void setSAList() {
	    if (saList == null) {
	        saList = [SELECT Agent_Id__c, Schedule_Adherence_Percent__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Schedule_Adherence_Percent__c DESC NULLS LAST];
	    }
	}
	
	private void setCOMMList() {
	    if (commList == null) {
	        commList = [SELECT Agent_Id__c, Communication_with_Sup__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Communication_with_Sup__c DESC NULLS LAST];
	    }
	}
	
	private void setTWList() {
	    if (twList == null) {
	        twList = [SELECT Agent_Id__c, Teamwork__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Teamwork__c DESC NULLS LAST];
	    }
	}
	
	private void setDEPList() {
	    if (depList == null) {
	        depList = [SELECT Agent_Id__c, Dependability__c FROM Agent__c WHERE Date__c = :currentDate ORDER BY Dependability__c DESC NULLS LAST];
	    }
	}
}