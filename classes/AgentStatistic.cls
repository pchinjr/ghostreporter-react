/**
 * Class used for the scoring of agent statistics.
 * @author Mike McGee 
 */
public class AgentStatistic {
    
    //Custom settings map for agent scoring 
    private static Map<String, AgentStatsScoringLevel__c> scoreSettingMap = AgentStatsScoringLevel__c.getAll(); 
    private static Map<String, AgentStatsScoringLevels_EmailAndCalls__c> emailScoreSettingsMap =
    								AgentStatsScoringLevels_EmailAndCalls__c.getAll(); 



    /**
     * Scores the statiistics for all Agent objetcs 
     * <p> Uses one select statment 
     * <p> Performs one DML update. 
     * <p> This method requires strict naming conventions to work
     * properly. All Point field in the agent object must follow the
     * style "Pts_["APINAME"] where APINAME is the name of the field for
     * which you want to calculate points. (i.e Contacts_Per_Day__c --> Pts_Contacts_Per_Day__c)
     */
    public static void scoreAllAgents() {
        // Get Query string for agents. 
        String agentQuery = buildQuery(); 

        // Get list of agents
        List<Agent__c> agents = Database.query(agentQuery); 
        List<Agent__c> toUpdate = new List<Agent__c>(); 


        // Loop through ever agent scoring every field
        for (Agent__c a: agents) {
            // score each agent. 
            a = scoreAgent(a); 

            // Place agent in update list 
            toUpdate.add(a); 
        } 
        
        // Update list of agents. 
        update toUpdate; 
    } 



    /**
     * Scores every statistic that has an associated points stat
     * for the passed in agent.
     * <p> Does not perform a DML update, this will need to be done
     * by the caller in order for the changes to take effect. 
     *
     * @param a The agent to calculate scores for
     * @return the same agent with updated point fields. 
     */
    public static Agent__c scoreAgent(Agent__c a) {

        // Get list of all point fields 
        // (in order to use this method must enforce strict naming conventions)
        SObjectType agentType = Schema.getGlobalDescribe().get('Agent__c');
        Map<String, Schema.SObjectField> agentFields = agentType.getDescribe().fields.getMap();

        // Loop through all fields.
        for (String statName: agentFields.keySet()) {
            if (statName.startsWithIgnoreCase('pts_')) {
                /* Puts the result of scoring the field related to the points field,
                   which is obtained by removing the 'Points_c' prefix, into the Point
                   field, which is what 'stat' is in this loop
                */
                if (a.IsEmailAgent__c) {
                    a.put( statName ,getPointValEmailAgent( Double.valueOf(a.get( agentFields.get(statName.removeStart('pts_')))), 
                        String.valueOf(agentFields.get( statName.removeStart('pts_')))) );
                } else {
                    a.put( statName, getPointVal( Double.valueOf(a.get( agentFields.get(statName.removeStart('pts_')))), 
                        String.valueOf(agentFields.get(statName.removeStart('pts_')))) );
                }
            }
        } 

        return a; 
            
    }



    /**
     * Builds a String to query for all fields necessary to score agent objects
     * @return string to query all necessary fields for scoring in agent object
     */
    private static String buildQuery() {
        SObjectType agentType = Schema.getGlobalDescribe().get('Agent__c');
        Map<String, Schema.SObjectField> agentFields = agentType.getDescribe().fields.getMap();
        String query = 'SELECT '; 
        for (String s: agentFields.keySet()) {
            if (s.startsWithIgnoreCase('pts_')) {
                query += s +','; 
                query += s.removeStart('pts_') + ', ';
            }
        }

        query += 'IsEmailAgent__c From Agent__c'; 

        return query; 
    }                               
                                    
    
    /**
     * Adds up all points associated with the stats that are passed in the
     * statList for the agent that is passed in. 
     * 
     * @author Mike McGee 
     * @param   agent       The agent whos totalPoints needs to be calculated. 
     * @param   statList    List of the statNames to be added. Need to be the API name of the field. 
     */
    public static integer getAgentTotalPoints(Agent__c agent, List<String> statList) {
        Integer totalPoints = 0; 
        for (String s: statList) {
            Double statVal = Double.valueOf(agent.get(s)); 
            System.debug('Stat being scored '+s+' at value '+statVal);
            if (statVal != null) {
                if(agent.IsEmailAgent__c){
                    totalPoints += (Integer)getPointValEmailAgent(statVal, s);
                } else {
                    totalPoints += (Integer)getPointVal(statVal, s);
                }
            }
        }
        
        return totalPoints; 
    }

    
    /**
     * Gets points for the passed in stat based on the passed in score
     * 
     * @author Mike McGee
     * @param   score       the value of the Statistic
     * @param   statName    the API name of the field to score. 
     */
    public static double getPointVal(Double score, String statName) {
        AgentStatsScoringLevel__c levels = scoreSettingMap.get(statName); 
        if (levels == null) {
            system.debug(LoggingLevel.ERROR, statName+ 'is not in the custom settings AgentStatsScoringLevels__c');
            return 0; 
        }

        // Check for null score.
        if (score == null) {
            system.debug(LoggingLevel.ERROR, statName+ ' value was null, returned 0 points');
            return 0; 
        }

        // Rounding all stats except for Quality Error Rate
        if (!statName.equalsIgnoreCase('Quality_Error_Rate__c')) {
            system.debug('Score was originally ' + score);
            score = Math.round(score);
            system.debug('Score after rounding' + score);
        }
        
        //rankstyle is HIGH if high score is better, LOW if a low score is better. 
        if (levels.RankStyle__c.equals('HIGH')) {
           if (score < levels.NeedsImprovementLevel__c) {
               system.debug('Returning unsat level');
                return levels.UnsatisfactoryPoints__c; 
            } else if (score < levels.GoodLevel__c) {
                system.debug('Returning NI level');
                return levels.NeedsImprovementPoints__c; 
            } else if (score < levels.SuperiorLevel__c) {
                system.debug('Returning good level');
                return levels.GoodPoints__c; 
            } else if (score < levels.OutstandingLevel__c) {
                system.debug('Returning sup level');
                return levels.SuperiorPoints__c; 
            } else {
                system.debug('Returning outstand level');
                return levels.OutstandingPoints__c; 
            } 
        } else if (levels.RankStyle__c.equals('LOW')) {
            if (score > levels.NeedsImprovementLevel__c) {
                system.debug('Returning unsat level');
                return levels.UnsatisfactoryPoints__c; 
            } else if (score > levels.GoodLevel__c) {
                system.debug('Returning NI level');
                return levels.NeedsImprovementPoints__c; 
            } else if (score > levels.SuperiorLevel__c) {
                system.debug('Returning good level');
                return levels.GoodPoints__c; 
            } else if (score > levels.OutstandingLevel__c) {
                system.debug('Returning sup level');
                return levels.SuperiorPoints__c; 
            } else {
                system.debug('Returning oustand level');
                return levels.OutstandingPoints__c; 
            }
        } else {
            return 0; 
        }
        
        
    }
    
    /**
     * Gets points for the passed in stat based on the passed in score
     * <p>
     * Custom_Settings objects cannot be genereic, you must specifically
     * reference them, so there is no easy way to merge this method with the 
     * other get points method. 
     * 
     * @author Mike McGee
     * @param   score       the value of the Statistic
     * @param   statName    the API name of the field to score. 
     */
    public static double getPointValEmailAgent(Double score, String statName) {
        AgentStatsScoringLevels_EmailAndCalls__c levels = emailScoreSettingsMap.get(statName); 
        if (levels == null) {
            system.debug(LoggingLevel.ERROR, statName+ 'is not in the custom settings AgentStatsScoringLevels_EmailAndCalls__c');
            return 0; 
        }

        // Check for null score.
        if (score == null) {
            system.debug(LoggingLevel.ERROR, statName+ ' value was null, returned 0 points');
            return 0; 
        }


        // Rounding all stats except for Quality Error Rate
        if (!statName.equalsIgnoreCase('Quality_Error_Rate__c')) {
            system.debug('Score was originally ' + score);
            score = Math.round(score);
            system.debug('Score after rounding' + score);
        }
        
        //rankstyle is HIGH if high score is better, LOW if a low score is better. 
        if (levels.RankStyle__c.equals('HIGH')) {
           if (score < levels.NeedsImprovementLevel__c) {
               system.debug('Returning unsat level');
                return levels.UnsatisfactoryPoints__c; 
            } else if (score < levels.GoodLevel__c) {
                system.debug('Returning NI level');
                return levels.NeedsImprovementPoints__c; 
            } else if (score < levels.SuperiorLevel__c) {
                system.debug('Returning Good level');
                return levels.GoodPoints__c; 
            } else if (score < levels.OutstandingLevel__c) {
                system.debug('Returning sup level');
                return levels.SuperiorPoints__c; 
            } else {
                system.debug('Returning outstand level');
                return levels.OutstandingPoints__c; 
            } 
        } else if (levels.RankStyle__c.equals('LOW')) {
            if (score > levels.NeedsImprovementLevel__c) {
                system.debug('Returning unsat level');
                return levels.UnsatisfactoryPoints__c; 
            } else if (score > levels.GoodLevel__c) {
                system.debug('Returning NI level');
                return levels.NeedsImprovementPoints__c; 
            } else if (score > levels.SuperiorLevel__c) {
                system.debug('Returning good level');
                return levels.GoodPoints__c; 
            } else if (score > levels.OutstandingLevel__c) {
                system.debug('Returning sup level');
                return levels.SuperiorPoints__c; 
            } else {
                system.debug('Returning outstand level');
                return levels.OutstandingPoints__c; 
            }
        } else {
            return 0; 
        }
        
        
    }
    
}