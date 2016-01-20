global with sharing class GoogleChartsController_R {
     

    @RemoteAction   
    global static List<Data> loadOpps2() {
		List<AggregateResult> caseList  = [select calendar_month(closeddate) pmonth, sum(fy14_count__c) fy14Count,sum(fy15_count__c) FY15Count, 
		                sum(fy16_count__c) FY16Count
		                
		                from case
		    where fy_actual__c != null and isclosed = true
 		    group by calendar_month(closeddate), fiscal_month(closeddate) order by fiscal_month(closeddate)  asc ];

 

 
		List<Data> dataList = new List<Data>();
	
	
	   for(Integer x=0; x< caseList.size(); x++ ){
 	               datalist.add(new Data(
	                                String.valueof(caseList[x].get('pmonth')), 
	                                Integer.valueof(caseList[x].get('fy14Count')), 
			                        Integer.valueOf(caseList[x].get('fy15Count')),
			                        Integer.valueOf(caseList[x].get('fy16Count'))
								));
								System.debug(String.valueof(caseList[x].get('pmonth')) + ', ' +
	                                Integer.valueof(caseList[x].get('fy14Count')) + ', ' + 
			                        Integer.valueOf(caseList[x].get('fy15Count')) + ', ' +
			                        Integer.valueOf(caseList[x].get('fy16Count')));
	       }
	       
        return dataList;
    }  
    
      @RemoteAction   
    global static List<Data> loadAvg() {
		List<AggregateResult> caseList  = [select calendar_month(closeddate) pmonth, 
		                avg(fy14_avg__c) fy14avg, avg(fy15_avg__c) fy15avg, avg(fy16_avg__c) fy16avg
		                
		                from case
		    where fy_actual__c != null and isclosed = true and Case_Age_In_Business_Hours__c > 0.000 
 		    group by calendar_month(closeddate), fiscal_month(closeddate) order by fiscal_month(closeddate)  asc ];

 

 
		List<Data> dataList = new List<Data>();
	
	
	   for(Integer x=0; x< caseList.size(); x++ ){
 	               datalist.add(new Data(
	                                String.valueof(caseList[x].get('pmonth')), 
	                                Integer.valueof(caseList[x].get('fy14avg')), 
			                        Integer.valueOf(caseList[x].get('fy15avg')),
			                        Integer.valueOf(caseList[x].get('fy16avg'))
								));
								System.debug(String.valueof(caseList[x].get('pmonth')) + ', ' +
	                                Integer.valueof(caseList[x].get('fy14avg')) + ', ' + 
			                        Integer.valueOf(caseList[x].get('fy15avg')) + ', ' +
			                        Integer.valueOf(caseList[x].get('fy16avg')));
	       }
	       
        return dataList;
    }  
 
 
    
}