/* Execute Anonymous script:
 * System.schedule('Unique Schedule Name4', '0 35 10 * * ?', new Case_Updater());
 */
global class Case_Updater_Closed2  implements Schedulable {
    global void execute(SchedulableContext sc) {
       updateInProgressHours();
       //updateClosedHours();
    }
    
    public String query;
    public String op_type;
    


  /*
    Type 1 = updateClosedHours
         2 = updateInprogressHours
  */
    public Case_Updater_Closed2(){}
  
  public Case_Updater_Closed2(Integer op_type){
    if(op_type == 1){
        updateClosedHours();    
    }
    else if(op_type == 2){
        System.debug('InProgress executing');
        updateInprogressHours();
    }

    
   }
  
  
  
  
  public void updateClosedHours(){
        query = 'select Id, closeddate, CreatedDate, CRDate__c, CRT_Review_DT__c, ' +
                'Case_Age_In_Business_Hours__c from Case where CRT_Review_DT__C <> null and ' +
                'IsClosed = true and status <> \'Duplicate\'';
        
        Batch_CaseAgeUpdater bu = new Batch_CaseAgeUpdater();
        bu.query = query;
        bu.updateClosed = true;
        
        System.debug('Calling Database.executeBatch' + query);
        ID batchprocessid = Database.executeBatch(bu,50);   
      
  }
  
  
    public void updateInProgressHours(){
        query = 'select Id, closeddate, CreatedDate, CRDate__c, CRT_Review_DT__c, ' +
                'Case_Age_In_Business_Hours__c from Case where CRT_Review_DT__C <> null and status = \'In Progress\'';
        
        Batch_CaseAgeUpdater bu = new Batch_CaseAgeUpdater();
        bu.query = query;
        bu.updateInProgress = true;
        System.debug('Calling Database.executeBatch' + query);
        ID batchprocessid = Database.executeBatch(bu,50);   
      
  }
  
      public void updateUnassignedHours(){
        query = 'select Id, closeddate, CreatedDate, CRDate__c, CRT_Review_DT__c, ' +
                'Case_Age_Unassigned__c from Case where isclosed = false and CRT_Review_DT__C = null and status = \'Unassigned\'';
        
        Batch_CaseAgeUpdater bu = new Batch_CaseAgeUpdater();
        bu.query = query;
        bu.updateInProgress = true;
        System.debug('Calling Database.executeBatch' + query);
        ID batchprocessid = Database.executeBatch(bu,50);   
      
  }
  
  
  
  
  
  
 
  
}