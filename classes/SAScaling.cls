public class SAScaling implements StatScaling {
    public double scaleValue(double statValue) {
        Integer maxVal = 100; 
        Integer minVal = 86;
        Integer temp; 
        if (statValue > maxVal) {
            return maxVal + ((statValue - maxVal) *0.1);
        } else if (statValue < minVal) {
            return minVal - ((minVal - statValue)*0.1); 
        }
        return statValue;
    }
}