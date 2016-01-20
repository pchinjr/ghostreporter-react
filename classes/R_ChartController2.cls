public class R_ChartController2 {
    // Return a list of data points for a chart
    public void R_ChartController2() {    }
 
	public List<Data> getData() {
		List<AggregateResult> caseList_1415 = [select calendar_month(CRT_Review_DT__c) pmonth, fy_actual__c ,  count(id) ccount from case
		    where fy_actual__c != null and crt_review_dt__c != null
		     
		    group by calendar_month(CRT_Review_DT__c), fy_actual__c  ];

 
		List<Data> dataList = new List<Data>();
	
	
	   for(Integer x=0; x< caseList_1415.size(); x++ ){
 
	         
	               datalist.add(new Data(
	                                String.valueof(caseList_1415[x].get('pmonth')), 
	                                 String.valueof(caseList_1415[x].get('series')), 
			                        Integer.valueOf(caseList_1415[x].get('ccount'))));
 
	       
	   }
	
 

		return datalist;
	}
    // Wrapper class
    public class Data {
        public String name { get; set; }
        public String titles {get;set;}
        public Integer fields { get; set; }

        public Data(String month, String series, Integer data2) {
            this.name = month;
            this.titles = series;
            this.fields = data2;
 
        }
        
        public Integer getFields(){
            return fields;
        }
    }
}