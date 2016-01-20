public class StatWrapper {
		public Boolean isHeader{get;set;}
		public Boolean isSummary{get;set;}
		public Integer dep{get;set;}
		public Integer wrongSa{get;set;}
		public Integer satSun{get;set;}
		public Integer ato{get;set;}
		public Integer noConn{get;set;}
		public Integer sas{get;set;}
		public Integer mail{get;set;}
		public Integer fa{get;set;}
		public Integer allSas{get;set;}
		public Integer payPlan{get;set;}
		public Integer misc{get;set;}
		public Integer wrongAdd{get;set;}
		public Integer tot{get;set;}
		public String agentName{get;set;}

		public StatWrapper(Boolean isHeader, Boolean isSummary, Integer dep, 
			Integer wrongSa, Integer satSun, Integer ato, Integer noConn, 
			Integer sas, Integer mail, Integer fa, Integer allSas, 
			Integer payPlan, Integer misc, Integer wrongAdd, Integer tot,
			String agentName) {

			this.isHeader = isHeader;
			this.isSummary = isSummary;
			this.dep = dep;
			this.wrongSa = wrongSa;
			this.satSun = satSun;
			this.ato = ato;
			this.noConn = noConn;
			this.sas = sas;
			this.mail = mail;
			this.fa = fa;
			this.allSas = allSas;
			this.payPlan = payPlan;
			this.misc = misc;
			this.wrongAdd = wrongAdd;
 
			    this.tot = tot;
	 
			this.agentName = agentName;
		}

		// Constructor for only making a header row.
		public StatWrapper(Boolean isHeader) {
			this(isHeader, false, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '');
		}
	}