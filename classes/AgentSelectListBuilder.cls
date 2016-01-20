/**
 * Used to build Agent Select list. Used for composition
 */
public class AgentSelectListBuilder implements SelectListBuilder{

    public List<SelectOption> buildSelectList(List<Agent__c> agentList) {
        List<SelectOption> names = new List<SelectOption>();
        agentList = getCurrentTeams(agentList);
        agentList = removeDuplicates(agentList);
        agentList.sort();
       
        //start select list with default agent
        names.add(new SelectOption('ID', 'Name : Team'));
        
        //Putting agent first because that is how list is sorted, in order to sort by team
        //need to create wrapper class that implements comparable and overide the sort method. 
        for(Agent__c a : agentList) {
            names.add(new SelectOption(a.Agent_ID__c, a.Name__c+'   :       '+a.Team__c));
        }
        
        return names;
    }  
    
    
    /**
     * Removes the duplicate agent names from the list. 
     * Adding to a set won't work because of the unique salesforce ID. 
     * The ID is always attached, even when not selected
     * @param agents List
     * @return agents List with duplicates removed
     */ 
    public List<Agent__C> removeDuplicates(List<Agent__c> agents) {
        if(agents.size() < 1) {
            return agents;
        }
        
        List<Agent__c> toReturn = new List<Agent__c>();
        agents.sort();
        //place first name in list 
        toReturn.add(agents[0]);
        String curName = agents[0].Name__c; 
        
        for(integer i = 1; i < agents.size(); i++) {
            //system.debug('curName = '+curName);
            //system.debug('Agent name = '+agents[i].name__c);
            if(((agents[i].Name__c).equalsIgnoreCase(curName))) {
                //System.debug('Skipped');
                continue;
            } else {
                //System.debug('Added');
                toReturn.add(agents[i]);
                curName = agents[i].Name__c;
            }
        }
 
        system.debug('After removal '+ toReturn);
        
        return toReturn;
    }
    
    /**
     * Removes duplicate teams from agents list. Used before removeDuplicates
     * because that must be sorted by name in order to work
     * @param agents List
     * @return agents List with agents' previous teams removed
     */ 
    public List<Agent__C> getCurrentTeams(List<Agent__c> agents) {
        //should be sorted by date when it gets here. 
        //Use error checking or write wrapper class so that it can be sorted by date within. 
        if(agents.size() < 1) {
            return agents; 
        }
        
        List<Agent__c> toReturn = new List<Agent__c>();
        toReturn.add(agents[0]);
        String curName = agents[0].Name__c; 
        
        for(integer i = 0; i < agents.size(); i++) {
            //system.debug(agents[i].Date__c);
            if(agents[i].Name__c.equalsIgnoreCase(curName)) {
                continue;
            }
            else  {
                toReturn.add(agents[i]);
                curName = agents[i].Name__c; 
            }
        }
        
        return toReturn; 
    }
    
    
    /**
     * Builds list of SelectOptions using the TeamAgent object. 
     * @return list of SelectOption with PSERMID as Id and the string full name : team name as the selectable string
     */
    public List<SelectOption> getAgentList() {
        List<AgentTeam__c> agList = [SELECT  PSERMID__c, Team__c, fullName__c FROM AgentTeam__c ORDER BY Team__c, fullName__c ASC]; 
        List<SelectOption> agentList = new List<SelectOption>(); 
        String option; 
        for (AgentTeam__c a: agList) {
            if ( (a.get('fullName__c') != null) && (a.get('Team__c') != null) && (a.get('PSERMID__c') != null) ) {
                option = a.get('fullName__c') + ' : ' + a.get('Team__c'); 
                agentList.add(new SelectOption(String.valueOf(a.get('PSERMID__c')), option));
            }
        }
        
        return agentList; 
    }
    
    
    public List<SelectOption> getAgentList2() {
        List<AggregateResult> agList = [select Agent_ID__c, Name__c, Team__c from Agent__c GROUP BY Agent_ID__C, Name__c, Team__c order by Name__c ASC];
        List<SelectOption> agentList = new List<SelectOption>(); 
        String option; 
        for (AggregateResult a: agList) {
            if (a.get('Name__c') != null && a.get('Agent_ID__c') != null && a.get('Team__c') != null ) {
                option = a.get('Name__c') + ' : ' + a.get('Team__c'); 
                agentList.add(new SelectOption(String.valueOf(a.get('Agent_ID__c')), option));
            }
        }
        
        return agentList; 
    }
    
}