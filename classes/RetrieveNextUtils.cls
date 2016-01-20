/** RetrieveNextUtils is used by the next button in a case's detail page.
  * Contains functionality to find the next case needing to be worked.
  * @author: Matthew Bald
  */
global with sharing class RetrieveNextUtils {
  
  /** retrieveNextCase redirects the user to the next case needing to be worked,
    * sets the owner of the case to that user, and sets the status of the new case
    * to 'In Progress'
    * @author: Matthew Bald
    */
    
    webService static Id retrieveNextCase(String userId, String caseId) {
        //Really we're only specifying the user ID for the sake of the test methods
       String uid;
       uid = '12312';//System.UserInfo.getUserId();
        if (userId=='') {
            //Use the currently running user
            userId = userId;
        }
        
        // Case caseObj = getCaseByPriority(caseId);
        Case caseObj = new AJAXController(userId).getNextUnassigned();
        if (caseObj != null) {
          return caseObj.Id;
        }
        
        //if (caseObj!=null) {        
        //    //If we found one, assign it to the current user
        //    //caseObj.OwnerId = userId;
        //    caseObj.Status = 'In Progress';
        //    caseObj.CRT_Review_DT__c = DateTime.now();
        //    update caseObj;
            
        //    return caseObj.Id;
         //}

        return null;
    }
    
    /** getCaseByPriority returns the next highest priority unassigned case that is not closed.
      * @params: String priority: 'High', 'Medium', 'Low' - The priority of case to search for
      *       String caseId: The case number of the current case
      * @returns: Case
      * @author: Matthew Bald
      */
  public static Case getCaseByPriority(String caseId, String userId) {
    
    Case caseObj = null;
    String uid = userId;
    
    try {
      caseObj = [select Id, OwnerId, CaseNumber from Case where IsClosed=false
                                                                and Status = 'Unassigned'
                                                                and OwnerId = :uid
                                                                order by Priority, CRDate__c
                                                                limit 1  ];
              
            if (caseObj != null ) {    
              return caseObj;
            }
            
            else if (caseObj == null) {
              // Problem finding a new case
              Case_Allocator shuffler = new Case_Allocator();
            }
    } 
    
        catch (System.QueryException e) {
          // Problem finding a new case
          Case_Allocator shuffler = new Case_Allocator();
        }
        // no cases found, returns null
    return caseObj;
  } 
}