/**
 * This class is used to build custom settings for test data. 
 * The values are hardcoded as there is no oter way to create test data (that I have found)
 * This class is used in conjunction with specific Custom Setting builders. 
 * Currently the only Concrete builder being used is AgentStatCustSetBuilder
 * 
 * @author Mike McGee 
 */
@isTest
public class CustomSettingsBuilder {
	
	/**
	 * gets a list of AgentStatScoring level custom settings. 
	 *
	 * @param isEmailCS true if you want a list of AgentStatsScoringLevels_EmailAndCalls__c, false if you want a list of AgentStatsScoringLevel__c
	 * @return list of Objects Representing custom settings. 
	 */
	public static List<AgentStatsScoringLevel__c> getAgentLevelsNonEmailCS() {
		List<AgentStatsScoringLevel__c> neList = new List<AgentStatsScoringLevel__c>(); 
	    neList.add( getNonEmailCS('Other_Time__c', 660, 3, 900, 1, 300, 5, 539, 4, 0, 'LOW') );
	    neList.add( getNonEmailCS('Contacts_Per_Day__c', 79.5, 3.0, 69.5, 1.0, 99.5, 5.0, 89.5, 4.0, 0.0, 'HIGH') );
	    neList.add( getNonEmailCS('Average_Call_Handle_Time_Double__c', 260, 6, 275, 3, 235, 10, 244, 8, 0, 'LOW') );
	    neList.add( getNonEmailCS('Call_Over_7_Minutes_Percent__c', 16, 6, 18, 3, 11, 10, 13.99, 8, 0, 'LOW') );
	    neList.add( getNonEmailCS('Communication_with_Sup__c', 3.1, 3, 1.0, 1, 8.1, 5, 6.1, 4, 0, 'HIGH') ); 
	    neList.add( getNonEmailCS('Dependability__c', 2, 3, 1, 1, 4.1, 5, 3.1, 4, 0, 'HIGH') );
	    neList.add( getNonEmailCS('Follow_up_time_Double__c', 2160, 8, 2700, 4, 1380, 15, 1919, 12, 0, 'LOW') );
	    neList.add( getNonEmailCS('Hold_Time_Double__c', 2160, 6, 2699, 3, 1380, 10, 1919, 8, 0, 'LOW') );
	    neList.add( getNonEmailCS('Quality_Error_Rate__c', 1, 6, 1.24, 3, 0.5, 10, 0.75, 8, 0, 'LOW') );
	    neList.add( getNonEmailCS('Quality_Score_BPA__c', 75, 8, 70, 4, 90, 15, 85, 12, 0, 'HIGH') );
	    neList.add( getNonEmailCS('Schedule_Adherence_Percent__c', 90, 3, 86.5, 1, 96.5, 5, 93.01, 4, 0, 'HIGH') );
	    neList.add( getNonEmailCS('Teamwork__c', 2, 3, 1, 1, 4.1, 5, 3.1, 4, 0, 'HIGH') );
	    return neList; 
	} 

	public static List<AgentStatsScoringLevels_EmailAndCalls__c> getAgentLevelsEmailCS() {
		List<AgentStatsScoringLevels_EmailAndCalls__c> eList = new List<AgentStatsScoringLevels_EmailAndCalls__c>(); 
	    eList.add( getEmailCS('Contacts_Per_Day__c', 79.5, 3, 69.5, 1, 99.5, 5, 89.5, 4, 0, 'HIGH') );
	    eList.add( getEmailCS('Other_Time__c', 660, 3, 900, 1, 300, 5, 539, 4, 0, 'LOW') );
	    eList.add( getEmailCS('Average_Call_Handle_Time_Double__c', 260, 3, 275, 1, 235, 5, 244, 4, 0, 'LOW') );
	    eList.add( getEmailCS('Call_Over_7_Minutes_Percent__c', 16, 6, 18, 3, 11, 10, 13.99, 8, 0, 'LOW') );
	    eList.add( getEmailCS('Communication_with_Sup__c', 3.1, 3, 1.0, 1, 8.1, 5, 6.1, 4, 0, 'HIGH') ); 
	    eList.add( getEmailCS('Dependability__c', 2, 3, 1, 1, 4.1, 5, 3.1, 4, 0, 'HIGH') );
	    eList.add( getEmailCS('Email_Handle_Time_Double__c', 480, 3, 524, 1, 285, 5, 389, 4, 0, 'LOW') );
	    eList.add( getEmailCS('Follow_up_time_Double__c', 2160, 8, 2700, 4, 1380, 15, 1919, 12, 0, 'LOW') );
	    eList.add( getEmailCS('Hold_Time_Double__c', 2160, 6, 2204, 3, 1380, 10, 1919, 8, 0, 'LOW') );
	    eList.add( getEmailCS('Quality_Email_Percent__c', 93, 3, 90, 1, 98, 5, 96, 4, 0, 'HIGH') );
	    eList.add( getEmailCS('Quality_Error_Rate__c', 1, 6, 1.24, 3, 0.5, 10, 0.75, 8, 0, 'LOW') );
	    eList.add( getEmailCS('Quality_Score_BPA__c', 75, 6, 70, 3, 90, 10, 85, 8, 0, 'HIGH') );
	    eList.add( getEmailCS('Schedule_Adherence_Percent__c', 90, 3, 86.5, 1, 96.5, 5, 93.01, 4, 0, 'HIGH') );
	    eList.add( getEmailCS('Teamwork__c', 2, 3, 1, 1, 4.1, 5, 3.1, 4, 0, 'HIGH') );
	    return eList; 
	}



	/**
     * gets email agent stats custom setting
     */
    private static AgentStatsScoringLevels_EmailAndCalls__c getEmailCS( 
    	String name, Decimal goodLevel, Decimal goodPoints, 
    	Decimal niLevel, Decimal niPoints, Decimal outLevel, Decimal outPoints, 
    	Decimal supLevel, Decimal supPoints, Decimal unsatPoints, String style ) {
    		
    	AgentStatCustSetBuilder temp = new AgentStatCustSetBuilder(name);
         			temp.setGoodLevel((Double)goodLevel);
         			temp.setGoodPoints((Double)goodPoints);
         			temp.setNiLevel((Double)niLevel);
         			temp.setNiPoints((Double)niPoints);
         			temp.setOutLevel((Double)outLevel);
         			temp.setOutPoints((Double)outPoints);
         			temp.setSupLevel((Double)supLevel);
         			temp.setSupPoints((Double)supPoints);
         			temp.setUnsatPoints((Double)unsatPoints);
         			temp.setRankStyle(style);
         			
         return temp.buildEmailSetting();
    }
    
    
    /**
     * gets non email agent stats custom setting
     */
     private static AgentStatsScoringLevel__c getNonEmailCS(String name, 
     	Decimal goodLevel, Decimal goodPoints, Decimal niLevel, Decimal niPoints,
     	Decimal outLevel, Decimal outPoints,Decimal supLevel, Decimal supPoints, 
     	Decimal unsatPoints, String style) {
     		
     		AgentStatCustSetBuilder temp = new AgentStatCustSetBuilder(name);
         			temp.setGoodLevel((Double)goodLevel);
         			temp.setGoodPoints((Double)goodPoints);
         			temp.setNiLevel((Double)niLevel);
         			temp.setNiPoints((Double)niPoints);
         			temp.setOutLevel((Double)outLevel);
         			temp.setOutPoints((Double)outPoints);
         			temp.setSupLevel((Double)supLevel);
         			temp.setSupPoints((Double)supPoints);
         			temp.setUnsatPoints((Double)unsatPoints);
         			temp.setRankStyle(style);
         			
         return temp.buildNonEmailSetting();
     	
     }

}