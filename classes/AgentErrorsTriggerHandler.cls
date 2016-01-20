public class AgentErrorsTriggerHandler {
    
    //Do not want class to be instantiable
    private AgentErrorsTriggerHandler(){}
    
	public enum Context {AFTER, BEFORE}
    
    //Handle insert triggers
    public static void handleBeforeInsert(List<AgentErrors__c> triggerNew)
    {
         transferFAtoAE(triggerNew);
    }
    
    public static void handleAfterInsert(List<AgentErrors__c> triggerNew)
    {
       
    	transferErrorScoresToStatsObj(triggerNew);
    	
    }
    
    //handle update triggers
    public static void handleBeforeUpdate(List<AgentErrors__c> triggerNew,
    									   Map<Id, AgentErrors__c> oldMap)
    {
       
    }
    
    public static void handleAfterUpdate(List<AgentErrors__c> triggerNew, 
    									 Map<Id, AgentErrors__c> oldMap)
    {

    }
    
    //handle delete triggers. trigger new not available for delete 
    public static void handleBeforeDelete(List<AgentErrors__c> triggerOld)
    {
        
    }
    
    public static void handleAfterDelete(List<AgentErrors__c> triggerOld)
    {
        
    }
    
    
    
    

    
    //Private methods to handle specific implementation. 
    
    /*Transfer agent Field Activity total count to the AgentErrors TotalServiceOrders__c
      Assumptions: The ServiceOrderErrors__c will not contain duplicates
    */


    private static void transferFAtoAE(List<AgentErrors__C> triggerNew){
        AgentErrors__c ae = triggerNew[0];
       
        List<ServiceOrderErrors__c> tso = [select id, count__c from ServiceOrderErrors__c where date__c = :ae.date__c and agentid__c = :ae.agentid__c limit 1];
       
            if(tso.size() > 0){
               triggerNew[0].TotalServiceOrders__c = tso[0].count__c;
                
            }
     }

    /**
     * Transfers newly inputted AgentErrors scores into the corresponding
     * Agent__c (aka AgentStats) objetc.
     * <p> The corresponding Agent__c object is the object where the 
     *     agentid__c field matched the AgentErrors__c psermid__c field.
     * <p> If there is no corresponding Agent__c object in the database
     *     then a new corresponding object is created
     * <p> The scores being transfered are the Quality_Error_Rate and 
     * 	   the EmailQuality scores. Quality_Error_Rate is calculated as
     * 	   the total number of errors / the total service orders.
     *     EmailQuality is calculated as the sum of all points given for the
     *     email fields in the AgentErrors__c object. 
     * <p> This method assumes that agents could be both Email and Non-Email 
     *     agents in the same month. Therefore it will calculate both scores for
     *     all agents
     * <p> This method also assumes that AgentErrors objetcs are being inserted
     * 	   one record at a time.
     * 
     * @param triggerNew	List of updated objects with their updated values.
     */
    private static void transferErrorScoresToStatsObj(List<AgentErrors__c> triggerNew) {
    	Agent__c agent;
	    AgentErrors__c ar = triggerNew[0];
	    Date pdate;
	   
        System.debug('Error object parent is '+ar.Agent__c); 
        System.debug('Err obj parent relationship is '+ar.Agent__r);
	    
	    pdate = Date.newInstance(ar.Date__c.year(), ar.Date__c.month(), 1);

        // Get the related parent of the agenterrors object
        AgentTeam__c parent = [SELECT Id, PSERMID__c, FullName__c FROM AgentTeam__c
                               WHERE Id = :ar.Agent__c];

	    List<Agent__c> agentTest = [select id from agent__c 
	    		where agentid__c = :parent.psermid__c and date__c =:pdate];

        System.debug('pdate is: '+pdate);
        System.debug('Looking for parent.PSERMID__c: '+parent.PSERMID__c);

        System.debug('AgntTest size is: '+agentTest.size());

	    
	    if(agentTest.size() == 0){
	    	// Create new Agent object 
	    	agent = new Agent__c();
	        //insert
	        agent.agent_name__c = parent.fullName__c;
	        agent.agentid__c = parent.PSERMID__c;
	        agent.agent_id__c = parent.PSERMID__c;

	        // Map AgentErros.EmailTotal to Agent.Quality_Email_Percent
	        agent.Quality_Email_Percent__c = ar.EmailTotal__c;
	        
	        if (ar.TotalErrors__c > 0 && ar.TotalServiceOrders__c > 0) {
	           agent.Quality_Error_Rate__c = 
	           				ar.TotalErrors__c / ar.TotalServiceOrders__c;
	        } else {
	     	   agent.Quality_Error_Rate__c = 0;
	    	}
	        
	        agent.date__c = Date.newInstance(ar.Date__c.year(), 
	        								ar.Date__c.month(), 
	        								1  );
	        
	        insert agent;
	    
	    } else {
            System.debug('inside of the else clause.');
	    	agent = agentTest.get(0);
	    	agent.Quality_Email_Percent__c = ar.EmailTotal__c;
	    	//update record    
	        if (ar.TotalErrors__c > 0 && ar.TotalServiceOrders__c > 0) {
	           agent.Quality_Error_Rate__c = 
	           				ar.TotalErrors__c / ar.TotalServiceOrders__c;
	        } else {
	        	agent.Quality_Error_Rate__c = 0;
	        }

	        update agent;
	    }	
    }
    
}