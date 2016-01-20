/**
 * This class contains unit tests for validating the behavior of Apex class
 * AgentErrorsController.
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
private class AgentErrorsController_Test
{

	/**
     * Sets up data that can be used in all test methods. 
     * Any data that is changed in one test method will be 
     * reset to its original data in the next test mehtod. 
     */
    @testSetup static void setup() {
    	// Need to insert an AgentTeam object so that the AgentErrors objects that get insetted have a master
    	AgentTeam__c at = new AgentTeam__c(); 
    	at.PSERMID__c = 'testid'; 
    	at.FirstName__c = 'Test'; 
    	at.LastName__c = 'Man';
    	at.isActive__c = true; 
    	insert at; 

    	// Have to insert all necessary custom settings. 
    	AgentErrorsCS__c allsasnotselect = new AgentErrorsCS__c();allsasnotselect.PointsPerClick__c = 1.0;allsasnotselect.Name = 'AllSasNotSelect__c';insert allsasnotselect;AgentErrorsCS__c sat_sun_holiday = new AgentErrorsCS__c();sat_sun_holiday.PointsPerClick__c = 1.0;sat_sun_holiday.Name = 'Sat_Sun_Holiday__c';insert sat_sun_holiday;AgentErrorsCS__c email_content = new AgentErrorsCS__c();email_content.PointsPerClick__c = 20.0;email_content.Name = 'Email_Content__c';insert email_content;AgentErrorsCS__c email_properclosing = new AgentErrorsCS__c();email_properclosing.PointsPerClick__c = 5.0;email_properclosing.Name = 'Email_ProperClosing__c';insert email_properclosing;AgentErrorsCS__c noconnectioncharge = new AgentErrorsCS__c();noconnectioncharge.PointsPerClick__c = 1.0;noconnectioncharge.Name = 'NoConnectionCharge__c';insert noconnectioncharge;AgentErrorsCS__c email_firstcontactresolution = new AgentErrorsCS__c();email_firstcontactresolution.PointsPerClick__c = 20.0;email_firstcontactresolution.Name = 'Email_FirstContactResolution__c';insert email_firstcontactresolution;AgentErrorsCS__c email_punctuation = new AgentErrorsCS__c();email_punctuation.PointsPerClick__c = 10.0;email_punctuation.Name = 'Email_Punctuation__c';insert email_punctuation;AgentErrorsCS__c wrongsa = new AgentErrorsCS__c();wrongsa.PointsPerClick__c = 1.0;wrongsa.Name = 'WrongSA__c';insert wrongsa;AgentErrorsCS__c email_sentence = new AgentErrorsCS__c();email_sentence.PointsPerClick__c = 10.0;email_sentence.Name = 'Email_Sentence__c';insert email_sentence;AgentErrorsCS__c misc = new AgentErrorsCS__c();misc.PointsPerClick__c = 1.0;misc.Name = 'Misc__c';insert misc;AgentErrorsCS__c email_tone = new AgentErrorsCS__c();email_tone.PointsPerClick__c = 5.0;email_tone.Name = 'Email_Tone__c';insert email_tone;AgentErrorsCS__c email_spelling = new AgentErrorsCS__c();email_spelling.PointsPerClick__c = 10.0;email_spelling.Name = 'Email_Spelling__c';insert email_spelling;AgentErrorsCS__c payplan = new AgentErrorsCS__c();payplan.PointsPerClick__c = 1.0;payplan.Name = 'PayPlan__c';insert payplan;AgentErrorsCS__c famisc = new AgentErrorsCS__c();famisc.PointsPerClick__c = 1.0;famisc.Name = 'FaMisc__c';insert famisc;AgentErrorsCS__c email_salutation = new AgentErrorsCS__c();email_salutation.PointsPerClick__c = 5.0;email_salutation.Name = 'Email_Salutation__c';insert email_salutation;AgentErrorsCS__c ato = new AgentErrorsCS__c();ato.PointsPerClick__c = 1.0;ato.Name = 'ATO__c';insert ato;AgentErrorsCS__c deposit = new AgentErrorsCS__c();deposit.PointsPerClick__c = 1.0;deposit.Name = 'Deposit__c';insert deposit;AgentErrorsCS__c mailingaddress = new AgentErrorsCS__c();mailingaddress.PointsPerClick__c = 1.0;mailingaddress.Name = 'MailingAddress__c';insert mailingaddress;AgentErrorsCS__c email_grammar = new AgentErrorsCS__c();email_grammar.PointsPerClick__c = 10.0;email_grammar.Name = 'Email_Grammar__c';insert email_grammar;AgentErrorsCS__c selectedtoomanysas = new AgentErrorsCS__c();selectedtoomanysas.PointsPerClick__c = 1.0;selectedtoomanysas.Name = 'SelectedTooManySAS__c';insert selectedtoomanysas;AgentErrorsCS__c email_paragraph = new AgentErrorsCS__c();email_paragraph.PointsPerClick__c = 5.0;email_paragraph.Name = 'Email_Paragraph__c';insert email_paragraph;AgentErrorsCS__c wrongaddress = new AgentErrorsCS__c();wrongaddress.PointsPerClick__c = 1.0;wrongaddress.Name = 'WrongAddress__c';insert wrongaddress;
    }

	/**
	 * Tests AgentErrorsController using expected input
	 */
	@isTest static void positiveTest() {
		// Set current page to AgentErrors. 
		PageReference pRef = Page.AgentErrors;
		// Instantiate new Controller objecy
		AgentErrorsController controller = new AgentErrorsController();
		// Call select list method
		controller.getAgentSelectList();
		// Call getAgentErrors with isEmail = true (already called with false in constructor)
		AgentErrorsController.getErrors(true);
		// Set the page variable isEmai
		ApexPages.currentPage().getParameters().put('isEmail', 'true');
		// Call setErros
		AgentErrorsController.setErrors();
		// Need to execute a save 
		Integer[] values = new List<Integer>{1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
		String[] names = new List<String>{'PayPlan__c', 'FaMisc__c', 'Email_Salutation__c', 'Sat_Sun_Holiday__c', 'Email_Sentence__c', 
							'Email_Grammar__c', 'Email_ProperClosing__c', 'Email_Tone__c', 'SelectedTooManySAS__c', 'NoConnectionCharge__c'};
		String commentString = 'This is a comment for testing puposes only'; 
		AgentErrorsController.save(values, names, 'testid', '3/20/2014', commentString, 'Commercial', true, 'Mike McGee');

		// Call getNewErrors with the info that was just inserted. 
		AgentErrorsController.getNewErrors('testid', '3/20/2014');

		// Assert that the correct information was saved
		AgentErrors__c agentError = [SELECT Id, PayPlan__c, FaMisc__c, Email_Salutation__c FROM AgentErrors__c LIMIT 1];
		system.assertEquals(1, agentError.PayPlan__c);
	}

}