public class CurrentCase {
    private ApexPages.StandardController acontroller {get; set;}
      
    public List<EmailMessage> emails {get;set;}
      
      
    public String caseid {get;set;}

    private String caseNumber;

    public CurrentCase(ApexPages.StandardController controller){
        this.caseid = ApexPages.currentPage().getParameters().get('id');
         
        this.emails = [select id, MessageDate, subject, status, FromAddress,
                        ToAddress,
                        FromName from EmailMessage where parentid = :caseid
                        ORDER BY MessageDate DESC];
        
        this.caseNumber =
            [SELECT Id, CaseNumber FROM Case WHERE Id = :this.caseId].CaseNumber;
    }


    public CurrentCase() {
        caseid = ApexPages.currentPage().getParameters().get('id');
    }

    /**
     * Loads CRTEmailPage with parameter related_case
     */
    public PageReference newEmail() {
        PageReference emailPage = new PageReference('/apex/CRTEmailPage');
        emailPage.getParameters().put('related_case', this.caseNumber);
        emailPage.getParameters().put('retURL', '/apex/Case_Emails_Page?id='+this.caseid);
        return emailPage;
    }


    /**
     * Loads CRTEmailPage with parameter related_case
     */
    public PageReference replyAll() {
        PageReference emailPage = new PageReference('/apex/CRTEmailPage');
        emailPage.getParameters().put('related_case', this.caseNumber);
        emailPage.getParameters().put('retURL', '/apex/Case_Emails_Page?id='+this.caseid);
        emailPage.getParameters().put('includes', 'true');
        return emailPage;
    }

}