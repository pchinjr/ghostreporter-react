public class ColorCode {
	
	private static ColorCode instance; 

	//Color codes
	private String unSatCode = '#F44336 !important';
	private String needsImprovementCode = '#FFEB3B !important'; 
	private String goodCode = '#BA68C8  !important';
	private String supCode = '#2196F3 !important;';
	private String outstandingCode = '#4CAF50 !important';  

	//Stat levels
	//cpd levels
	Integer cpdNiLevel = 70;
	Integer cpdGoodLevel = 80; 
	Integer cpdSupLevel = 91; 
	Integer cpdOutStandLevel = 100; 
	//qbpa levels 
	Integer qbpaNiLevel = 70; 
	Integer qbpaGoodLevel = 75; 
	Integer qbpaSupLevel = 85; 
	Integer qbpaOutStandLevel = 90; 
	//qerr levels 
	Double qerrNiLevel = 1.25;
	Double qerrGoodLevel = 1.0; 
	Double qerrSupLevel = 0.75; 
	Double qerrOutStandLevel = 0.5;  
	//aht levels
	Integer achtNiLevel = 275; 
	Integer achtGoodLevel = 260; 
	Integer achtSupLevel = 244; 
	Integer achtOutStandLevel = 235; 
	//ht levels 
	Integer htNiLevel = 10; 
	Integer htGoodLevel = 8; 
	Integer htSupLevel = 6; 
	Integer htOutStandLevel = 5; 
	//co7m levels
	Integer co7mNiLevel = 18; 
	Integer co7mGoodLevel = 16; 
	Integer co7mSupLevel = 14; 
	Integer co7mOutStandLevel = 11; 
	//sa levels
	Integer saNiLevel = 86; 
	Integer saGoodLevel = 90; 
	Integer saSupLevel = 93;
	Integer saOutStandLevel = 96; 
	//fut levels
	Integer futNiLevel = 15; 
	Integer futGoodLevel = 11; 
	Integer futSupLevel = 9; 
	Integer futOutStandLevel = 5; 
	
	//Other Time levels
	Integer otNiLevel = 15; 
	Integer otGoodLevel = 11; 
	Integer otSupLevel = 9; 
	Integer otOutStandLevel = 5; 
	
	//Custom settings map for agent scoring 
    private Map<String, AgentStatsScoringLevel__c> scoreSettingMap = AgentStatsScoringLevel__c.getAll(); 
    private Map<String, AgentStatsScoringLevels_EmailAndCalls__c> emailScoreSettingsMap =
    								AgentStatsScoringLevels_EmailAndCalls__c.getAll(); 

	private ColorCode() {} 

	public static ColorCode getInstace(){
		if (instance == null) {
			instance = new ColorCode(); 
		}

		return instance;
	}
	
	public String getColorCode(Decimal score, String statName, boolean isEmail) {

		if (statName.toLowerCase().contains('time') && score == 0) {
			return 'white'; 
		}

	    if (isEmail) {
	        return getColorCodeEmailAgent(Double.valueOf(score), statName);
	    } else {
	        return getColorCode(Double.valueOf(score), statName); 
	    }
	}
	
	/**
     * Gets points for the passed in stat based on the passed in score
     * 
     * @author Mike McGee
     * @param   score       the value of the Statistic
     * @param   statName    the API name of the field to score. 
     */
    public String getColorCode(Double score, String statName) {
        AgentStatsScoringLevel__c levels = scoreSettingMap.get(statName); 
        if (levels == null) {
            system.debug(LoggingLevel.ERROR, statName+ 'is not in the custom settings AgentStatsScoringLevels__c');
            return 'white'; 
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
                return unSatCode; 
            } else if (score < levels.GoodLevel__c) {
                return needsImprovementCode; 
            } else if (score < levels.SuperiorLevel__c) {
                return goodCode; 
            } else if (score < levels.OutstandingLevel__c) {
                return supCode; 
            } else {
                return outstandingCode; 
            } 
        } else if (levels.RankStyle__c.equals('LOW')) {
            if (score > levels.NeedsImprovementLevel__c) {
                return unSatCode; 
            } else if (score > levels.GoodLevel__c) {
                return needsImprovementCode; 
            } else if (score > levels.SuperiorLevel__c) {
                return goodCode; 
            } else if (score > levels.OutstandingLevel__c) {
                return supCode; 
            } else {
                return outstandingCode; 
            }
        } else {
            return 'white'; 
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
    public String getColorCodeEmailAgent(Double score, String statName) {
        AgentStatsScoringLevels_EmailAndCalls__c levels = emailScoreSettingsMap.get(statName); 
        if (levels == null) {
            system.debug(LoggingLevel.ERROR, statName+ 'is not in the custom settings AgentStatsScoringLevels_EmailAndCalls__c');
            return 'white'; 
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
                return unSatCode; 
            } else if (score < levels.GoodLevel__c) {
                return needsImprovementCode; 
            } else if (score < levels.SuperiorLevel__c) {
                return goodCode; 
            } else if (score < levels.OutstandingLevel__c) {
                return supCode; 
            } else {
                return outstandingCode; 
            } 
        } else if (levels.RankStyle__c.equals('LOW')) {
            if (score > levels.NeedsImprovementLevel__c) {
                return unSatCode; 
            } else if (score > levels.GoodLevel__c) {
                return needsImprovementCode; 
            } else if (score > levels.SuperiorLevel__c) {
                return goodCode; 
            } else if (score > levels.OutstandingLevel__c) {
                return supCode; 
            } else {
                return outstandingCode; 
            }
        } else {
            return 'white'; 
        }
        
        
    }

    /**
     * @deprecated
     */
	public String getColorCode(String statName, Decimal statValue) {
		if (statName.equalsIgnoreCase('total')) {
			return getTotalColorCode(statValue);
		} else {
			system.debug(LoggingLevel.ERROR, 
           'Incorrect statName provided: This method has been deprecated for all stats except total');
			return 'White'; 
		}
	}
	

	public String getTotalColorCode(Decimal statValue) {
		if (statValue < 25) {
			return unSatCode; 
		} else if (statValue < 50) {
			return needsImprovementCode;
		} else if (statValue < 70) {
			return goodCode; 
		} else if (statValue < 85) {
			return supCode; 
		} else {
			return outstandingCode; 
		}
	}

}