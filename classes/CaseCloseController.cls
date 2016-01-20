public with sharing class CaseCloseController {
    
    public Case relatedCase{get;set;}

    public PageReference emailPage{get;set;}

    public String retURL{get;set;}

    public String emailPageName{get;set;}

    public String internalComment{get;set;}

    public String currentPage{get;set;}

    public CaseCloseController(ApexPages.StandardController stdController) {
        setRelatedCase(stdController.getRecord().Id);
        setEmailPage();
        this.retURL = ApexPages.currentPage().getParameters().get('retURL');
        this.currentPage = String.valueOf(ApexPages.currentPage().getUrl());
        System.debug('The current page is '+this.currentPage);
    }



    /**
     * Updates the related case object to the fields input by the user.
     */
    public PageReference save() {
        
        // Create new internal comment and attach to case object.
        if (internalComment == null || internalComment.length() > 0) {
            CaseComment intComment = new CaseComment();
            intComment.CommentBody = this.internalComment;
            intComment.ParentId = this.relatedCase.Id;
            insert intComment;
        }

        update this.relatedCase;
        if (this.retURL == null) {
            return null;
        } else {
            return new PageReference(this.retURL);
        }
    }

    /**
     * Returns the user to the page that they were on before.
     */
    public PageReference cancel() {
        if (this.retURL == null) {
            return null;
        } else {
            return new PageReference(this.retURL);
        }
    }

    /**
     * Sets the email page to that
     */
    private void setEmailPage() {
        System.debug('The caseNumber inside of th setEmailPage: '+
                        this.relatedCase.CaseNumber);
        this.emailPage = new PageReference('/CRTEmailPage');
        this.emailPage.getParameters()
            .put('related_case', this.relatedCase.CaseNumber);
        this.emailPage.getParameters().put('retURL', '/');
        this.emailPageName = 'CRTEmailPage?realted_case='+
            this.relatedCase.caseNumber+'&retURL=/';
    }


    /**
     *
     */
    private void setRelatedCase(Id caseId) {
        //String id = (String.valueOf(ApexPages.currentPage().getParameters()
        //                      .get('related_case')));

        String id = caseId;

        if (id == null) {
            id = '00200744';
        }

        system.debug('Id is: '+id);

        this.relatedCase = [SELECT Customer_Name__c, CaseNumber, Status, Subject, 
            ContactId, Contact.Email, Status_Reason__c, AccountId, Reason, closingComment__c,
            (SELECT EmailMessage.TextBody, EmailMessage.FromAddress,
            EmailMessage.MessageDate, EmailMessage.ToAddress, 
            EmailMessage.Subject, EmailMessage.CcAddress FROM Case.EmailMessages
            ORDER BY MessageDate DESC) 
            FROM CASE WHERE Id = :id];

        ApexPages.currentPage().getParameters()
                 .put('related_case', this.relatedCase.caseNumber);
        system.debug('Case number is now: '+this.relatedCase.CaseNumber);

        // Testing if putting isClosing here will work
        ApexPages.currentPage().getParameters().put('isClosing', 'true');
    }

}