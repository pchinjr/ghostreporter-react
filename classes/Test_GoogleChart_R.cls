@isTest
private class Test_GoogleChart_R {

	private static testMethod void test() {

       	
       	Data td = new Data('Oct',12, 11, 10);
       	
       	td.month = 'Oct';
       	td.data  = 10;
       	td.fiscalyear = 'FY 14-15';
       	td.data = 10;
       	td.FY14 = 10;
       	td.FY15 = 10;
       	td.fy16 = 10;
       	td.FY14_Name = 'FY 14-15';
       	td.FY15_Name = 'FY 15-16';
       	td.FY16_Name = 'FY 16-17';
       	
       	System.assertequals(td.FY14_Name , 'FY 14-15');
       	System.assertequals(td.FY15_Name , 'FY 15-16');
        System.assertequals(td.FY16_Name , 'FY 16-17'); 

        List<Data> ct = GoogleChartsController_R.loadOpps2();
        
        Integer size;
        size = ct.size();
        
        List<Data> ct_Avg = GoogleChartsController_R.loadAvg();
        size = ct_Avg.size();
        
        
        

	       
        
        
	}

}