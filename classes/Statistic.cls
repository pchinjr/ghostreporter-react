/**
 * Represents a Statistic
 */
public virtual class Statistic {
    
    private Double curValue; 
    private Double prevValue; 
    private String statName;
    private Double totalValue; 
    private Integer totalOccurances;
    private Integer rank; 
    private static ColorCode colorer;
    
    public Statistic(String statName) {
        this.statName = statName; 
        this.totalOccurances = 0; 
        this.totalValue = 0; 
        colorer = ColorCode.getInstace(); 
    }
    
    public void setRank(Integer rank){
        this.rank = rank; 
    }
    
    public void setCurValue(Double curValue) {
        this.totalOccurances++; 
        this.curValue = curValue; 
        this.totalValue += curValue; 
    }
    
    public void setPrevValue(Double prevValue) {
        this.totalOccurances++; 
        this.prevValue = prevValue; 
        this.totalValue += prevValue;
    }
    
    public void addOccurance(Double value) {
        this.totalOccurances++; 
        this.totalValue += value; 
    }
    
    public Integer getRank() {
        return this.rank; 
    }
    
    public Double getcurValue() {
        return this.curValue; 
    }
    
    public String getCurValueAsString() {
        if (this.curValue == null) return null; 
        if (this.statName.equalsIgnoreCase('Average Call Handle Time')){
            return Integer.valueOf(Math.floor(curValue/60)) +':'+ Math.mod(Integer.valueOf(curValue), 60);
        }
        return String.valueOf(Decimal.valueOf(this.curValue).setScale(2));
    }
    
    public Double getprevValue() {
        return this.prevValue; 
    }
    
    public String getPrevValueAsString() {
        if(this.prevValue == null) return null; 
        if (this.statName.equalsIgnoreCase('Average Call Handle Time')){
            return Integer.valueOf(Math.floor(prevValue/60)) +':'+ Math.mod(Integer.valueOf(prevValue), 60);
        }
        return String.valueOf(Decimal.valueOf(this.prevValue).setScale(2));
    }
    
    public String getstatName() {
        return this.statName; 
    }
    
    public Double getavgValue() {
        return (this.totalValue / this.totalOccurances); 
    }
    
    public String getAvgValueAsString() {
        if(this.prevValue == null) return null; 
        if (this.statName.equalsIgnoreCase('Average Call Handle Time')){
            return Integer.valueOf(Math.floor(getavgValue()/60)) +':'+ Math.mod(Integer.valueOf(getavgValue()), 60);
        }
        return String.valueOf(Decimal.valueOf(this.getavgValue()).setScale(2));
    }
    
    public String getCurColor() {
        return colorer.getColorCode(this.statName, this.curValue); 
    }
    
    public String getPrevColor() {
        return colorer.getColorCode(this.statName, this.prevValue); 
    }
    
    public String getAvgColor() {
        return colorer.getColorCode(this.statName, this.getavgValue()); 
    }
    
}