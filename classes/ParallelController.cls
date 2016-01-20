public with sharing class ParallelController {
	
	private static List<Request__c> requests = new List<Request__c>(); 



	public ParallelController() {
		
	}


	@RemoteAction
	public static boolean lockTest() {
		system.debug('Entered lockTest');
		Map<String, Selecting__c> selectMap = Selecting__c.getAll();
		if (selectMap.get('Selecting').inProgress__c == true) {
			system.debug('someone else was selecting');
			return false;
		} else {
			system.debug('Noone else was selecting, you are selecting a case. ');
			Selecting__c s = selectMap.get('Selecting'); 
			s.inProgress__c = true; 
			update s; 
			AJAXController ac = new AJAXController(); 
			Case wouldBeCase = ac.getNextUnassigned(); 
			system.debug('User '+UserInfo.getUserId()+' received case :'+wouldBeCase.Id);
			s.inProgress__c = false; 
			update s; 
			return true; 
		}
	}

    //action
    public void start(){
        
        Request__c req = new Request__c(userid__c=UserInfo.getUserId());
        insert req;
         
        testRequest tr = new testRequest();
        
        
        tr.processrequest();
        
        
    }


	//Onlclick for race. 
	public static void testRace() {
		Request__c request = new Request__c();
		request.UserId__c = UserInfo.getUserId();
		//insert request;
		requests.add(request); 

		//Process requests. 
		//List<Request__c> updatedList = processRequests();
		processRequests(); 

		// check the case id's for each user in list. 
		for (Request__c r: requests)   {
			system.debug('User '+r.UserId__c+' has case '+r.CaseId__c);
		}
	}


	private static void processRequests() {
		// Get list of requests 
		//List<Request__c> requests = [SELECT UserId__c FROM Request__c WHERE IsProcessed__c = false]; 
		system.debug('Size of requests :'+requests.size());

		// Get list of cases. 
		List<Case> caseLIst = [SELECT Id, OwnerId, Status from Case WHERE Status = 'Unassigned' AND isClosed = false 
                      ORDER BY Priority, CRDate__c ]; 


        //List<Request__c> listToUpdate = new List<Request__c>(); 
        List<Case> cList = new List<Case>(); 
		// Loop through and assign a case to each user. 
		for (Request__c r: requests) {
			Case nextCase = caseLIst.remove(0);
			r.CaseId__c = nextCase.Id;
			nextCase.Status = 'In Progress'; 
			r.IsProcessed__c = true; 
			//listToUpdate.add(r);
			cList.add(nextCase); 
		}

		//update listToUpdate; 
		update cList; 
	}
}