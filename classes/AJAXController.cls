/** AJAXController is used by the Launchpad_datatable page. It contains global variables
  * and methods required to provide functionality to the launchpad. 
  * @author: Matthew Bald
  *
  * Edited by Mike McGee on 09/10/2015 to remove case shuffling 
  *
  */
global with sharing class AJAXController {
  
   transient public String JSONString {get; set;}
    public static String JSONString_Activities {get; set;}
    public String JSONString_CaseChart {get; set;}
    
  public String objId {get; set;}
  public String objType {get; set;}
  public String userName {get; set;}
    
    public Integer in_PC {get; set;}
    public Integer unaC {get; set;}
    public Integer promoC {get; set;}
    
    public Boolean userUpdatedStatus {get; set;}
    public Boolean userStatus {get; set;}
    
    //public static Boolean userIsChangingStatus {get; set;}
    
    public static Case_Allocator shuffler {get; set;}
    
    /** Constructor for the Launchpad_Controller. Populates the class'
    * variables that provide information for the CRT user.
    * @author: Matthew Bald
    */
  public AJAXController() {
    
    userName = System.UserInfo.getUserID();
    
    User curUser = [select Id, available__c from User where Id = :userName];
    
    userStatus = curUser.available__c;
        //userIsChangingStatus = false;
        //userUpdatedStatus = true;
        retrieveData();
    constructCaseChartJSON_Inverted();
  }


  /**
   * Constructor for next case method 
   */
  public AJAXController(String userId) {
     userName = userId;
  }
  
  @RemoteAction
  global static void updateCaseAges() {
    Case_Updater case_Age_Updater = new Case_Updater();
    case_Age_Updater.updateCaseObjects();
  }
  //public void checkUserStatusHistories() {
    //userUpdatedStatus = true;
    /*
    UserStatusHistory__c lastStatusChange = [select createdDate, createdBy.Id from UserStatusHistory__c order by createdDate desc limit 1];
    
    if (DateTime.now().getTime() - lastStatusChange.createdDate.getTime() < 120000) {
      userUpdatedStatus = 'true';
      return;
    }
    
    else 
      userUpdatedStatus = 'false';
    */
  //}
  
  public void checkUserIn() {
    //userIsChangingStatus = true;
    // Set user checked in flag to true
    User currentUser = [select Id, available__c from User where Id = :userName];
    currentUser.available__c = true;
    update currentUser;
    userStatus = true;
    
    //Insert new UserStatusHistory to DB
    //UserStatusHistory__c hist = new UserStatusHistory__c();
    //insert hist;
    
    //Create and insert a request object
    //Allocator_Timestamp__c timestamp = new Allocator_Timestamp__c();
    //insert timestamp;
    
    // Run case shuffler
    /*
     * Edited to remove case shuffling by Mike McGee on 09/10/2015
     */
    // shuffler = new Case_Allocator(); 
    //shuffler.reshuffleCases();
    //userIsChangingStatus = false;
    retrieveData(); // refresh the JSON string
  }
  
  public void checkUserOut() {
    //userIsChangingStatus = true;
    // Set user checked in flag to false
    User currentUser = [select Id, available__c from User where Id = :userName];
    currentUser.available__c = false;
    update currentUser;
    userStatus = false;
    
    // Run case shuffler
    /*
     * Edited to remove case shuffling by Mike McGee on 09/10/2015
     */
    // shuffler = new Case_Allocator(); 
    //shuffler.reshuffleCases();
    //shuffler.submitRequest();
    //userIsChangingStatus = false;
    retrieveData(); // refresh the JSON string
    retrieveActivitiesData(); 
  }
  
  /*completeEvent marks completed flag of event passed in
    and refreshes list of events 
    @params: Id of Event that was selected 
    @returns: void
    @author Mike McGee 
    */
    @RemoteAction
    global static void completeEvent(String eventId)
    {
      //mark flag completed for event with id eventID
      //refresh list of events 
      Event currentEvent = [select Completed__c from Event WHERE Id = :eventId];
      currentEvent.Completed__c = true; 
      update currentEvent; 
    
    retrieveActivitiesData(); //update JSONString_Activities
    }
    
  
  /*
  public void setCaseInProgress() {
    Case caseObj = [select Id, Status, OwnerId from Case where Id = :objId limit 1];
    
    if (caseObj.Status == 'Unassigned' && caseObj.OwnerId == userName) {
      caseObj.Status = 'In Progress';
      update caseObj;
    }
  }
  */
  /** findNextCaseUnassigned returns a PageReference for a VisualForce commandButton.
    * The PageReference will redirect the User clicking the button to the Case detail 
    * page for the case returned by getNextUnassigned().
    * @params: none
    * @returns: PageReference
    * @author: Matthew Bald
    */
    public PageReference findNextCaseUnassigned() {
      Case nextCase = null; 
      Case caseCheck = null;
      PageReference pRef = null;
      if(nextCase != null){
      //System.debug('STARTING XOXOXOXOXOX    >>' );

      }
        //System.debug([select count(id) from casehistory where caseid = :nextcase.Id]);
      
      nextCase = getNextUnassigned();
      
      //System.debug([select count(id) from casehistory where caseid = :nextcase.Id]);
      
      //System.debug([select Id, OwnerId, Status from Case where Id = :nextCase.id]);      
   
      if (nextCase != null) {
 
        pRef = new ApexPages.StandardController(nextCase).view();
        System.debug('Page reference is: '+pRef);
        pRef.setRedirect(true);
      }
      
      
      
      return pRef;
    }
    
    /** getNextUnassigned returns the next highest priority Case that is not closed
      * and is not yet owned by a User.
      * @params: none
      * @returns: Case object
      * @author: Matthew Bald
      */
    //public Case getNextUnassigned() {
    //  Case nextCase = null;
    //  String nId; 
      
    //  try {
    //      // Select most important case, locking it from being edited by others.                                      
    //      nId = [SELECT Id, OwnerId, Status from Case WHERE Status = 'Unassigned' AND isClosed = false 
    //                  ORDER BY Priority, CRDate__c limit 1].Id;
    //      nextCase = [SELECT Id, OwnerId, Status FROM Case WHERE Id =: nId FOR UPDATE]; 
    //    } catch (Queryexception e) {
    //      // No cases in DB 
    //    }
       
    //  if (nextcase != null) {
    //    //nextCase.OwnerId = userName; // assign the case to the user
    //    nextCase.Status = 'In Progress';
    //    nextCase.OwnerId = System.UserInfo.getUserId(); 
    //    nextCase.maxDate__c = DateTime.now();
    //    nextCase.CRT_Review_DT__c = DateTime.now();
    //    update nextCase;
    //  }
      
             
    //  return nextCase;
    //}  


    /**
     * Retreives next unassigned case while assuring that two users cannot 
     * select same case 
     * @return the next highest priority unassigned case. 
     */
    public Case getNextUnassigned() {
        //Get lock map
        Map<String, Selecting__c> selectMap = Selecting__c.getAll();
        // Test if another user is currently selecting. 
        if (selectMap.get('Selecting').inProgress__c == true) {
            system.debug('someone else was selecting');
            return getNextUnassigned();
        } else {
            system.debug('Noone else was selecting, you are selecting a case. ');
            // Lock selecting lock
            Selecting__c s = selectMap.get('Selecting'); 
            s.inProgress__c = true; 
            update s; 
            // get the next highest priority case
            Case nextCase = getNextCase();  
            system.debug('User '+System.UserInfo.getUserId()+' received case :'+nextcase.Id);
            // Free selecting lock
            s.inProgress__c = false; 
            update s; 

            return nextCase; 
        }
    }

    /**
     * Returns the next highest priority case. 
     * @return the next highest priority case.
     */
    public Case getNextCase() {
        Case nextCase = null;
        String nId; 
      
        try {
            // Select most important case, locking it from being edited by others.                                      
            nId = [SELECT Id, OwnerId, Status from Case WHERE Status = 'Unassigned' AND isClosed = false 
                          ORDER BY Priority, ContactCount__c, CRDate__c limit 1].Id;
            nextCase = [SELECT Id, OwnerId, Status FROM Case WHERE Id =: nId FOR UPDATE]; 
        } catch (Queryexception e) {
              // No cases in DB 
        }
           
        if (nextcase != null) {
            //nextCase.OwnerId = userName; // assign the case to the user
            nextCase.Status = 'In Progress';
            nextCase.OwnerId = System.UserInfo.getUserId(); 
            nextCase.maxDate__c = DateTime.now();
            nextCase.CRT_Review_DT__c = DateTime.now();
            update nextCase;
        }
          
                 
        return nextCase;
    }

    
    /** getPageRef returns a page reference to a clicked Case, Task, or Event depending on 
     *  the global variables objID and objType. When returned to an Apex ActionFunction,
     *  it will cause the actionFunction to redirect the user to the case/activity clicked
     *  @params: objID is the Id of the task/event clicked and the Case Number for the case clicked
     *            objType is a string that can either be 'Case' or 'Activity' 
     *  @returns a PageReference with redirect set to true
     *  @author: Matthew Bald
     */
  public PageReference getPageRef() {
    PageReference ref = null;
    
    if (objType == 'Case') {
      Case caseClicked = null;
          
      try {
        caseClicked = [select Id, OwnerId, CaseNumber, Status from Case where CaseNumber = :objId];
        
        if (caseClicked.Status == 'Unassigned' && caseClicked.OwnerId == userName) {
          caseClicked.Status = 'In Progress';
          caseClicked.CRT_Review_DT__c = DateTime.now();
          //caseClicked.OwnerId = userName;
          caseClicked.maxDate__c = DateTime.now();
          update caseClicked;
        }
        
      }
      catch (QueryException e) {
        // no case found
      }
      
      if (caseClicked != null) {
        //ref = new ApexPages.StandardController(caseClicked).view();
        ref = new PageReference('/'+caseClicked.Id);
        ref.setRedirect(true);
        return ref;
      }
    }
    
    else if (objType == 'Activity') {
      
      
      Task taskClicked = null;
      
      try {
        taskClicked = [select Id from Task where Id = :objId];
      }
      catch (Queryexception e) {
        // no task found, look for event
      }
      
      if (taskClicked != null) {
        //ref = new ApexPages.StandardController(taskClicked).view();
        ref = new PageReference('/'+taskClicked.Id);
        ref.setRedirect(true);
        return ref;
      }
      
      
      Event eventClicked = null;
      
      try {
        eventClicked = [select Id from Event where Id = :objId];
      }
      catch (Queryexception e) {
        // no event found, return null
      }
      
      if (eventClicked != null) {
        //ref = new ApexPages.StandardController(eventClicked).view();
        ref = new PageReference('/'+eventClicked.Id);
        ref.setRedirect(true);
      }
    }
    return ref;
  }
  
  /** retrieveData refreshes the JSONString global field. It queries the database for case data
   *  and constructs a JSON object using the JSON Generator class
   *  @params: none
   *  @returns: none
   *  @author: Matthew Bald
   */
  public void retrieveData() {  
  
    Case_JSON_Generator caseGenerator = new Case_JSON_Generator();
    
    JSONString = caseGenerator.gen_JSON();
    
  }
  
  /** retrieveActivitiesData refreshes the JSONString_Activities global field.
   *  It queries the database for case data and constructs a JSON object using
   *  the JSON Generator class
   *  @params: none
   *  @returns: none
   *  @author: Matthew Bald
   */
  public static void retrieveActivitiesData() {
    
    Activities_JSON_Generator activityGenerator = new Activities_JSON_Generator();
    
    JSONString_Activities = activityGenerator.retrieveActivitiesData();
  }
  
  public void constructCaseChartJSON_Inverted() {
    
    Dash_JSON_Generator dash = new Dash_JSON_Generator();
    
    JSONString_CaseChart = dash.gen_Dash_JSON_Pivoted();
    
    in_PC = dash.get_Progress_Count();
    unaC = dash.get_Unassigned_Count(); 
    promoC = dash.get_Promoted_Count(); 
    
  }
  
}