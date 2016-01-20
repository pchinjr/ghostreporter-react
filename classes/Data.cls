// Wrapper class
    global class Data {
        public String month { get; set; }
        public String fiscalYear {get;set;}
        public Integer data {get;set;}
        public Integer FY14 {get;set;}
        public Integer FY15 { get; set; }
        public Integer FY16 { get; set; }
        public String FY14_Name {get;set;}
        public String FY15_Name {get;set;}
        public String FY16_Name {get;set;}
   
        public Data(String month, Integer fy14, Integer fy15, Integer fy16) {
            this.month = month;
            this.FY14 = fy14;
            this.FY15 = fy15;
            this.FY16 = fy16;
        }
    }