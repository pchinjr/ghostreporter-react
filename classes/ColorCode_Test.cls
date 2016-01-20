/**
 * This class contains unit tests for validating the behavior of class
 * ColorCode
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
 */
@isTest
private class ColorCode_Test {

    static testMethod void myUnitTest() {
        /* Insert two custom setting to be checked for non email
        * one for high and one for low rank style.
        */ 
        AgentStatCustSetBuilder csBuilder = 
        	new AgentStatCustSetBuilder('Contacts_Per_Day__c', 80, 3, 70, 1, 100, 5, 91, 4, 0, 'HIGH');

        AgentStatCustSetBuilder csBuilder2 = 
        	new AgentStatCustSetBuilder('Other_Time__c', 660, 3, 900, 1, 300, 5, 540, 4, 0, 'LOW');

        	insert csBuilder.buildNonEmailSetting();
        	insert csBuilder2.buildNonEmailSetting();

         /* Insert two custom setting to be checked for email agent
        * one for high and one for low rank style.
        */ 
        AgentStatCustSetBuilder csBuilder3 = 
        	new AgentStatCustSetBuilder('Contacts_Per_Day__c', 70, 6, 60, 2, 90, 10, 81, 8, 0, 'HIGH');

        AgentStatCustSetBuilder csBuilder4 = 
        	new AgentStatCustSetBuilder('Other_Time__c', 660, 3, 900, 1, 300, 5, 540, 4, 0, 'LOW');

        	insert csBuilder3.buildEmailSetting();
        	insert csBuilder4.buildEmailSetting();


        /* Test getColorCode for expected values */
        //Get ColorCode instance 
        ColorCode colorTester = ColorCode.getInstace(); 

        //List of potential colors {outstand, sup, good, needs impr, unsat}
        List<String> colorList = new String[]{'#4CAF50 !important', '#2196F3 !important;', '#BA68C8  !important', 
    										'#FFEB3B !important', '#F44336 !important'};

        //Values for other time.
        Integer[] otherTime = new List<Integer>{1, 301, 541, 661, 901};
        //Values for cpd non emial
        Integer[] cpdVals = new List<Integer>{101, 92, 81, 71, 0};
        //values for cpd emial
        Integer[] cpdEmailVals = new List<Integer>{91, 82, 71, 61, 0};
        //Values for total
        Integer[] totals = new List<Integer>{100, 80, 61, 41, 0};
        
        //Check all levels for email and non email. 
        for (Integer i = 0; i < 5; ++i) {
        	String color = colorTester.getColorCode(cpdVals[i], 'Contacts_Per_Day__c', false);
        	system.assertEquals(colorList[i], color);
        	color = colorTester.getColorCode(otherTime[i], 'Other_Time__c', false);
        	system.assertEquals(colorList[i], color);
        	//test email
        	color = colorTester.getColorCode(cpdEmailVals[i], 'Contacts_Per_Day__c', true);
        	system.assertEquals(colorList[i], color);
        	color = colorTester.getColorCode(otherTime[i], 'Other_Time__c', true);
        	system.assertEquals(colorList[i], color);
        	//test totals
        	color = colorTester.getColorCode('total', totals[i]);
        	system.assertEquals(colorList[i], color);
        }

        //Return white. Try to get score for stat that was not added to custom setting. 
        String color = colorTester.getColorCode(199, 'Dependability__c', true);
        system.assertEquals('white', color);
        color = colorTester.getColorCode(199, 'Dependability__c', false);
        system.assertEquals('white', color);

    }
}