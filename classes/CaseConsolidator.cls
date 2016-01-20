/**
 * CaseConsolidator consolidates duplicate cases created by the different reports received
 * by SalesForce.
 * <p>
 * Merges cases into the most recently created case and sets the "Consolidated" flag
 * on the older cases. This consolidated flag will allow cases to not be included in 
 * the next upload from jitterbit. 
 * @author  Mike McGee
 */
public class CaseConsolidator {
    
    private List<Case> duplicateCases; 
    private Case currentCase; 
    private String casenumber;
    private String accountID; 
    private String currentCaseId; 
    private String description; 
    private boolean isBatch = false; 
    
    //duplicate count
    public static integer numConsolidated = 0; 
    
    public CaseConsolidator() {}
    
    //constructor. 
    public CaseConsolidator(Case currentCase)
    { 
        this.currentCase = currentCase; 
        this.accountID = currentCase.Account_ID__c; 
        this.description = currentCase.Description;
        this.currentCaseId = currentCase.Id; 
        consolidate(); 
    }
    
    //Constructor for batch consolidator. 
    public CaseConsolidator(Case currentCase, boolean isBatch)
    {
       
        this.currentCase = currentCase; 
        System.debug('CaseNumber:' + currentCase.casenumber);
        this.casenumber = currentCase.casenumber;
        this.accountID = currentCase.Account_ID__c; 
        this.description = currentCase.Description;
        this.currentCaseId = currentCase.Id; 
        this.isBatch = isBatch; 
        consolidate(); 
    }
    
    
    /**
     * Consolidates duplicate cases
     * <p>
     * Finds cases matching the created case's accountID and marks a consolidated
     * flag on the duplicate cases to true, then appends the duplicate descriptions
     * to the created cases description 
     * 
     * @author  Mike McGee  
     */
   
    public void consolidate()
    {
        duplicateCases = getListOfDuplicateCases(accountID);
        setConsolidatedFlags(duplicateCases);
        consolidatePriority(duplicateCases);
        addDescriptions(getDuplicateDescriptions(duplicateCases)); 
        
        if (isBatch) {
            update currentCase;
        }
        
    }
    
    /**
     * Sets currentCase description to the combination all of the descriptions. 
     * 
     * @author  Mike McGee
     * @param   duplicateDescriptions   string of all previous descriptions
     */ 
    private void addDescriptions(String duplicateDescriptions)
    {
        if (duplicateDescriptions != null) {
            if (currentCase.Description == null) {
                currentCase.Description = duplicateDescriptions; 
            } else {
                if (duplicateDescriptions.contains(currentCase.Description)) {
                    if (duplicateDescriptions.length() > 32000) {
                        currentCase.Description += '\ndescripton too long, old descriptions removed';
                    } else { 
                        currentCase.Description = duplicateDescriptions;
                    } 
                } else {
                            
                    if (currentCase.Description.length() + duplicateDescriptions.length() > 32000) {
                        currentCase.Description += '\ndescripton too long, old descriptions removed';
                    } else { 
                        currentCase.Description += duplicateDescriptions; 
                    }
                }
            }
        }
    }
    
    /**
     * Compares case1 with case2 and returns the most severe case
     * <p>
     * need this becsuse default ordering of priority is off. 
     * Default ordering is: 
     * Severe
     * Medium
     * Low
     * High
     * 
     * @param   c1  first case passed in
     * @param   c2  second case passed in
     * @return  Case with highest priority. 
     */
    public static Case getPriorityCase(Case c1, Case c2) {
        if (c1.Priority == 'Severe') {
            return c1; 
        } else if (c2.Priority == 'Severe') {
            return c2; 
        } else if (c1.Priority == 'High') {
            return c1;
        } else if (c2.Priority == 'High') {
            return c2; 
        } else if (c1.Priority == 'Medium') {
            return c1; 
        } else {
            return c2; 
        }
    }
    
    /**
     * Set case description to highest proprity level of duplicate cases. 
     * <p>
     * Higher priorities have lower values 
     * 
     * @author  Mike McGee
     * @param   duplicateCases  list of cases with same Id
     * Change:
     * Ruben Ortiz- Added fields to track prior priority and flag consolidated cases
     * that increased in priority
     */
    private void consolidatePriority (List<Case> duplicateCases) {
                for (Case c : duplicateCases) {
                    currentCase.Prior_Priority__c = currentCase.Priority;
                    currentCase.Parent_Duplicate__c = True;
                    
                    System.debug('Current Case Priority:' + currentCase.Priority + ' new Priority' + CaseConsolidator.getPriorityCase(c, currentCase).Priority );
        
                    if(!(currentCase.Priority.equals(CaseConsolidator.getPriorityCase(c, currentCase).Priority))){
                        currentCase.Incremented__c = True;
                        
                    }
        
        
                    currentCase.Priority = CaseConsolidator.getPriorityCase(c, currentCase).Priority;
                    
        
                    
                    
                    
                }
        
     /*   for (Case c : duplicateCases) {
            if(c.Description != null) {
                if ( !(c.Description.equals(description)) ) {
                    currentCase.Prior_Priority__c = currentCase.Priority;
                    currentCase.Priority = incrementPriority(currentCase).Priority;
                    currentCase.Incremented__c = True;
                } 
                
            }
        }
       */ 
    }
    
    /**
     * Gets descriptions of duplicate cases and combines them into one string. 
     * 
     * @author  Mike McGee
     * @param   duplicateCases  list of cases with same accountId as created case
     * @return  String  the combination of the descriptions of duplicate cases.
     */
    private String getDuplicateDescriptions(List<Case> duplicateCases)
    {
        String consolidatedDescription = ''; 
        system.debug('Duplicate Case size in duplicate descriptions '+duplicateCases.size());
        
        for(Case c: duplicateCases) { 
            if (c.Description != null) {
                if (c.Description.remove('DUPINFO:') == currentCase.Description) {
                    continue; 
                }
                System.debug('consolidatedDescription: '+consolidatedDescription+' c.description '+ c.Description);
                if(!( consolidatedDescription.contains(c.Description))) {
                    consolidatedDescription += '\nDUPINFO: '+c.Description.trim();
                }
            }
        }
        
		return consolidatedDescription; 
    }
    
    /**
     * Builds list of all cases that share the same Account_ID as the calling case
     * <p>
     * should only add cases if they have the same AccountID and are not in progress. 
     *
     * @author  Mike McGee 
     * @param   accountID   Account_ID of case object. 
     * 
     */
    private List<Case> getListOfDuplicateCases(String accountID)
    {
        system.debug('Searching for unassigned cases where account Id = '+accountID);
        List<Case> duplicateCases = [SELECT Id, Priority, Account_ID__c, Consolidated__c, Description, Status, Parent_Case__c, Parent_Duplicate__c FROM Case WHERE Account_ID__c = :accountID AND Status = :'Unassigned' AND Origin != :'Email'];
        system.debug('duplicate case size : '+duplicateCases.size());
        //If running in a batch context then you need to remove the case from the list of duplicate cases. 
        if (isBatch) {
            system.debug('Was batch');
            for (integer i = 0; i < duplicateCases.size(); i++) {
                if (duplicateCases[i].Id == currentCaseId) {
                    system.debug('Removing case with ID '+duplicateCases[i].Id+' at position '+i);
                    duplicateCases.remove(i);
                    break; 
                }
            }
            return duplicateCases; 
        }
        return duplicateCases; 
    }
    
    /**
     * Increments priority of case by one level
     * @param   caseToIncrement the case wo raise priority level for
     * @return  case with one level higher priority
     */
/*    public Case incrementPriority (Case caseToIncrement) {
        if (caseToIncrement.Priority == 'Severe') {
            return caseToIncrement; 
        } else if (caseToIncrement.Priority == 'High') {
            return caseToIncrement; 
        } else if (caseToIncrement.Priority == 'Medium') {
            caseToIncrement.Priority = 'High';
            return caseToIncrement;
        } else {
            caseToIncrement.Priority = 'Medium'; 
            return caseToIncrement; 
        }
    } */
    

    
    /**
     * Sets Consolidated flag on all cases that are in duplicateCase list
     * <p>
     * This should only be acitng on a before insert trigger and therefore 
     * the newly created case should not be in the list of cases with it's ID. 
     * 
     * @author  Mike McGee
     * @param   duplicateCases  list of cases with same accountId as created case
     * 
     */
    private void setConsolidatedFlags(List<Case> duplicateCases)
    {
        system.debug('The list that is being consolidated is of size '+duplicateCases.size());
        for(Case c : duplicateCases)
        {
            c.Parent_Case__c = currentCase.casenumber;
            c.Consolidated__c = true;
            c.Status = 'Duplicate';
            numConsolidated++; 
        }
        
        update duplicateCases; 
    }
    
    
    public void startBatch() {
      
        isBatch = true; 
        String query = 'SELECT Id, Account_ID__c, Description, Priority, Origin, Status, casenumber From Case';
        Id batchInstanceId = Database.executeBatch(new CaseConsolidator_Batch(query), 50); 
    }
    
    @InvocableMethod(label='Consolidate' description='Consolidate duplicate cases in Batch mode')
    static public void startBatch_Static() {
        boolean isBatch; 
        isBatch = true; 
        String query = 'SELECT Id, Account_ID__c, Description, ConsolidateExclude__c, Priority, Origin, Status, casenumber From Case';
        Id batchInstanceId = Database.executeBatch(new CaseConsolidator_Batch(query), 50); 
    }
    
}