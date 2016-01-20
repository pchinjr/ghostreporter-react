public class UpdateClosed {
    public Case ucase {get;set;}
    public String query {get;set;} 
    public Datetime dt_start {get;set;}
    public Datetime dt_end {get;set;}
    public String businessHoursId;
    public Long Diff1 {get;set;} 
    public Long Diff2 {get;set;}
    public Decimal de1 {get;set;} 
    public Decimal de2 {get;set;}

public UpdateClosed(){
 

}

public decimal updateHours(DateTime start, DateTime dend){
                System.debug('Start=' + start + ', end=' + dend);
                this.businessHoursId = [select Id from BusinessHours].Id;
                DateTime d1 = DateTime.newInstance(1997, 1, 31, 7, 8, 16); 
                DateTime d2 = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
                
                d1=start;
                d2=dend;
                
                System.debug('Start=' + d1 + 'End=' + d2);
                
                Diff1=BusinessHours.diff( this.businessHoursId,d1, d2) ; 
                
                
                DateTime d3=DateTime.newInstanceGmt((d1.dateGmt()), (d1.timeGmt()) ); 
                DateTime d4=DateTime.newInstanceGmt((d2.dateGmt() ), (d2.timeGmt() ) );
                
                Diff2=BusinessHours.diff( this.businessHoursId,d1, d2) ;
                De1=BusinessHours.diff( this.businessHoursId,d1, d2) ; 
                
                de1=((De1/(1*60*60*1000))-(diff2/(1*60*60*1000)));
                De2=((de1/100)*60); 
               

    return Diff2/(1*60*60*1000)+de2;
}
    

}