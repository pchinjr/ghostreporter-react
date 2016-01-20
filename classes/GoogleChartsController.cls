global with sharing class GoogleChartsController {
    	
	public List<AggregateResult> data{get;set;}
	public Integer dataSize{get;set;}

    public GoogleChartsController() {
    	// testing with only the number of cases closed per fiscal yeat.
    	this.data = [select calendar_month(closeddate) pmonth, fy_actual__c, count(id) ccount from case
		    where fy_actual__c != null and isclosed = true
 		    group by calendar_month(closeddate), fy_actual__c, fiscal_month(closeddate) order by fiscal_month(closeddate)  asc];

 		this.dataSize = data.size();
    } 
}