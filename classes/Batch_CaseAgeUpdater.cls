/**
 * Batch Class for CaseConsolidator Used to consolidate all current cases
 */
global class Batch_CaseAgeUpdater implements Database.Batchable<sObject>{

    public String query; 
    public Datetime dt_start;
    public Datetime dt_end; 
    public String businessHoursId;
    public Long Diff1; 
    public Long Diff2;
    public Decimal de1; 
    public Decimal de2;
    public boolean updateClosed;
    public boolean updateInProgress;
 
    // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
     	return Database.getQueryLocator(query);
     }
    
	//Execute Logic
    global void execute(Database.BatchableContext BC, List<sObject>scope)
    {
         
        
        
        //cast all sOjbects in scope to cases in order to consolidate. 
        List<Case> caseList = new List<Case>();
        for(sObject s : scope)
        {
            caseList.add((Case)s);
        }


        
        this.businessHoursId = [select Id from BusinessHours].Id;
        
        boolean isBatch = true;  
        //Use the isIdTested to avoid sending in the cases with the same AccountID more than once.
        Map<String, boolean> isIdTested = new Map<String, boolean>(); 
        for (Case c : caseList) {
            DateTime d1 = DateTime.newInstance(1997, 1, 31, 7, 8, 16); 
            DateTime d2 = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
            
            System.debug('CRT Review Date=' + c.CRT_Review_DT__c + ', ClosingDate= ' + c.closeddate);
            
        
            //update when 
            if(updateClosed == true &&  c.CRT_Review_DT__c != null && c.closedDate != null){
                    System.debug('Inside Closing update');
                c.Case_Age_In_Business_Hours__c=updateClosedHours(c.CRT_Review_DT__c, c.closedDate);
                //c.Case_Age_In_Business_Hours__c= hoursSinceCreation(c);
            }
            
            
            if(updateInProgress == true &&  c.CRT_Review_DT__c != null){
                System.debug('Inside inProgress update');
                c.Case_Age_In_Business_Hours__c=updateClosedHours(c.CRT_Review_DT__c, DateTime.now());
            }
            
            if(c.closedDate == null && c.CRT_Review_DT__c == null){
                System.debug('Inside inProgress update');
                c.Case_Age_Unassigned__c=updateClosedHours(c.createddate, DateTime.now());
            }

        }
        updateClosed = false;
        updateInProgress = false;
        
        update caseList;
    }
    
    	public double hoursSinceCreation(Case inputCase) {
		
        		if (inputCase.CRT_Review_DT__c == null)
        			return 0;
		
		// convert milliseconds to hours : millis/1000 => seconds/60 => minutes/60 => hours
		return BusinessHours.diff([select Id from BusinessHours].Id, inputCase.CRT_Review_DT__c, inputCase.closedDate) / 1000 / 60 / 60;	
	}
 
         public decimal updateClosedHours(DateTime start, DateTime dend){
                DateTime d1 = DateTime.newInstance(1997, 1, 31, 7, 8, 16); 
                DateTime d2 = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
                
                d1=start;
                d2=dend;
                
                System.debug('Start=' + d1 + 'End=' + d2);
                
                Diff1=BusinessHours.diff( this.businessHoursId,d1, d2) ; 
                
                
                DateTime d3=DateTime.newInstanceGmt((d1.dateGmt()), (d1.timeGmt()) ); 
                DateTime d4=DateTime.newInstanceGmt((d2.dateGmt() ), (d2.timeGmt() ) );
                
                Diff2=BusinessHours.diff( this.businessHoursId,d1, d2) ;
                De1=BusinessHours.diff( this.businessHoursId,d1, d2) ; 
                
                de1=((De1/(1*60*60*1000))-(diff2/(1*60*60*1000)));
                De2=((de1/100)*60); 
                System.debug('Calculated Hours=' + ((Diff2/(1*60*60*1000))+de2));
            return ((Diff2/(1*60*60*1000))+de2);
    }
    
 
    
    global void finish(Database.BatchableContext BC){
         // Logic to be Executed at finish
          AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      						TotalJobItems, CreatedBy.Email
      						FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
         
         System.debug('Exited batch job with status of '+ a.Status);
    }
    
    
    
    
    
    
}