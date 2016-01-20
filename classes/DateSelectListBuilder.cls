public class DateSelectListBuilder implements SelectListBuilder{
	
    //January must equal index 1
    private List<String> months = new String[]{'','January', 'February', 'March', 'April', 'May', 'June',
                                       'July', 'August', 'September', 'October', 'November', 'December'};
    
    public List<SelectOption> buildSelectList(List<sObject> optionList) {
        List<SelectOption> dates = new List<SelectOption>();
        Date currentDay = Date.today();
        integer month = currentDay.month();
        integer year = currentDay.year();
        
        integer previousMonth = getPrevMonth(month);
        if(previousMonth == 12) {
            year--; 
        }
                              
        for(integer i = 0; i <= 5; i++) {
            //First time through start at previous month, then start at 12 the remainderof times. 
            if(i > 0) {
                previousMonth = 12; 
            }
            for(integer j = previousMonth; j > 0; j--) {
                String toAdd = months[j] + ' ' + (year - i);
                dates.add(new SelectOption(String.valueOf( Date.newInstance((year - i), j, 1)), toAdd));
            }
        }
    
        return dates; 
    }
    
     
    /**
     * Returns the month prior to the previous month. 
     * Special case for january. 
     * @param int currentMoth
     * @return integer previousMonth
     */ 
    public integer getPrevMonth(integer currentMonth) {
         
       //no switch statements in apex
       if(currentMonth == 1) {
           return 12; 
       } else 
            return currentMonth - 1;       
    }
    
    
    public List<SelectOption> buildAgentDateSelectList() {
        List<SelectOption> dates = new List<SelectOption>(); 
        List<AggregateResult> currentAgents = [SELECT Date__c from Agent__c GROUP BY Date__c ORDER BY Date__c Desc];
        String option; 
        for (AggregateResult a: currentAgents) {
            if (a.get('Date__c') != null) {
                option = months[Date.valueOf(a.get('Date__c')).month()] + ' ' + Date.valueOf(a.get('Date__c')).year();  
            	dates.add(new SelectOption(String.valueOf(a.get('Date__c')), option));
            } 
        }
        
        return dates; 
    }
    
}