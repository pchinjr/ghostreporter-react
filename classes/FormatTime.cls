public class FormatTime {
    
    public FormatTime(){
        
    }

public  String timeFormatValue(Integer value){
        
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
          actualTime = days + ':' + hour + ':' + min + ':' + sec;
        }
           
        return actualTime;
             
    }

    
}