/**
 * This class contains unit tests for validating the behavior of Apex class
 * ObjectManager.
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
private class ObjectManager_Test {
	
	/**
	 * Inserts all information necessary for testing the ObjectManager. 
	 * All data inserted in this method will persist over the running context
	 * of the test.
	 */
	@testSetup static void setup() {

	}


	@isTest static void positiveTest() {
		// Create new Object manager
		ObjectManager oManager = new ObjectManager('Case');
		//oManager.createFieldMap();
		List<String> caseFields = oManager.getAllFieldNames();
		// Only get fields of type string
		List<String> fieldTypes = new List<String>();
		fieldTypes.add('String');
		List<Schema.SObjectField> fields = 
				oManager.getAllFieldsOfTypes(fieldTypes);

		// Not really sure what to test.
		System.assert(!fields.isEmpty());
		System.assert(!fieldTypes.isEmpty());
	}
	
}