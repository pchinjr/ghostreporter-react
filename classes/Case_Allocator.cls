global class Case_Allocator implements Schedulable {
    public Boolean userStatus {get; set;}
    public Case_Allocator() {
        //reshuffleCases();
    }
    
    global void execute(SchedulableContext sc) {
        //reshufflecases();
    }
    
    //Updated to exclude severe cases from being shuffled in, they are 
    //being sent directly to Alex. Can be changed by removing AND clause from 
    //SOQL 
    @future
    public static void reshuffleCases() {
    
        List<Case> una = new List <Case>();
        
        try {
            una =  [SELECT Id, OwnerId, CRT_Review_DT__c, Case_Age_In_Business_Hours__c FROM Case
                           where status  = 'Unassigned' AND priority != 'Severe'
                           order by priority, CRDate__c desc];
        } catch(QueryException e) {
            // no unassigned cases left!
        }
       
        
        List<User> user1 = new List<User>();
        
        try {
            /* for UAT, use the  lastlogindate in the where clause:  lastlogindate = today */
            user1 = [select id, lastlogindate, profile.name, available__c from user
                                where (profile.name = 'CRT Member' or profile.name = 'System Administrator') and available__c = true];
        } catch(QueryException e) {
            // no available agents
        } 
        
        if (user1.size() > 0) {
            /* Use the number of logged in users as a modulo
             * to evenly distribute the unassigned cases
             */
            for (Integer i = 0; i < una.Size(); i++) {
                una.get(i).OwnerId = user1.get(math.mod(i, user1.size())).id;
            }
            update una; 
        }
    }
    
    
    
    
        
    //Updated to exclude severe cases from being shuffled in, they are 
    //being sent directly to Alex. Can be changed by removing AND clause from 
    //SOQL     
  	public  void reshuffleEmailCases() {
    
        List<Case> una = new List <Case>();
        
        try {
            una =  [SELECT CRDate__c, Priority, Id, OwnerId, CRT_Review_DT__c, Case_Age_In_Business_Hours__c FROM Case
                           where status  = 'Unassigned' and origin = 'Email' AND priority != 'Severe'
                           for update];
        } catch(QueryException e) {
            // no unassigned cases left!
        }
            
            
          system.debug(una);
        //Needed to order list of cases  
        Map<String, Integer> severityMap = new Map<String, Integer>();
        severityMap.put('Severe', 3);
        severityMap.put('High', 2);
        severityMap.put('Medium', 1);
        severityMap.put('Low', 0);
        
        //Order cases here, since cannot do it in SQL query when you are using a FOR UPDATE 
        for(Integer i = 0; i <una.size(); i++)
        {
            Integer maxCase = 0;
            Case highPriority = una.get(i);
            Integer maxIndex = i; 
            //find most severe case
            for(Integer j = i; j < una.size(); j++)
            {
                if(severityMap.get(una.get(j).priority) >= maxCase)
                {
                    
                    //need to arrange by crDate also 
                    if(severityMap.get(una.get(j).priority) == maxCase)
                    {
                        if(una.get(j).CRDate__c < highPriority.CRDate__c)
                        {
                            maxCase = severityMap.get(una.get(i).priority);
                            highPriority = una.get(j);
                            maxIndex = j; 
                        }
                    }
                    else{
                        maxCase = severityMap.get(una.get(j).priority);
                        highPriority = una.get(j);
                        maxIndex = j; 
                    }
                }  
            }
            //must replace maxIndex first in order to not lose object currenly held at i 
            una.set(maxIndex, una.get(i));
            una.set(i, highPriority);
            
        } //end of sort 
            
        system.debug('una');     
        
        List<User> user1 = new List<User>();
        
        try {
            /* for UAT, use the  lastlogindate in the where clause:  lastlogindate = today */
            user1 = [select id, lastlogindate, profile.name, available__c from user
                                where profile.name = 'CRT Member' and available__c = true];
        } catch(QueryException e) {
            // no available agents
        } 
        
        if (user1.size() > 0) {
            /* Use the number of logged in users as a modulo
             * to evenly distribute the unassigned cases
             */
            for (Integer i = 0; i < una.Size(); i++) {
                una.get(i).OwnerId = user1.get(math.mod(i, user1.size())).id;
            }
            update una; 
        }
    }
    
}

/*
// Also update the Case Age in Business Hours for each case
        Case_Updater age_Updater = new Case_Updater();
                una.get(i).Case_Age_In_Business_Hours__c = age_Updater.hoursSinceCreation(una.get(i));
*/