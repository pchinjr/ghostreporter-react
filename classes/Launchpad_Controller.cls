/** Launchpad_Controller holds relevant variables and functions to the ProActive Launchpad.
  * @author: Matthew Bald
  */
public class Launchpad_Controller {
    
    public Integer severePriority {get; set;}
    public Integer highPriority {get; set;}
    public Integer medPriority {get; set;}
    public Integer lowPriority {get; set;}
    
	/** Constructor for the Launchpad_Controller. Populates the class'
	  * variables that provide information for the CRT user.
	  * @author: Matthew Bald
	  */
    public Launchpad_Controller() {
    	
    	severePriority = [select count() from Case where Priority = 'Severe'
                                                   and isClosed = false];
        
        highPriority = [select count() from Case where Priority = 'High'
                                                   and isClosed = false];
                                                   
        medPriority = [select count() from Case where Priority = 'Medium'
                                                   and isClosed = false];
                                                   
        lowPriority = [select count() from Case where Priority = 'Low'
                                                   and isClosed = false];         
                                                   
    }   
	
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
    	
    	nextCase = getNextUnassigned();
    	System.debug('STARTING XOXOXOXOXOX    >>' );
    	
    	
    	if (nextCase != null) {
    		
    		caseCheck = database.query('select Id, OwnerId, Status from Case where Id =' + nextCase.id);
    		if(nextCase.Status != 'Unassigned'){
    			System.debug('XOXOXOXOXOX    >>' + nextCase.Status + ' ' + caseCheck.Status);
    			//findNextCaseUnassigned();
    			
    		}
    		
    		// nextCase should contain the case to navigate to
	    	pRef = new ApexPages.StandardController(nextCase).view();
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
    public Case getNextUnassigned() {
    	Case nextCase = null;
    		System.debug('STARTING XOXOXOXOXOX    >>' );
    	try { 
    		nextCase = [select Id, OwnerId, Status from Case where isClosed = false and Status = 'Unassigned'
    																				//and OwnerId not in :[select Id from User]
    																		 		order by Priority, CRDate__c limit 1];
    		
    		nextCase.OwnerId = UserInfo.getUserId(); // assign the case to the user
    		nextCase.Status = 'In Progress';
    		
    		update nextCase;
    	} catch (Queryexception e) {
    		// found no cases
    	}    	
    	return nextCase;
    }
}