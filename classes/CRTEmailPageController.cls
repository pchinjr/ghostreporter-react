/**
 * Controller for CRTEmailPage. 
 * Controls sending of emails for the related cases.
 * 
 * @author Mike McGee
 */
public with sharing class CRTEmailPageController {
    
    /** List of email addresses that can be used in from line */
    private transient List<String> fromList;

    /** The object that the email is related to */
    public Case relatedCase{get;set;}


    /** The address to send the email from. Is set in select list */
    public String fromAddress{get;set;}


    /** The list of users emails to be BCC'd */
    public List<String> bccList{get;set;}


    /** String containing list of email address to bcc, seperated by ';' */
    public String bccString{get;set;}


    /** The list of user emails to be CC'd */
    public List<String> ccList{get;set;}


    /** String containing list of email addresses to cc, seperated by ';' */
    public String ccString{get;set;}


    /** String of additional emails to send to. Will need to be seperated 
        by commas 
    */
    public String additionalTo{get;set;} 


    /** The email subject line*/
    public String emailSubject{get;set;}


    /** The body of the email */
    public String emailBody{get;set;}


    /** The history of emails sent related to the working case */
    public String emailHistory{get;set;}


    /** attached files to add to the email message */
    public Document attachedBlob{get;set;}

    /** The names of the files attached to the message seperated by ; */
    public String attachedFileNames{get;set;}

    /** List of Documents to attach to email */
    private List<Id> attachedDocIds = new List<Id>();

    private Set<String> prevCcList = new Set<String>();

    private Set<String> prevToList = new Set<String>();

    /** Email message that will be sent. */
    @TestVisible
    private transient Messaging.SingleEmailMessage email;


    /**
     * Default constructor that runs on page load. 
     * Calls methods to create the list of from addresses, get the case object 
     * that the query is related to from the page parameters, creates the 
     * email subject line based off of information from the related case, and 
     * fills the email body with the history of emails related to the case 
     * object.
     */
    public CRTEmailPageController() {
        this.attachedBlob = new Document();
        createFromList();
        setRelatedCase();
        buildEmailSubject();
        //buildEmailBody(); 
        buildEmailHistory();

        // If this is a reply all then add all previous cc and toAddress to
        this.ccString = '';
        this.additionalTo = '';
        if (ApexPages.currentPage().getParameters().get('includes') != null) {
            for (String cc: this.prevCcList) {
                this.ccString += cc+';';
            }

            for (String to: this.prevToList) {
                this.additionalTo += to+';';
            }
        }

        // Initiate email body to what was requested by Nadime
        if (ApexPages.currentPage().getParameters().get('isClosing') == 'true') {
            this.emailBody = System.UserInfo.getName() + ' has closed case #'+
                relatedCase.CaseNumber + ' for customer '+
                relatedCase.Customer_Name__c + '. Below are the details:\n'+
                '\n\n\n';
                
                
        this.emailBody += 'Sincerely,\n'+this.relatedCase.Owner.name+'\n'+
            'Customer Resolution Advocate\nOrlando Utilities Commission\n\n'+
            
            'Typical resolution time is between 24-48 hours;Office hours are 8 am to 5 pm Mon-Fri';
        } else {
            this.emailBody = 'The following is an update to case #'+
                relatedCase.CaseNumber+ ' for customer '+
                relatedCase.Customer_Name__c +'.'+'\n\n\n';
                
        this.emailBody += 'Sincerely,\n'+this.relatedCase.Owner.name+'\n'+
            'Customer Resolution Advocate\nOrlando Utilities Commission\n\n'+
            
            'Typical resolution time is between 24-48 hours; office hours are 8 am to 5 pm Mon-Fri';
                
        }

       
 
    }



    /**
     * Builds email and sends it to the list of addresses specified by the User.
     * 
     * The list of CCd addresses will include Terry Torres if the severity of
     * the case is severe and will include Nadime Nader if the severity of the
     * case is High or Severe. 
     * 
     * The AdditionalTo addresses must be written as a list of semicolon 
     * seperated strings in order to be properly parsed. 
     * 
     * The from email field will automatically be that of the user who is 
     * editing the email, unless the user selects otherwise. 
     * The only way for the email to be 'from' any other user is to set the
     * organizational wide default email address to a different email address
     * and the only way to do this is if that email address was addded as as an 
     * organizational wide email address by the system admin 
     * (Setup->Email Administration->Organization-Wide Address Menu)
     */
    public PageReference sendEmail() {
        // Build email
        this.email = new Messaging.SingleEmailMessage();

        // If user selected CRT@ouc.com then set organizational address.
        if (this.fromAddress == null || 
                this.fromAddress.equalsIgnoreCase('resolution@ouc.com')) {
            OrgWideEmailAddress[] owea = [SELECT ID FROM OrgWideEmailAddress 
                                         WHERE Address = 'resolution@ouc.com'];
            this.email.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        // Get list of addresses to attach to message. 
        List<String> addresses = new List<String>();
        // If case has a supplied email then place in the additonal to box.
        // Requested by Alex Rivera and Melinda Lopez on 01/14/2016
        // Added on the same day
        if  (this.relatedCase.SuppliedEmail != null) {
            addresses.add(this.relatedCase.SuppliedEmail);
        }
        if (relatedCase.Contact.Email != null) {
            addresses.add(relatedCase.Contact.Email);
        }
        String[] additionalAddresses = this.additionalTo.split(';');
        for (String s: additionalAddresses) {
            if (s.equalsIgnoreCase('')) {
                continue;
            }
            addresses.add(s);
        }


        system.debug('Sending emails to: '+addresses);

        // Get list of bcc and cc addresses deliminated by ';'
        if (this.ccString == null) {
            this.ccString = '';
        }
        this.ccList = this.ccString.trim().split(';');
        for (Integer i = 0; i < ccList.size(); ++i) {
            if (ccList[i] == '') {
                ccList.remove(i);
            }
        }

        if (this.bccString == null) {
            this.bccString = '';
        }
        this.bccList = this.bccString.trim().split(';');
        for (Integer i = 0; i < bccList.size(); ++i) {
            if (bccList[i] == '') {
                bccList.remove(i);
            }
        }

        // If the case is a severe case then BCC Terry and Nadime
        if (this.relatedCase.Priority == 'Severe') {
            //String[] aliasList = new List<String>{'torr', 'nade'};
            List<User> terryAndNadime = [SELECT Email FROM User 
                                        Where getSevereAlert__c = true];
            for (User u: terryAndNadime) {
                bccList.add(u.Email);
                ccList.add(u.Email);
            }
        }

        // Set up rest of email
        this.email.setSubject(this.emailSubject);
        this.email.setToAddresses(addresses);
        this.email.setPlainTextBody(this.emailBody+'\n'+this.emailHistory);
        if (!ccList.isEmpty()) {
            System.debug('cc list is '+ccList);
            this.email.setCcAddresses(ccList);  
        }
        
        if (!bccList.isEmpty()) {
            System.debug('bcc list is '+bccList);
            this.email.setBccAddresses(bccList);    
        }
        

        // Attach all documents to email 
        // Salseforce API says to use setEntityAttachment(List<String>)
        // method but it is not allowing it right now for some reason. 
        // Instead using deprecated setDocumentAttachments(ID[])
        //this.email.setEntityAttachments(this.attachedDocIds);
        if (!this.attachedDocIds.isEmpty()) {
            this.email.setDocumentAttachments(this.attachedDocIds);
        }

        // Send the email
        Messaging.SendEmailResult[] result = new List<Messaging.SendEmailResult>();
        try {
         result = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {this.email});
        } catch (EmailException e) {
            String errorMessage;
            if (addresses.isEmpty()) {
                errorMessage = 'Make sure that a "To Address" or "Additional To" is present';
            } else {
                errorMessage = e.getMessage();
            }
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
        }

        for (Messaging.SendEmailResult res: result)  {
            if (!res.isSuccess()) {
                System.debug(LoggingLevel.ERROR, res.getErrors());
            } 
        }

        // attach email to list of email messages on related case object
        Boolean isValid = true;
        EmailMessage newEmail = new EmailMessage();
        try {
            newEmail.ToAddress = addresses[0];
        } catch (ListException e) {
            isValid = false;
            System.debug(e.getMessage());
        }
        newEmail.FromAddress = System.UserInfo.getUserEmail();
        newEmail.BccAddress = this.bccString;
        newEmail.CcAddress = this.ccString;
        newEmail.MessageDate = Datetime.now();
        newEmail.Subject = this.emailSubject;
        newEmail.TextBody = this.emailBody + '^' ;//<--added carot so that exclude logic will in duphandler will ignore this email
        newEmail.ParentId = this.relatedCase.Id;
        //This is being interpreted as a duplicate email
        if (isValid) {
            insert newEmail;
        }
        

        if (ApexPages.currentPage() == null){
            return null;
        } else if (ApexPages.currentPage().getParameters().get('retURL') == null) {
            return null;
        } else if (ApexPages.currentPage().getParameters()
                                                .get('returnURL') != null) {
            System.debug('Returning to: '+null);
            return null;
        } else {
            System.debug('returning to: '+ApexPages.currentPage().getParameters().get('retURL'));
            return new PageReference(ApexPages.currentPage().getParameters()
                                    .get('retURL'));
        }
    } 



    /**
     *
     */
    public PageReference cancel() {
        if (ApexPages.currentPage() == null) {
            return null;
        }
        
        return new PageReference(ApexPages.currentPage().getParameters()
                                .get('retURL'));  
    }



    /**
     * Removes all Id's from attachedDocIds and clears attachment string.
     */
    public void removeAttachments() {
        attachedDocIds.clear();
        attachedFileNames = null;
    }



    /**
     * Inserts the current document into the database and adds it's Id to the
     * list of Id's to be attached to the email.
     */
    public void insertDoc() {
        if (attachedBlob == null) {
            System.debug('No Idea why the attachedblob is null');
        }
        System.debug('Doc name = '+ attachedBlob.name);
        System.debug('Doc body = '+attachedblob.body);
        this.attachedBlob.FolderId = System.UserInfo.getUserId();
        this.attachedBlob.AuthorId = System.UserInfo.getUserId();
        insert attachedBlob;
        attachedDocIds.add(attachedBlob.id);
        if (attachedFileNames == null){
            attachedFileNames = attachedblob.name+' ; ';
        } else {
            attachedFileNames += attachedblob.name+' ; ';
        }

        attachedblob = new Document();
    }



    /**
     * Builds a list of select options to be used in froms selct list.
     * Select options are built with (value, label)
     * @return list of select options built from fromList. 
     */
    public List<SelectOption> getFromList() {
        List<SelectOption> selectList = new List<SelectOption>();
        if (this.fromList == null) {
            createFromList();
        }
        System.debug('Fromlist size is: '+this.fromList.size());
        for (String s: this.fromList) {
            System.debug('string is: '+s);
            selectList.add(
                new SelectOption(
                    ( s.substring(s.indexOf(':'), s.length()) ), s)
                );
        }

        return selectList;
    }



    /**
     * Builds a list of select options for the potential recipients of the
     * email.
     */
    public List<SelectOption> getRecipientList() {
        List<SelectOption> selectList = new List<SelectOption>();
        // Recipient list will be list of all users.
        List<User> userList = [SELECT Email, Name FROM User ORDER BY Name];
        for (User u: userList) {
            selectList.add(new SelectOption(u.Email, (u.Name+':'+u.Email)));
        }

        return selectList;
    }



    /**
     * Creates the list of possible from addresses.
     * @note In future list can be built from a custom setting.
     */
    private void createFromList() {
        fromList =  new List<String>();
        fromList.add(System.UserInfo.getName()+': '+
                     System.UserInfo.getUserEmail());

        fromList.add('CRT: resolution@ouc.com');
    }



    /**
     * Sets the related object to the parameter that was attached in URL
     * If not parameter was attached then the related object is null.
     */
    private void setRelatedCase() {
        String id = (String.valueOf(ApexPages.currentPage().getParameters()
                                .get('related_case')));

        if (id == null) {
            id = '00200744';
        }

        relatedCase = [SELECT Customer_Name__c, CaseNumber, Status, Subject, 
            ContactId, Contact.Email, Priority, Owner.name, SuppliedEmail,
            (SELECT EmailMessage.TextBody, EmailMessage.FromAddress,
            EmailMessage.MessageDate, EmailMessage.ToAddress, 
            EmailMessage.Subject, EmailMessage.CcAddress FROM Case.EmailMessages
            ORDER BY MessageDate DESC) 
            FROM CASE WHERE CaseNumber = :id];
    }



    /**
     * Builds the email subject line.
     */
    private void buildEmailSubject() {
        System.debug('Page parameters: '+ApexPages.currentPage().getParameters());
        if (ApexPages.currentPage().getParameters().get('isClosing') == 'true') {
            this.emailSubject = 'Case #'+relatedCase.CaseNumber+' for customer '+
            relatedCase.Customer_Name__c+' is now Closed';
        } else {
            this.emailSubject = 'Update to case #'+relatedCase.CaseNumber+
            ' for customer '+relatedCase.Customer_Name__c;
        }
    }



    ///**
    // * Builds email body by attaching previous related emails to the bottom of
    // * the body in the order in which they were received.
    // */
    //public void buildEmailBody() {
    //  emailBody = ' \n\n';
    //  for(EmailMessage em: relatedCase.EmailMessages) {
    //      emailBody += '\n--------------------------------------------------\n';
    //      emailBody += 'From: '+em.FromAddress + '\n';
    //      emailBody += 'Sent: '+em.MessageDate + '\n';
    //      emailBody += 'To: '+em.ToAddress + '\n';
    //      emailBody += 'CC: '+em.CcAddress + '\n';
    //      emailBody += 'Subject: '+em.Subject + '\n\n';
    //      emailBody += em.TextBody + '\n';
    //  }
    //}

    /**
     * Builds email body by attaching previous related emails to the bottom of
     * the body in the order in which they were received.
     */
    public void buildEmailHistory() {
        emailHistory = '';
        for(EmailMessage em: relatedCase.EmailMessages) {
            emailHistory += '\n--------------------------------------------------\n';
            emailHistory += 'From: '+em.FromAddress + '\n';
            emailHistory += 'Sent: '+em.MessageDate + '\n';
            emailHistory += 'To: '+em.ToAddress + '\n';
            emailHistory += 'CC: '+em.CcAddress + '\n';
            emailHistory += 'Subject: '+em.Subject + '\n\n';
            emailHistory += em.TextBody + '\n\n';
            if (em.CcAddress != null) {
                this.prevCcList.add(em.CcAddress);
            }
            if (em.ToAddress != null) {
                this.prevToList.add(em.ToAddress);
            }
        }
    }
}