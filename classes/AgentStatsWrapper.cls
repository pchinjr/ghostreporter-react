public class AgentStatsWrapper {

    public String agentTeam {get;set;}
    public String agentName {get;set;}
    public String statName {get;set;}
    public Double curMonthValue {get;set;}
    public Double prevMonthValue {get;set;}
    public Double avg {get;set;}
    public Integer rank {get;set;}
    public Double scaledValue; 
    public String curColor{get;set;} 
    public String prevColor{get;set;}
    public String avgColor{get;set;}
    public Boolean statReviewd{get;set;}
    
    public String currFormattedValue {get;set;}
    public String prevFormattedValue {get;set;}
    public String avgFormattedValue {get;set;}
    
    public String currDoubleFormattedValue{get;set;}
    public String prevDoubleFormattedValue{get;set;}
    
    public Boolean timeFormatted{get;set;}
    
    
    //Stat value scaler
    private ColorCode colorer; 
    
    //Called when passing in values that have a time formatted field, ie hold_time_formatted__c
    //( team  ,  agentName,  statName,  rank,  curMonthValue,   prevMonthValue,  avgs )
    public AgentStatsWrapper(String agentTeam, String agentName, String statName, Integer rank, 
          Decimal curMonthValue, Decimal prevMonthValue, Decimal avg, Boolean statReviewd, Double currMonthValueFormatted, Double prevMonthValueFormatted, 
          boolean isEmailCurMonth, boolean isEmailPrevMonth, boolean wasEverEmail, String ApiName) {

        system.debug('Constructor 4 was called for statName '+statName);
		system.debug('The avg value pass in: '+avg);
        this.timeFormatted = true;
        
        colorer = ColorCode.getInstace(); 
        boolean curValWasNull = false;
        boolean prevValWasNull = false; 
        boolean avgValWasNUll = false; 
    
        // //check if agent ever was email agent. 
        // Date lastAugust = AgentController_r2.getLastAugust(); 
        // List<Agent__c> emailList = [SELECT IsEmailAgent__c FROM Agent__c where Name__c = :agentName AND IsEmailAgent__c = true AND Date__c > :lastAugust ]; 
        // //If list contains an object than agent had to have handled emails at one point. 
        // if (!emailList.isEmpty()) {
        //     wasEverEmail = true;
        // }
    
        if(agentTeam == null)
          this.agentTeam = '';
        else this.agentTeam = agentTeam;
    
        if(agentName == null)
          this.agentName = '';
        else this.agentName = agentName;
    
        if(statName == null)
          this.statName = '';
        else this.statName = statName;
    
        if(curMonthValue == null){
          curValWasNull = true; 
          this.curMonthValue = 0;
          this.currFormattedValue = '00:00:00';
          this.currDoubleFormattedValue = '00:00:00';
          
        }
        else {
            this.curMonthValue = (Double)curMonthValue.setScale(2);
            this.currFormattedValue = timeFormatValue(Integer.valueof(curMonthValue));
            this.currDoubleFormattedValue = timeFormatValue(Integer.valueof(currMonthValueFormatted));
            System.debug('timeFormatted=' + currMonthValueFormatted);
        }
        
        if(currMonthValueFormatted == null)
           this.currDoubleFormattedValue = '00:00:00';
        if(prevDoubleFormattedValue == null)
           this.prevDoubleFormattedValue = '00:00:00';
        
        if(prevMonthValue == null){
          prevValWasNull = true; 
          this.prevMonthValue = 0;
          this.prevFormattedValue = '00:00:00';
          this.prevDoubleFormattedValue =  '00:00:00';
        }
        else{ 
            this.prevMonthValue = (Double)prevMonthValue.setScale(2);
            this.prevFormattedValue = timeFormatValue(Integer.valueof(prevMonthValue));
            this.prevDoubleFormattedValue = timeFormatValue(Integer.valueof(prevMonthValueFormatted));
        }
        
        if(rank == null)
          this.rank = 0;
        else this.rank = rank;
        
        if(avg == null){
          avgValWasNUll = true;
          this.avg = 0;
          this.avgFormattedValue = '00:00:00'; 
        }
        else{
          this.avg = (Double)avg.setScale(2);
          this.avgFormattedValue = timeFormatValue(Integer.valueof(this.avg));
        } 
        
        if(statReviewd == null)
          this.statReviewd = false;
        else this.statReviewd = (Boolean)statReviewd;
        
        //this.curColor = colorer.getColorCode(statName, curMonthValue);
        //this.prevColor = colorer.getColorCode(statName, prevMonthValue);
        //this.avgColor = colorer.getColorCode(statName, avg);
       if (curValWasNull) {
          this.curColor = 'white';
       } else {
          this.curColor = colorer.getColorCode(this.curMonthValue, ApiName, isEmailCurMonth);
       }
        
       if (prevValWasNull) {
          this.prevColor = 'white';
       } else {
          this.prevColor = colorer.getColorCode(this.prevMonthValue, ApiName, isEmailPrevMonth);
       }
        
       if (avgValWasNUll) {
          this.avgColor = 'white';
       } else {
          this.avgColor = colorer.getColorCode(this.avg, ApiName, wasEverEmail);
       }
        
        
        //Converts Average Call Handle time to mm.ss. (would need more work to m ake it mm:ss)
        /*if (statName.equalsIgnoreCase('Average Call Handle Time')) {
            String prevMont_mmss = String.valueOf(Math.floor(prevMonthValue/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(prevMonthValue), 60));
            String curMont_mmss = String.valueOf(Math.floor(curMonthValue/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(curMonthValue), 60));
            String avgt_mmss = String.valueOf(Math.floor(avg/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(avg), 60));
            this.prevMonthValue = Double.valueOf(prevMont_mmss);
            this.curMonthValue = Double.valueOf(curMont_mmss);
            this.avg = Double.valueOf(avgt_mmss);
            system.debug('Changed vaues to: '+ prevMonthValue +' '+curMonthValue+' '+avg); 
        } */
    }
   
    
    //( team  ,  agentName,  statName,  rank,  curMonthValue,   prevMonthValue,  avgs )
    public AgentStatsWrapper(String agentTeam, String agentName, String statName, Integer rank, 
          Decimal curMonthValue, Decimal prevMonthValue, Decimal avg, Boolean statReviewd, boolean isEmailCurMonth, boolean isEmailPrevMonth, boolean wasEverEmail, String ApiName) {
        colorer = ColorCode.getInstace(); 
        boolean curValWasNull = false;
        boolean prevValWasNull = false; 
        boolean avgValWasNUll = false;

        system.debug('Constructor 6 was called for statName '+statName);
    
        if(agentTeam == null)
          this.agentTeam = '';
        else this.agentTeam = agentTeam;
    
        if(agentName == null)
          this.agentName = '';
        else this.agentName = agentName;
    
        if(statName == null)
          this.statName = '';
        else this.statName = statName;
    
        if(curMonthValue == null){
          curValWasNull = true; 
          this.curMonthValue = 0;
          this.currFormattedValue = '00:00:00';
        }
        else {
            this.curMonthValue = (Double)curMonthValue.setScale(2);
            this.currFormattedValue = timeFormatValue(Integer.valueof(this.curMonthValue));
            
        }
        
        if(prevMonthValue == null){
          prevValWasNull = true; 
          this.prevMonthValue = 0;
          this.prevFormattedValue = '00:00:00';
        }
        else{ 
            this.prevMonthValue = (Double)prevMonthValue.setScale(2);
            this.prevFormattedValue = timeFormatValue(Integer.valueof(this.prevMonthValue));
        }
        
        if(rank == null)
          this.rank = 0;
        else this.rank = rank;
        
        if(avg == null){
          avgValWasNUll = true; 
          this.avg = 0;
          this.avgFormattedValue = '00:00:00'; 
        }
        else{
          this.avg = (Double)avg.setScale(2);
          this.avgFormattedValue = timeFormatValue(Integer.valueof(this.avg));
        } 
        
        if(statReviewd == null)
          this.statReviewd = false;
        else this.statReviewd = (Boolean)statReviewd;
        
        //check if agent ever was email agent. 
        // Date lastAugust = AgentController_r2.getLastAugust(); 
        // List<Agent__c> emailList = [SELECT IsEmailAgent__c FROM Agent__c where Name__c = :agentName AND IsEmailAgent__c = true AND Date__c > :lastAugust ]; 
        // //If list contains an object than agent had to have handled emails at one point. 
        // if (!emailList.isEmpty()) {
        //     wasEverEmail = true;
        // }
        
        //this.curColor = colorer.getColorCode(statName, curMonthValue);
        //this.prevColor = colorer.getColorCode(statName, prevMonthValue);
        //this.avgColor = colorer.getColorCode(statName, avg);
        
      if (curValWasNull) {
          this.curColor = 'white';
       } else {
          this.curColor = colorer.getColorCode(this.curMonthValue, ApiName, isEmailCurMonth);
       }
        
       if (prevValWasNull) {
          this.prevColor = 'white';
       } else {
          this.prevColor = colorer.getColorCode(this.prevMonthValue, ApiName, isEmailPrevMonth);
       }
        
       if (avgValWasNUll) {
          this.avgColor = 'white';
       } else {
          this.avgColor = colorer.getColorCode(this.avg, ApiName, wasEverEmail);
       }
        
        //Converts Average Call Handle time to mm.ss. (would need more work to m ake it mm:ss)
       /* if (statName.equalsIgnoreCase('Average Call Handle Time')) {
            String prevMont_mmss = String.valueOf(Math.floor(prevMonthValue/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(prevMonthValue), 60));
            String curMont_mmss = String.valueOf(Math.floor(curMonthValue/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(curMonthValue), 60));
            String avgt_mmss = String.valueOf(Math.floor(avg/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(avg), 60));
            this.prevMonthValue = Double.valueOf(prevMont_mmss);
            this.curMonthValue = Double.valueOf(curMont_mmss);
            this.avg = Double.valueOf(avgt_mmss);
            system.debug('Changed vaues to: '+ prevMonthValue +' '+curMonthValue+' '+avg); 
        }*/
    }
    
    /**
     * Formats number given to a 00.00 format. 
     */
    public String timeFormatValue(Integer value){
        
        Integer HoursInDay = 24;
        Integer MinutesInHour = 60;
        Integer SecondsInMinute = 60;
        String days;
        String hour;
        String min;
        String sec;
        Integer avgHandleTime;
        String actualTime;
        
        
        if(value == null){
           value = 0; 
           actualTime = '00:00:01';  
        }
           else {
        

        
        avgHandleTime = value;
        
        days = String.valueof(Math.mod(avgHandleTime, 86400 * 30) / 86400);
        hour = String.valueof(Math.mod(avgHandleTime, 86400) / 3600);
        min =  String.valueof(Math.mod(avgHandleTime, 3600) / SecondsInMinute);
        sec = String.valueof(Math.mod(avgHandleTime, SecondsInMinute));
        
        if(hour.length() == 1){
            hour = '0' + hour;
        } 
        else hour = hour;
        
        if(min.length() == 1){
            min = '0' + min;
        } 
        else min = min;
        
        if(sec.length() == 1){
            sec = '0' + sec;
        } 
        else sec = sec;
        

        if(days.length() == 0){
           actualTime =  min + ':' + sec;
        }else
          actualTime =  hour + ':' + min + ':' + sec;
        }
           
        return actualTime;
             
    }
    
}