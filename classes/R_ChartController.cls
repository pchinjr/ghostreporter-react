public class R_ChartController {
    // Return a list of data points for a chart
    public void R_ChartController() {    }
 
	public List<Data> getCaseCountFY() {
		List<AggregateResult> caseList  = [select calendar_month(closeddate) pmonth, fy_actual__c, count(id) ccount from case
		    where fy_actual__c != null and isclosed = true
 		    group by calendar_month(closeddate), fy_actual__c, fiscal_month(closeddate) order by fiscal_month(closeddate)  asc ];

 

 
		List<Data> dataList = new List<Data>();
	
	
	   for(Integer x=0; x< caseList.size(); x++ ){
 	               datalist.add(new Data(
	                                String.valueof(caseList[x].get('pmonth')), 
	                                String.valueof(caseList[x].get('fy_actual__c')), 
			                        Integer.valueOf(caseList[x].get('ccount'))
								));
	       }
	       
	   
	
 

		return datalist;
	}
    // Wrapper class
    public class Data {
        public String month { get; set; }
        public String fiscalYear {get;set;}
        public Integer data {get;set;}
        public Integer FY14 {get;set;}
        public Integer FY15 { get; set; }
        public Integer FY16 { get; set; }
        public String FY14_Name {get;set;}
        public String FY15_Name {get;set;}
        public String FY16_Name {get;set;}
   
        public Data(String month, String FY, Integer data) {
            this.month = month;
            this.fiscalYear = FY;
            this.data = data;
            this.FY14 = 0;
            this.FY15 = 0;
            this.FY16 = 0;
                                    
            this.FY14_Name = 'FY 14-15';
            this.FY15_Name = 'FY 15-16';
            this.FY16_Name = 'FY 16-17';
            
            
            System.debug('xx data=' + data + ', FY=' + FY );
            
            if(this.FY14_Name == FY){
                FY14 = data;
            }
            else if(this.FY15_Name == FY){
                FY15 = data;  
                FY14 = 21;
            }
            else if(this.FY16_Name == FY){
                FY16 = data;
            }
            
    
        }
    }
}