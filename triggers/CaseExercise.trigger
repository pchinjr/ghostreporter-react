//Create new task if customer has existing case and case is assigned and open and not email
//then do something else with the case

trigger CaseExercise on Case (after insert) {



for(Case c: trigger.new){
    Case personid = trigger.newMap.get(c.id);
    System.debug('accountid=' + c.account_id__c);
    
    //get latest active case
    Case testCase = [select id, ownerid, subject, status, description from case where isclosed = false and status = 'In Progress'
                       and account_id__c = :c.account_id__c order by createddate limit 1];
    
    if( testCase != null){
        //Now get who it's assigned to and make case
        Task newtask = new Task();
        newtask.whatid = testCase.id;
        newtask.ownerid = testcase.ownerid;
        newtask.subject = 'Repeat case resolution';
        newtask.status = 'Not Started';
        newtask.ActivityDate = Date.today();
        newtask.description = 'Customer has generated a new case:' + testCase.description;
        insert newtask;
        
        
    }

    
}

}