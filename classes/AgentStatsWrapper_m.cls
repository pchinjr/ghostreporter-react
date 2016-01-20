public class AgentStatsWrapper_m {

    public String agentTeam {get;set;}
    public String agentName {get;set;}
    public String statName {get;set;}
    public Double statValue {get;set;}
    public Double curMonthValue {get;set;}
    public Double prevMonthValue {get;set;}
    public Double avg {get;set;}
    public Integer rank {get;set;}
    public Double priorScore {get;set;}
    public Double scaledValue; 
    public Double monthValue {get;set;}
    public Double yearAvg {get;set;}
    public String color {get;set;}
    public String curColor{get;set;} 
    public String prevColor{get;set;}
    public String avgColor{get;set;}
    public Boolean statReviewd{get;set;}

    
    public Map<Integer, Map<String, Decimal>> monthMap{get;set;}
    
    
    //Stat value scaler
    private StatScaling statScalingType;
    private ColorCode colorer; 
    
    public AgentStatsWrapper_m(){
        monthMap = new Map<Integer, Map<String, Decimal>>(); 
    }


    /**
     * Constructor for use with single getAgentStats
     */
     public AgentStatsWrapper_m(Date dateVal, String statName, Decimal statValue) {
         // if dateVal == curMonth, then set curVal. 
     }
    
    public AgentStatsWrapper_m(String agentTeam, String agentName, String statName, Decimal statValue){
    
        colorer = ColorCode.getInstace(); 
    
        if(agentTeam == null)
          this.agentTeam = '';
        else this.agentTeam = agentTeam;
    
        if(agentName == null)
          this.agentName = '';
        else this.agentName = agentName;
    
        if(statName == null)
          this.statName = '';
        else this.statName = statName;
    
        if(statValue == null)
          this.statValue = 0;
        else this.statValue = (Double)statValue.setScale(2);
        
        this.color = colorer.getColorCode(statName, statValue);
        
    }
    
        public AgentStatsWrapper_m(String agentTeam, String agentName, String statName, Decimal statValue, Boolean statReviewd){
    
        colorer = ColorCode.getInstace(); 
    
        if(agentTeam == null)
          this.agentTeam = '';
        else this.agentTeam = agentTeam;
    
        if(agentName == null)
          this.agentName = '';
        else this.agentName = agentName;
    
        if(statName == null)
          this.statName = '';
        else this.statName = statName;
    
        if(statValue == null)
          this.statValue = 0;
        else this.statValue = (Double)statValue.setScale(2);
        
        if(statReviewd == null)
          this.statReviewd = false;
        else this.statReviewd = (Boolean)statReviewd;
        
        this.color = colorer.getColorCode(statName, statValue);
        
        //Converts Average Call Handle time to mm.ss. (would need more work to m ake it mm:ss)
        if (statName.equalsIgnoreCase('Average Call Handle Time')) {
            String mmss = String.valueOf(Math.floor(statValue/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(statValue), 60));
            statValue = Double.valueOf(mmss);
        }
        
    }
    
    public AgentStatsWrapper_m(String agentTeam, String agentName, String statName, Double statValue, StatScaling statScalingType){
        if(agentTeam == null)
          this.agentTeam = '';
        else this.agentTeam = agentTeam;
    
        if(agentName == null)
          this.agentName = '';
        else this.agentName = agentName;
    
        if(statName == null)
          this.statName = '';
        else this.statName = statName;
    
        if(statValue == null)
          this.statValue = 0;
        else this.statValue = statValue;
        
        this.statScalingType = statScalingType;
        
        setScaledValue(statValue);
        
    }
    
    //( team  ,  agentName,  statName,  rank,  curMonthValue,   prevMonthValue,  avgs )
    public AgentStatsWrapper_m(String agentTeam, String agentName, String statName, Integer rank, 
          Decimal curMonthValue, Decimal prevMonthValue, Decimal avg, Boolean statReviewd) {
        colorer = ColorCode.getInstace(); 
    
        if(agentTeam == null)
          this.agentTeam = '';
        else this.agentTeam = agentTeam;
    
        if(agentName == null)
          this.agentName = '';
        else this.agentName = agentName;
    
        if(statName == null)
          this.statName = '';
        else this.statName = statName;
    
        if(curMonthValue == null)
          this.curMonthValue = 0;
        else this.curMonthValue = (Double)curMonthValue.setScale(2);
        
        if(prevMonthValue == null)
          this.prevMonthValue = 0;
        else this.prevMonthValue = (Double)prevMonthValue.setScale(2);
        
        if(rank == null)
          this.rank = 0;
        else this.rank = rank;
        
        if(avg == null)
          this.avg = 0;
        else this.avg = (Double)avg.setScale(2);
        
        if(statReviewd == null)
          this.statReviewd = false;
        else this.statReviewd = (Boolean)statReviewd;
        
        this.curColor = colorer.getColorCode(statName, curMonthValue);
        this.prevColor = colorer.getColorCode(statName, prevMonthValue);
        this.avgColor = colorer.getColorCode(statName, avg);
        
        //Converts Average Call Handle time to mm.ss. (would need more work to m ake it mm:ss)
        if (statName.equalsIgnoreCase('Average Call Handle Time')) {
            String prevMont_mmss = String.valueOf(Math.floor(prevMonthValue/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(prevMonthValue), 60));
            String curMont_mmss = String.valueOf(Math.floor(curMonthValue/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(curMonthValue), 60));
            String avgt_mmss = String.valueOf(Math.floor(avg/60)) +'.'+String.valueOf(Math.mod(Integer.valueOf(avg), 60));
            this.prevMonthValue = Double.valueOf(prevMont_mmss);
            this.curMonthValue = Double.valueOf(curMont_mmss);
            this.avg = Double.valueOf(avgt_mmss);
            system.debug('Changed vaues to: '+ prevMonthValue +' '+curMonthValue+' '+avg); 
        }
    }
    
    /**
     * Formats number given to a 00.00 format. 
     */
    
    
    /**
     * Scales statValue if necessary so that it will fit properly into
     * the range of the chart. 
     * <p>
     * This is based off of the type of value that is passed in. 
     */
    public void setScaledValue(Double statValue) {
        this.scaledValue = this.statScalingType.scaleValue(statValue); 
    }
    
    
    public void getAgentPivot(String agentTeam, String agentName, String statName, Double statValue){
        if(agentTeam == null)
          this.agentTeam = '';
        else this.agentTeam = agentTeam;
    
        if(agentName == null)
          this.agentName = '';
        else this.agentName = agentName;
    
        if(statName == null)
          this.statName = '';
        else this.statName = statName;
    
        if(statValue == null)
          this.statValue = 0;
        else this.statValue = statValue;
          
        
        
        
    }
}