/**
 * This class contains unit tests for validating the behavior of Apex class
 * Rank.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 * @author Mike McGee
 */
@isTest
private class Rank_Test {

    /**
     * Sets up data that can be used in all test methods. 
     * Any data that is changed in one test method will be 
     * reset to its original data in the next test mehtod. 
     */
    @testSetup static void setup() {
        // Place 200 agents in the db
        List<Agent__c> agentList = new List<Agent__c>(); 
        for (integer i = 0; i < 200; ++i) {
            Agent__c temp = new Agent__c(); 
            temp.Contacts_Per_Day__c = i;
            temp.Other_Time__c = i; 
            agentList.add(temp);
        }

        insert agentList; 
    }
    
    /**
     * Test AgentRank with expected input
     */
    @isTest static void positiveTest() {
        // select all agents. 
        List<Agent__c> aList = [SELECT Contacts_Per_Day__c, Other_Time__c, CPD_Rank__c, OT_Rank__c FROM Agent__c]; 

        // Rank the agents using the ranker. 
        Rank cpdRank = new Rank('Contacts_Per_Day__c', 'CPD_Rank__c', aList, 'DESC'); 
        cpdRank.rank('competition'); 

        Rank otRank = new Rank('Other_Time__c', 'OT_Rank__c', aList, 'ASC');
        otRank.rank('dense'); 

        // select lists and order by rank and score, and assert the lists are equal. 
        List<Agent__c> cpdList = [SELECT Contacts_Per_Day__c, Other_Time__c, CPD_Rank__c, OT_Rank__c FROM Agent__c ORDER BY Contacts_Per_Day__c DESC];
        List<Agent__c> cpdRankList = [SELECT Contacts_Per_Day__c, Other_Time__c, CPD_Rank__c, OT_Rank__c FROM Agent__c ORDER BY CPD_Rank__c ASC];
        system.debug('cpdList ' + cpdList);
        system.debug('cpdRankList ' + cpdRankList);
        system.assertEquals(cpdList, cpdRankList);

        List<Agent__c> otList = [SELECT Contacts_Per_Day__c, Other_Time__c, CPD_Rank__c, OT_Rank__c FROM Agent__c ORDER BY Other_Time__c ASC];
        List<Agent__c> otRankList = [SELECT Contacts_Per_Day__c, Other_Time__c, CPD_Rank__c, OT_Rank__c FROM Agent__c ORDER BY OT_Rank__c ASC];
        system.debug('otdList ' + otList);
        system.debug('otRankList ' + otRankList);
        system.assertEquals(otList, otRankList);

    }

    /**
     * Test agent rank with unexprected input
     */ 
    @isTest static void negativeTest() {
        // Get agent list
        List<Agent__c> aList = [SELECT Contacts_Per_Day__c, Other_Time__c, CPD_Rank__c FROM Agent__c];

        // Try to rank using an incorrect style
        Rank wrongStyle = new Rank('Contacts_Per_Day__c', 'CPD_Rank__c', aList, 'FORWARD');
        wrongStyle.rank('competition');

        // With empty agent list 
        aList.clear();
        Rank emptyRank = new Rank('Contacts_Per_Day__c', 'CPD_Rank__c', aList, 'ASC'); 
        emptyRank.rank('competition'); 
    }
    
}