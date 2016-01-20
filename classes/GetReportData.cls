public class GetReportData {
// Get the report ID
List <Report> reportList = [SELECT Id,DeveloperName FROM Report where 
    DeveloperName = 'Qfiniti_Summary'];
String reportId = (String)reportList.get(0).get('Id');

// Run a report synchronously
Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);

// Get the first down-grouping in the report
Reports.Dimension dim = results.getGroupingsDown();
Reports.GroupingValue groupingVal = dim.getGroupings()[0];
     
 
 
// Construct a fact map key, using the grouping key value
String factMapKey = groupingVal.getKey() + '!T';

// Get the fact map from the report results
Reports.ReportFactWithDetails factDetails =
    (Reports.ReportFactWithDetails)results.getFactMap().get(factMapKey);

// Get the first summary amount from the fact map
    public  Reports.SummaryValue getSummaryValue(){
        Reports.SummaryValue sumVal = factDetails.getAggregates()[0];
        return sumVal ;
    }

    
 

// Get the field value from the first data cell of the first row of the report
Reports.ReportDetailRow detailRow = factDetails.getRows()[0];
 
}