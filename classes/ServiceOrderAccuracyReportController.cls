public with sharing class ServiceOrderAccuracyReportController {

	public Date m_date{get;set;}

	public Boolean m_isReportRun{get;set;}

	public String m_agentType{get;set;}

	public String m_month{get;set;}

	public Integer m_year{get;set;}

	public Date m_today{get;set;}

	public Integer m_totalErrors{get;set;}

	public ServiceOrderAccuracyReportController() {
		m_date = Date.today();
		m_isReportRun = false;
		m_agentType = 'Commercial';
		m_today = Date.today();
		m_totalErrors = 0;
	}



	public List<StatWrapper> getData(){
        //Set isReport run to true and calculate the first and last days of the month
		m_isReportRun = true;
		Integer numberOfDays = Date.daysInMonth(m_date.year(), m_date.month());
		Date firstOfMonth = Date.newInstance(m_date.year(), m_date.month(), 1);
		Date lastOfMonth = Date.newInstance(m_date.year(), m_date.month(), numberOfDays);
        
        //Make new list to hold errors
        List<AgentErrors__c> errorList = new List<AgentErrors__c>();
        
        //Get a list of the rollup fields
		List<AgentErrors__c> rollUpList = getRollUpList(firstOfMonth, lastOfMonth);
		
        //Place all of the rollUpList into the errorList
        for (AgentErrors__c roll: rollUpList) {
            roll.Deposit__c = roll.RollUp_Deposit_Error__c;
			roll.WrongSA__c = roll.RollUp_Wrong_SA__c;
			roll.Sat_Sun_Holiday__c = roll.RollUp_Sat_Sun_Holiday__c;
			roll.ATO__c = roll.RollUp_ATO__c;
			roll.NoConnectionCharge__c = roll.RollUp_No_Connection_Charge__c;
			roll.SelectedTooManySAS__c = roll.RollUp_Selected_Too_Many_Sas__c;
			roll.MailingAddress__c = roll.RollUp_Mailing_Address__c;
			roll.FaMisc__c = roll.RollUp_Fa_Misc__c;
			roll.AllSasNotSelect__c = roll.AllSasNotSelect__c;
			roll.PayPlan__c = roll.RollUp_Pay_Plan_Error__c;
			roll.Misc__c = roll.RollUp_Misc__c;
			roll.WrongAddress__c = roll.RollUp_Wrong_Address__c;
            
            errorList.add(roll);
        }
        
        //  No Longer need rollUpList
        rollUpList = null;
        
        // If it's empty then don't want to show anything, m_isReportRun needs to be false
		if (errorList.isEmpty()) {
			m_isReportRun = false;
		}

		// Adding agenterrors object that is really a summary object to the
		// list so that it can be displayed in the table. 
		// Make sure this does not get added to the database
		AgentErrors__c tempSummary = new AgentErrors__c();
		AggWrapper summaryWrapper = getSummary();
		tempSummary.Deposit__c = summaryWrapper.dep;
		tempSummary.WrongSA__c = summaryWrapper.wrongSa;
		tempSummary.Sat_Sun_Holiday__c = summaryWrapper.satSun;
		tempSummary.ATO__c = summaryWrapper.ato;
		tempSummary.NoConnectionCharge__c = summaryWrapper.noConn;
		tempSummary.SelectedTooManySAS__c = summaryWrapper.sas;
		tempSummary.MailingAddress__c = summaryWrapper.mail;
		tempSummary.FaMisc__c = summaryWrapper.fa;
		tempSummary.AllSasNotSelect__c = summaryWrapper.allSas;
		tempSummary.PayPlan__c = summaryWrapper.payPlan;
		tempSummary.Misc__c = summaryWrapper.misc;
		tempSummary.WrongAddress__c = summaryWrapper.wrongAdd;
	 
		//tempSummary.Date__c = Date.newInstance(Date.today().year() + 1, 1, 1);
		tempSummary.isTotalsRow__c = true;

		m_totalErrors = summaryWrapper.tot;

		errorList.add(tempSummary);

		//Boolean isHeader, Boolean isSummary, Integer dep, 
		//	Integer wrongSa, Integer satSun, Integer ato, Integer noConn, 
		//	Integer sas, Integer mail, Integer fa, Integer allSas, 
		//	Integer payPlan, Integer misc, Integer wrongAdd, Integer tot

		List<StatWrapper> wrapperList = new List<StatWrapper>();
		// Start by adding a header row.. for formatting
		wrapperList.add(new StatWrapper(true));
		for (AgentErrors__c err: errorList) {
		    if(err.isTotalsRow__c == false){
    			wrapperList.add(
    				new StatWrapper(
    					false, err.isTotalsRow__c, Integer.valueOf(err.Deposit__c),
    					Integer.valueOf(err.WrongSA__c), 
    					Integer.valueOf(err.Sat_Sun_Holiday__c), 
    					Integer.valueOf(err.ATO__c), 
    					Integer.valueOf(err.NoConnectionCharge__c),
    					Integer.valueOf(err.SelectedTooManySAS__c), 
    					Integer.valueOf(err.MailingAddress__c),
    					Integer.valueOf(err.FaMisc__c), 
    					Integer.valueOf(err.AllSasNotSelect__c), 
    					Integer.valueOf(err.PayPlan__c), 
    					Integer.valueOf(err.Misc__c), 
    					Integer.valueOf(err.WrongAddress__c), 
    					Integer.valueOf(err.TotalErrors__c),
    					err.agent__r.fullname__c
    				)
    			);
		    }
		    else{
		        	wrapperList.add(
    				new StatWrapper(
    					false, err.isTotalsRow__c, Integer.valueOf(err.Deposit__c),
    					Integer.valueOf(err.WrongSA__c), 
    					Integer.valueOf(err.Sat_Sun_Holiday__c), 
    					Integer.valueOf(err.ATO__c), 
    					Integer.valueOf(err.NoConnectionCharge__c),
    					Integer.valueOf(err.SelectedTooManySAS__c), 
    					Integer.valueOf(err.MailingAddress__c),
    					Integer.valueOf(err.FaMisc__c), 
    					Integer.valueOf(err.AllSasNotSelect__c), 
    					Integer.valueOf(err.PayPlan__c), 
    					Integer.valueOf(err.Misc__c), 
    					Integer.valueOf(err.WrongAddress__c), 
    					Integer.valueOf(m_totalErrors),
    					err.agent__r.fullname__c
    				)
    			);
		        
		        
		        
		        
		    }
		    
		}


		this.m_month = DateHelper.getMonthText(m_date.month());
		this.m_year = m_date.year();

		//return errorList;
		return wrapperList;
	}

    private List<AgentErrors__c> getRollUpList(Date firstOfMonth, Date lastOfMonth) {
        return [SELECT agent__r.PSERMID__c,
				agent__r.fullname__c,
				RollUp_Deposit_Error__c, RollUp_Wrong_SA__c, 
				RollUp_Sat_Sun_Holiday__c, RollUp_ATO__c, RollUp_No_Connection_Charge__c, 
				RollUp_Selected_Too_Many_SAs__c, RollUp_Mailing_Address__c, RollUp_Fa_Misc__c,
				AllSasNotSelect__c, RollUp_Pay_Plan_Error__c, RollUp_Misc__c, RollUp_Wrong_Address__c, 
				Total_Errors__c, Date__c, IsTotalsRow__c
				FROM AgentErrors__c 
				WHERE Date__c >= :firstOfMonth AND Date__c <= :lastOfMonth
				AND Agent__r.AgentType__c = :m_agentType
				ORDER BY agent__r.fullname__c];
    }

	public AggWrapper getSummary() {
		Integer numberOfDays = Date.daysInMonth(m_date.year(), m_date.month());
		Date firstOfMonth = Date.newInstance(m_date.year(), m_date.month(), 1);
		Date lastOfMonth = Date.newInstance(m_date.year(), m_date.month(), numberOfDays);

		List<AggregateResult> sumList = [SELECT COUNT(agent__r.PSERMID__c) numAge,
				SUM(Deposit__c) dep, SUM(WrongSA__c) wrongSa, 
				SUM(Sat_Sun_Holiday__c) satSun, SUM(ATO__c) ato, 
				SUM(NoConnectionCharge__c) noConn, 
				SUM(SelectedTooManySAS__c) sas, SUM(MailingAddress__c) mail,
				SUM(FaMisc__c) fa, SUM(AllSasNotSelect__c) allSas, 
				SUM(PayPlan__c) payPlan, SUM(Misc__c) misc, 
				SUM(WrongAddress__c) wrongAdd, SUM(TotalErrors__c) tot
				FROM AgentErrors__c 
				WHERE Date__c >= :firstOfMonth AND Date__c <= :lastOfMonth
				AND Agent__r.AgentType__c = :m_agentType];

		AggregateResult summary = sumList.get(0);

		return new AggWrapper(
				Integer.valueOf(summary.get('dep')), 
				Integer.valueOf(summary.get('wrongSa')),
			 	Integer.valueOf(summary.get('satSun')), 
			 	Integer.valueOf(summary.get('ato')), 
			 	Integer.valueOf(summary.get('noConn')),
			 	Integer.valueOf(summary.get('sas')), 
			 	Integer.valueOf(summary.get('mail')),
			 	Integer.valueOf(summary.get('fa')),
				Integer.valueOf(summary.get('allSas')), 
				Integer.valueOf(summary.get('payPlan')), 
				Integer.valueOf(summary.get('misc')),
				Integer.valueOf(summary.get('wrongAdd')), 
				Integer.valueOf(summary.get('tot')),
				Integer.valueOf(summary.get('numAge')));
	}

	public class AggWrapper {
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
		public Integer numAge{get;set;}
		public String label{get;set;}

		public AggWrapper( 
			Integer dep,
			Integer wrongSa,
			Integer satSun,
			Integer ato,
			Integer noConn,
			Integer sas,
			Integer mail,
			Integer fa,
			Integer allSas,
			Integer payPlan,
			Integer misc,
			Integer wrongAdd,
			Integer tot,
			Integer numAge) {


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
			this.numAge = numAge;

			this.label = 'Totals:';
		}
	}








	public void comm() {
		m_agentType = 'Commercial';
		getData();
	}


	public void resd() {
		m_agentType = 'Residential';
		getData();
	}


	public void cont() {
		m_agentType = 'Contractor';
		getData();
	}


}