/*
Author: Ruben Ortiz
Page: DailyActivity


*/

public class Ctrl_Agent_DailyActivity {
public DailyActivity__c tmpda { get;set; }
public DailyActivity__c da { get;set; }

public List<SelectOption> statusOptions { get;set; }
public List<SelectOption> agentOptions { get;set; }
public  List<DailyActivity__c> dac{get;set;}
public Date activityDate {get;set;}
public Agent__c defaultAgent{get;set;}
public String selectedVal{get;set;} 
public String comments{get;set;}
public Integer value{get;set;}




public String agentId {get;set;}// This will hold the selected value, the id in here
private AgentSelectListBuilder agentSelectListBuilderType; 

public Ctrl_Agent_DailyActivity(){
     
    agentSelectListBuilderType = new AgentSelectListBuilder();
    tmpda = new DailyActivity__c();
     
}

    public List<DailyActivity__c> getPriorActivities(){
        
        dac = [select activity_date__c, agentid__c, activity_type__c, value__c from dailyActivity__c where agentid__c = :tmpda.agentid__c order by activity_date__c desc];
        
        return    dac;
    }

    //Build Activity Type picklist
    public  List<SelectOption> getActivityType() {
             statusOptions = new List<SelectOption>();
            
            Schema.DescribeFieldResult statusFieldDescription = DailyActivity__c.Activity_Type__c.getDescribe();
            
            List<Schema.PicklistEntry> ple = statusFieldDescription.getPicklistValues();
            for (Schema.Picklistentry picklistEntry : ple)
            {
            	statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            }
            
          
            return statusOptions;
             
    }
    
    //Build agent picklist
        public List<SelectOption> getAgentsList() {
            agentOptions = new List<SelectOption>();
            
           	List<AgentTeam__c> agents = [SELECT fullName__c, PSERMID__c FROM AgentTeam__c  ORDER BY fullName__c ASC NULLS LAST];
     
            for(AgentTeam__c a : agents){
                agentOptions.add(new SelectOption(a.fullName__c, a.PSERMID__c));
            }
            
         return agentOptions;
    }
    
      //Insert only, will modify to update and add error handling
        public void save() {

            this.da = new DailyActivity__c(
                activity_type__c = tmpda.activity_type__c,
                activity_date__c = tmpda.activity_date__c,
                agentid__c = tmpda.agentid__c,
                comments__c = tmpda.rcomments__c,
                value__c = tmpda.value__c
                
                );
            
            insert this.da;
 
       }

}