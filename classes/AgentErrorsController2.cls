/** 
* Controller for AgentErrors page. 
* <p>
* Initiates all actions necessary in creating new AgentErrors object. 
* Also initializes process to create necessary Error objects which will be
* used in reporting. 
*
* @author Mike McGee 
*/
public with sharing class AgentErrorsController2 {
    public static AgentErrors__c staticErrors{get;set;}
    /** sf_uniqueId for selected agent */ 
    public transient String selectedAgentName{get;set;}
    
    /** The AgentErrors that will be used in the print query */
    public AgentErrors__c printErrors{get;set;}

    /** The new AgentErrors object that will be inserted on save */
    public AgentErrors__c agentErrors{get;set;}

    /** ErrorWrapper lisy to hold errors that need to be entered **/
    public static List<ErrorWrapper> errors{get;set;}

    /** List of email error fields */
    private static List<Schema.DescribeFieldResult> emailErrors;

    /** List of non email error fields */
    private static List<Schema.DescribeFieldResult> nonEmailErrors;

    /** Agent errors custom setting map, holds point per click value */
    private static Map<String, AgentErrorsCS__c> errorsMap = AgentErrorsCS__c.getAll();  
    
    /** The running count of errors created, used as unique Id */
    private static Integer errorCount;

    /** The link to the qm folder */
    public String qmFolderLink {
        get {
            return Links__c.getAll().get('QMFolder').QualityManagementFolder__c;
        } 
    } 

    /**
     * Empty constructor that executes on page load. Used to set
     * up any necessary information on page load. 
     */
    public AgentErrorsController2() {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10');
        agentErrors = new AgentErrors__c(); 
        printErrors = new AgentErrors__c(); 
        setErrorFields(); 
        getErrors(false); 
    }

    /**
    * Returns agent select list.
    * @return agent select list
    */
    public List<SelectOption> getAgentSelectList() {
        system.debug('getAgentSelectList was called');
        List<AgentTeam__c> agentList = [SELECT Id, PSERMID__c, isActive__c, fullName__c from AgentTeam__c 
                                         WHERE IsActive__c = true ORDER BY fullName__c ASC NULLS LAST]; 
        List<SelectOption> selectList = new List<SelectOption>(); 
        //Place default in list
        selectList.add(new SelectOption('Empty', 'Select Agent', true));
        for (AgentTeam__c a: agentList) {
            selectList.add(new SelectOption(a.PSERMID__c, a.fullName__c));
        }

        return selectList;
    }


    /**
     * onClick for isEmail checkbox on AgentErrors page. 
     * <p> will update the error list according to the 
     * value of the checkbox passed in from the page. 
     * @param   isEmail is email agent or not. 
     */
    @RemoteAction
    public static void getErrors(boolean isEmail) {
        setErrorFields(); 
        if (errors == null) {
            errors = new List<ErrorWrapper>(); 
        }
        errors.clear();
        if (isEmail) {
            for (Integer i = 0, j = emailErrors.size(); i < j; ++i) {
                errors.add(new ErrorWrapper(emailErrors[i].getName(), 
                    emailErrors[i].getLabel(), errorsMap.get(emailErrors[i].getName()).PointsPerClick__c));
            }
        } else {
             for (Integer i = 0, j = nonEmailErrors.size(); i < j; ++i) {
                if (errorsMap == null) system.debug('What is happening');
                if (nonEmailErrors == null) system.debug('nonEmailErrors is null now ?');
                errors.add(new ErrorWrapper(nonEmailErrors[i].getName(), 
                    nonEmailErrors[i].getLabel(), errorsMap.get(nonEmailErrors[i].getName()).PointsPerClick__c));
            }
        }

        system.debug('Errors are now: '+errors);
    }

    /**
     * Sets errors based off of the value in the page for isEmail. 
     */
    public static void setErrors() {
        Boolean isEmail = Boolean.valueOf(ApexPages.currentPage().getParameters().get('isEmail'));
        getErrors(isEmail);
    }

    /**
     * Sets the global variables emailErrors and nonEmailErrors
     * <p>
     * Gets all fields in the AgentErrors object, then filters to
     * only the fields that are of type Double or Integer. If the 
     * remaining fields start with 'Email_' they are added to the 
     * emailErrors list, otherwise they are added to the 
     * nonEmailErrors list. 
     */
    private static void setErrorFields() {
        system.debug('Entered setErrorFields');
        if (nonEmailErrors == null || emailErrors == null) {
            nonEmailErrors = new List<Schema.DescribeFieldResult>(); 
            emailErrors = new List<Schema.DescribeFieldResult>(); 
            // Get list of fields on AgentErrors objetc. 
            for (Schema.SObjectType s : Schema.getGlobalDescribe().values()) {
                system.debug(s);
            }
            sObjectType oType = Schema.getGlobalDescribe().get('AgentErrors__c'); 
            List<Schema.sObjectField> fields = oType.getDescribe().fields.getMap().values();
            for (Integer i = 0, j = fields.size(); i < j; ++i) {
                if (fields[i].getDescribe().Type == DisplayType.Double ||
                     fields[i].getDescribe().Type == DisplayType.Integer ) {
                    if (fields[i].getDescribe().getName().startsWithIgnoreCase('Email') && !fields[i].getDescribe().getName().containsIgnoreCase('Total')) {
                        emailErrors.add(fields[i].getDescribe());
                    } else if (!fields[i].getDescribe().getName().containsIgnoreCase('Total') && !fields[i].getDescribe().getName().containsIgnoreCase('Ratio') &&
                        !fields[i].getDescribe().getName().containsIgnoreCase('Accuracy')){
                        nonEmailErrors.add(fields[i].getDescribe());
                    }
                } 
            }
        } 
    }
    
    /**
     * Inserts the AgentError object after attaching all of the fields to it. 
     * <p> In order for this insert to work properly all of the agents that are in
     * the AgentTeam object must also be in the Agent object. 
     * 
     * @param values the list of values input by the user
     * @param names the list of error names 
     * @param agentId the PSERMID of the agent who will be attached as parent
     * @param dateString the string representing the date for the object (needs to be parsed)
     * @param comments the comments written to the object
     * @param agetnType the type of agent selected by the user
     * @param isEmail is email agent or not. 
     * @return the name of the parent agent. 
     */ 
    @RemoteAction
    public static String save(List<Integer> values, List<String> names, String agentId, String dateString, String comments, String agentType, Boolean isEmail, String reviewer) {
        // Attach all of the errors to the AgentErrors object. 
        AgentErrors__c agentErrors = new AgentErrors__c();
        agentErrors.Comments__c = comments; 
        try {
            agentErrors.Reviewer__c = [SELECT Id from User WHERE Name = :reviewer limit 1].Id;
        } catch (System.QueryException e) {}
        
        // Make date object 
        Integer month = Integer.valueOf(dateString.substringBefore('/'));
        Integer day = Integer.valueOf(dateString.substringBetween('/', '/'));
        Integer year = Integer.valueOf(dateString.substringAfterLast('/'));
        agentErrors.Date__c = Date.newInstance(year, month, day);
        // Loop through setting errors name and values
        for (integer i = 0, j = values.size(); i < j; ++i) {
            agentErrors.put(names[i], values[i]);
        }
        // Look up agent to attach errors to. 
        AgentTeam__c parent = [SELECT Id from AgentTeam__c WHERE PSERMID__c =:agentId limit 1];  
        parent.AgentType__c = agentType; 
        agentErrors.Agent__c = parent.Id;                       
        
        // Insert AgentErrors object. 
        insert agentErrors; 
        
        //need to insert all Error objects for reporting
        insertErrors(agentErrors);
            
        return parent.fullName__c; 
         
    }
    
    /**
     * Creates error objects for all of the errors that were input to the AgentErrors objetc. 
     * inserts all of the object with the AgentErrors object as the parent. 
     * Used for reporting purposes
     * 
     * @param agentErrors the agent errors object to attach as parent and use to create error objects. 
     */
    public static void insertErrors(AgentErrors__c agentErrors) {
        List<Error__c> errorList = new List<Error__c>(); 
        setErrorFields();
        // Loop through all error fields on object and create new error object for each
        Error__c tempError;
        for (Integer i = 0, j = nonEmailErrors.size(); i < j; ++i) {
            Object oVal = agentErrors.get(nonEmailErrors[i].getName());
            if (oVal != null) {
                tempError = new Error__c(); 
                tempError.put('Name__c', nonEmailErrors[i].getLabel());
                tempError.put('Value__c', Integer.valueOf(oVal));
                tempError.AgentErrors__c = agentErrors.Id; 
                errorList.add(tempError); 
            }
        }
        
        for (Integer i = 0, j = emailErrors.size(); i < j; ++i) {
            Object oVal = agentErrors.get(emailErrors[i].getName());
            if (oVal != null) {
                tempError = new Error__c(); 
                tempError.put('Name__c', emailErrors[i].getLabel());
                tempError.put('Value__c', Integer.valueOf(oVal));
                tempError.AgentErrors__c = agentErrors.Id; 
                errorList.add(tempError); 
            }
        }
        
        insert errorList; 
    }
    
    /**
     * Sets the agentErrors member object to the agent that is being printed. 
     */
    @RemoteAction
    public static AgentErrors__c getNewErrors (String selectedAgentName, String datePicked) {
        system.debug('date picked = '+datePicked);
        Date pickedDate = Date.parse(datePicked); 
        QueryManager qm = new QueryManager(); 
        String queryString = qm.buildFilterlessQuery('AgentErrors__c');
        DateTime filterDate = DateTime.newInstance(pickedDate, Time.newInstance(0, 0, 0, 0));
        queryString += ' WHERE Agent__r.PSERMID__c ='+'\''+selectedAgentName+ '\' AND Date__c = '+filterDate.format('yyyy-MM-dd') +' LIMIT 1'; 
        AgentErrors__c printErrors; 
        try {
            printErrors = Database.query(queryString);
        } catch (System.QueryException e) {
            system.debug('No AgentErrors objects for specified parameters.');
            printErrors = null; 
        }
        system.debug('The printerrors agent is: '+printErrors);
        return printErrors;
    }

    /************************************************************************
     * Inner class to wrap errors
     * <p> Used to dynamically create list of errors to be displayed
     * in table on controller, list is created based off of isEmail boolean
     * 
     ************************************************************************/ 
    public class ErrorWrapper {
        
        /** Name of the error */
        public String name{get; private set;}

        /** Vallue of the error */
        public Integer value{get;set;}

        /** The name to display to the user */
        public String displayName{get; private set;}

        /** Number of points to add per click */
        public Integer pointsPerClick{get; private set;}
        
        /** The identifying Id for the error (Can't use Id becuse it is salesforce reserved)*/
        public Integer ident {get; private set;}

        public ErrorWrapper(String name, String displayName, Decimal pointsPerClick) {
            if (errorCount == null) {
                errorCount = 1; 
            } else {
                errorCount++; 
            }
            this.name = name; 
            this.displayName = displayName; 
            this.pointsPerClick = Integer.valueOf(pointsPerClick);
            this.ident = errorCount; 
        }
    }
}