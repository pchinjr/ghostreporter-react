@isTest
private class QueryManager_Test {

	/**
	 * Inserts all information necessary for testing the ObjectManager. 
	 * All data inserted in this method will persist over the running context
	 * of the test.
	 */
	@testSetup static void setup() {
		// Need to insert some data to query for.
		List<Case> caseList = new List<Case>();
		for (Integer i = 0; i < 25; ++i) {
			Case temp = new Case();
			temp.Description__c = 'Temp case '+i;
			//temp.casenumber__c = 'c'+i;
			temp.priority = 'medium';
			caseList.add(temp);
		}	

		insert caseList;
	}

		
	@isTest static void nonFilteredTest() {
		QueryManager qManager = new QueryManager();
		String dbQuery = qManager.buildFilterlessQuery('Case');
		List<Case> caseList = Database.query(dbQuery);
		System.assert(!caseList.isEmpty());
	}
	

	@isTest static void filteredTest() {
		QueryManager qManager = new QueryManager();
		qManager.addFilter('Description__c', 'Temp case 1');

		Map<String, Object> filterMap = new Map<String, Object>();
		filterMap.put('Description__c', 'Temp case 1');
		QueryManager filteredManager = new QueryManager(filterMap);

		// Filterless query not currently useable.
	}
	
}