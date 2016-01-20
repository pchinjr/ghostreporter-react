@isTest
private class ServiceOrderAccuracyReport_Test {

	@testSetup static void setup() {
		// Need some AgentTeam objects in db so that they can be the parents of 
		// the errors objects. 
		List<String> typeList = new List<String>{'Contractor', 'Commercial', 
												 'Residential'};
		List<AgentTeam__c> aList = new List<AgentTeam__c>();
		for (Integer i = 0; i < 30; ++i) {
			AgentTeam__c temp = new AgentTeam__c();
			temp.AgentType__c = typeList[Math.mod(i, 3)];
			temp.PSERMID__c = 'test'+i;
			aList.add(temp);
		}

		Database.SaveResult[] sResults = Database.insert(aList, false);

		// Place some AgentErrors objects in the database so that they can be
		// queried for.
		List<AgentErrors__c> errorList = new List<AgentErrors__c>();
		for (integer i = 0; i < 30; ++i) {
			AgentErrors__c temp = new AgentErrors__c();
			temp.Date__c = Date.today();
			temp.Deposit__c = Math.round(Math.random() *10);
			temp.WrongSA__c = Math.round(Math.random() *10);
			temp.Sat_Sun_Holiday__c = Math.round(Math.random() *10);
			temp.ATO__c = Math.round(Math.random() *10);
			temp.NoConnectionCharge__c = Math.round(Math.random() *10);
			temp.SelectedTooManySAS__c = Math.round(Math.random() *10);
			temp.MailingAddress__c = Math.round(Math.random() *10);
			temp.FaMisc__c = Math.round(Math.random() *10);
			temp.AllSasNotSelect__c = Math.round(Math.random() *10);
			temp.PayPlan__c = Math.round(Math.random() *10);
			temp.Misc__c = Math.round(Math.random() *10);
			temp.WrongAddress__c = Math.round(Math.random() *10);
			integer j = i;
			while (!sResults[j].isSuccess() && j < sResults.size()) {
				j++;
			}

			temp.Agent__c = sResults[j].getId();
			errorList.add(temp);
		}

		Database.SaveResult[] eResults = Database.insert(errorList, false);
		System.assert(!eResults.isEmpty());
	}
	
	@isTest static void positiveTest() {
		// Set the current page to be that of the ServiceOrderAccuracyReport
		PageReference pRef = Page.ServiceOrderAccuracyReport;

		// Instantiate the controller
		ServiceOrderAccuracyReportController controller = 
			new ServiceOrderAccuracyReportController();

		// Set some fields
		controller.comm();
		List<StatWrapper> commList = controller.getData();
		System.assert(!commList.isEmpty());

		controller.cont();
		List<StatWrapper> contList = controller.getData();
		System.assert(!contList.isEmpty());

		controller.resd();
		List<StatWrapper> resdList = controller.getData();
		System.assert(!resdList.isEmpty());
	}
	
	@isTest static void negativeTest() {
		PageReference pRef = Page.ServiceOrderAccuracyReport;
		ServiceOrderAccuracyReportController con =
		 new ServiceOrderAccuracyReportController();

		List<StatWrapper> errList = con.getData();
	}
	
	

	
}