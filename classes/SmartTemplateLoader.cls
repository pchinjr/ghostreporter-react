global class SmartTemplateLoader implements Support.EmailTemplateSelector {
 

 // Empty constructor
    global SmartTemplateLoader() {    }
    // The main interface method
    global ID getDefaultEmailTemplateId(ID caseId) {
   
    EmailTemplate et = [SELECT id FROM EmailTemplate WHERE DeveloperName = 'Client_Email'];
 

    // Return the ID of the template selected
    return et.id;
    }
}