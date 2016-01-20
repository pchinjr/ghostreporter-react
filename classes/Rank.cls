/**
 * Class representing the rankings of the given statistscs. 
 * Used to calculate rankings for any statistic that is passed in. 
 * 
 * @author Mike McGee
 */
public with sharing class Rank {
    
    /** The name of the stat being ranked */
    private String statName; 
    /** The name of the rank field on the agent object */
    private String rankName; 
    /** The list of objects to be ranked. */
    private List<sObject> objectList;
    /** The style that the stat should be ranked in */
    private String rankStyle; 

    /**
     * Creates an AgentRank object
     * @param   statName    The name of the stat being ranked
     * @param   rankName    The name of the field that holds the rank on the agent object
     * @param   agentList   The list of objects being ranked
     */
    public Rank(String statName, String rankName, List<Object> objectList, String rankStyle) {
        this.statName = statName; 
        this.rankName = rankName; 
        this.rankStyle = rankStyle;
        this.objectList = new List<sObject>();

        //Cast Objects to sObjects so that get and put cab be used. 
        for (Object o: objectList) {
            this.objectList.add((sObject)o);
        }
    }


    /**
     * Sets the rankStyle
     * @param rankSyle
     */
    public void setRankStyle(String rankSyle) {
        this.rankStyle = rankSyle;
    }


    /**
     * Ranks the list of agent object. Setting the 
     * appropriate rank fields on the agent object  
     */
    public void rank(String rankingMethod) {
        //Sort the agent list by statName and with rankStyle
        List<sObject> rankedList;

        if (rankStyle.equalsIgnoreCase('ASC')) {
            rankedList = Sorter.sortAsc(objectList, statName);
        } else if (rankStyle.equalsIgnoreCase('DESC')) {
            rankedList = Sorter.sortDsc(objectList, statName);
        } else if (rankStyle.equalsIgnoreCase('ALPA')) {
            rankedList = Sorter.sortAlpha(objectList, statName);
        } else {
            system.debug(LoggingLevel.ERROR, 'rankStyle must be ASC|DESC|ALPHA');
            return; 
        }

        //set each agents rank accoriding to there order in the list
        setRanks(rankedList, rankingMethod);

    }


    /**
     * Sets the rankName stat according to the agents position in rankedList
     *
     * @param rankedList    sObject list orders by statName
     */
     private void setRanks(List<sObject> rankedList, String rankingMethod) {
        Map<Id, sObject> objectMap = new Map<Id, sObject>(this.objectList); 
        for (Integer i = 0; i < rankedList.size(); ++i) {
            // Get the id associated with sObject
            String oId = String.valueOf(rankedList[i].get('Id')); 
            // Find the matching agent object 
            sObject curObject = objectMap.get(oId);
            //Make sure curAgent is not null (Should never happen)
            if (curObject != null) {
                Integer rank;
                if (rankingMethod.equalsIgnoreCase('competition')) {
                    // set rank in the competition style (1, 1, 1, 4)
                    rank = competitionRank(i, rankedList);
                } else if (rankingMethod.equalsIgnoreCase('dense')) {
                    // set rank in the dense style (1, 1, 1, 2)
                    rank = denseRank(i, rankedList); 
                }
                curObject.put(rankName, rank);
                objectMap.put(curObject.Id, curObject);
            }
        }
         
        //update sObject list 
        update objectMap.values(); 
     }


     /**
      * Decides the competition rank based off of position
      * @param the index of the object in the objectList
      * @return the rank
      */
     private Integer competitionRank(Integer index, List<sObject> objectList) {
        // If at the front of the list then return 1 becuase they are ranked 1st
        if (index == 0) {
            return 1;
        } else {
            // While you are not at the front of the list and the object has the same score as the object ahead of it in the list
            // move towards the front of the sorted list. 
            while (index > 0 && (Double.valueOf(objectList[index].get(statName)) == Double.valueOf(objectList[index - 1].get(statName)))) {
                index--;
            }
            return index + 1; 
        }
    }


    /**
     * Decides the dense rank based off of posiiton
     * @param the positon of the object in the objectList
     * @return the rank
     */
     private Integer denseRank(Integer index, List<sObject> sList) {
        if (index == 0) {
            return 1;
        } else {
            // While you are not at the front of the list and the object has the same score as the object ahead of it in the list
            // move towards the front of the sorted list.
            while (index > 0 && (Double.valueOf(sList[index].get(statName)) == Double.valueOf(sList[index - 1].get(statName)))) {
                index--;
            }
            // Could have goten all the way to the front of the list here, so need to 
            // check again
            if (index == 0)  {
                return 1; 
            } else {
                // If not at the front of the list, then the object is ranked 1 + 
                // whatever the object ahead of it is ranked, this is the dense
                // ranking style. 
                return Integer.valueOf(sList[index - 1].get(rankName)) + 1; 
            }
        }
     }
}