public with sharing class GetReportData2 {
  

  

    public List<SelectOption> availableReports { get; set; }
    public Id reportId { get; set; }
    public Id instanceId { get; set; }
    public Boolean reportIsRunning { get; set; }
    private transient Reports.ReportResults reportResults;
        
List <Report> reportList = [SELECT Id,DeveloperName FROM Report where 
    DeveloperName = 'IVR_Offering_Choices'];
    //reportId = (String)reportList.get(0).get('Id');  
        
        
    public GetReportData2() {
        availableReports = retrieveAvailableReports();
    }

    public List<SelectOption> retrieveAvailableReports() {
        List<SelectOption> reptOpts = new List<SelectOption>();
        for (Report r : [
             Select Id, Name
             From Report
             Where Format = 'Tabular'
             Order By Name
        ]) {
            reptOpts.add(new SelectOption(r.Id, r.Name));
        }
        return reptOpts;
    }

    public PageReference runReport() {
        Reports.ReportInstance reportInstance = Reports.ReportManager.runAsyncReport(reportId, true);
        instanceId = reportInstance.getId();
        processInstance(reportInstance);

        return null;
    }

    public PageReference checkForReportResults() {
        Reports.ReportInstance reportInstance = Reports.ReportManager.getReportInstance(instanceId);
        processInstance(reportInstance);

        return null;
    }

    private void processInstance(Reports.ReportInstance reportInstance) {
        reportIsRunning = reportInstance.getStatus() == 'Running' || reportInstance.getStatus() == 'New';
        if (!reportIsRunning) {
            reportResults = reportInstance.getReportResults();
        }
    }

    public Reports.ReportResults getReportResults() {
        return reportResults;
    }
}