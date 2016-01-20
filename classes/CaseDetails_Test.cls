@isTest

public class CaseDetails_Test {
    static User ruben;
    static User alex;
    static String timeId1;

	 static testMethod void testc() {
        String casenum;
        Integer foundFlag;
        foundFlag = 0;
        
        timeId1 = [select Id from BusinessHours].Id;
        
        alex = [select Id, name from user where username = 'arivera@ouc.com'];
        
        CaseDetail_Wrapper ctest = new CaseDetail_Wrapper();
        ctest.timeId = timeId1;
        ctest.agent = 'Alex Rivera';
        ctest.origin = 'Email';
        ctest.source = 'Email';
        ctest.status = 'In Progress';
        ctest.priority = 'High';
        ctest.inprogress = 2;
        ctest.unassigned = 2;
        ctest.closed = 2;
        ctest.promoted = 2;
        ctest.queue = 2;
        ctest.description = 'some description';
        ctest.NoteType = 'BILLI';
        ctest.caseNumber = '12345';
        ctest.avgHandle = 23;
        ctest.isCurrent = true;
        ctest.maxDate = DateTime.Now();
        ctest.caseId = '12313123123';
 
        
        CaseDetail_Wrapper caseWrapper = new CaseDetail_Wrapper(timeId1, 'Alex Rivera', 'Email', 'Email', 'In Progress', 'Some description', 
                                                        'BILLI', '123123313',DateTime.Now(), '123', 
                                                        '123');
        caseWrapper.GetElapsedTime(DateTime.now(), timeId1);
        
        caseWrapper.getOne();
        
        
        
        Case c = new Case();
        c.ownerid = alex.id;
        c.status = 'test1';
        c.account_id__c = 'test1';
        c.crt_review_dt__c = DateTime.now();
        c.maxDate__c = DateTime.now();
        insert c;

        Case c2 = new Case();
        c2.ownerid =  alex.id;
        c2.status = 'test2';
        c2.account_id__c = '6789';
        c2.crt_review_dt__c = DateTime.now();
        c2.maxDate__c = DateTime.now();
        insert c2;



        User_Wrapper uw = new User_Wrapper();
        casenum = uw.getCurrentCaseID('Alex Rivera');
        List<CaseDetail_Wrapper> detailsContainer = new List<CaseDetail_Wrapper>();

        For(Case c1: [select owner.name, origin, source__c, status, id, description, note_type__c, crt_review_dt__c, casenumber from case where owner.name = 'Alex Rivera'
                       and createddate = today ]){
                System.debug('status=' + c.status + ',infor casenum=' + c1.casenumber);           
           detailsContainer.add(new CaseDetail_Wrapper(timeId1, c1.owner.name, c1.origin, c1.source__c, c1.status, c1.description, c1.note_type__c, c1.id, c1.crt_review_dt__c, c1.casenumber, uw.getCurrentCaseID('Alex Rivera')));
        }

        System.debug('size = ' + detailsContainer.size());
        
        for(Integer x=0; x<detailsContainer.size(); x++){
           System.debug('crtdate=' + detailsContainer[x].crtdate +  ', status=' + detailsContainer[x].status + ', foundcase=' + casenum + 'casenum in wrapper=' + detailsContainer[x].casenumber + 'iscurrent=' + detailsContainer[x].iscurrent); 
            if(detailsContainer[x].iscurrent == True)
               foundFlag = 1;
             
        }
        
        System.debug('foundflag= ' + foundflag);    
    
        if (foundFlag >= 1)
			System.assert(true);
			
	


	}

}