public with sharing class ChartsController {
	public ChartsController() {
		
	}

  //select fy_actual__c, count(casenumber) from case where isclosed = true group by calendar_month(closeddate), fy_actual__c

	public List<ChartData> getCaseCountFY() {
		List<AggregateResult> caseList = [select calendar_month(closeddate) month, count(fy_actual__c) ccount from case
		where isclosed = true group by calendar_month(closeddate)];

		List<ChartData> dataList = new List<ChartData>();
		for (AggregateResult ar: caseList) {
			datalist.add(new ChartData(String.valueOf(ar.get('month')), 
									   Integer.valueOf(ar.get('ccount'))));
		}

		return datalist;
	}


	public List<ChartData> getAverageAgeByCaseReason() {
		List<AggregateResult> caseList = [SELECT 
			Reason, AVG(Case_Age_In_Business_Hours__c) avgAge FROM Case
			WHERE Case_Age_In_Business_Hours__c != null
			GROUP BY Reason ORDER BY AVG(Case_Age_In_Business_Hours__c) DESC];

		List<ChartData> dataList = new List<ChartData>();
		for (AggregateResult ar: caseList) {
			datalist.add(new ChartData(String.valueOf(ar.get('Reason')), 
									   Integer.valueOf(ar.get('avgAge'))));
		}

		return datalist;
	}

	public List<ChartData> getAverageAgeOfClosedCases() {
		List<AggregateResult> caseList = [SELECT 
			AVG(Case_Age_In_Business_Hours__c) age, 
			FISCAL_MONTH(ClosedMonth__c) month 
			FROM Case WHERE ClosedMonth__c != null
			GROUP BY FISCAL_MONTH(ClosedMonth__c) 
			ORDER BY FISCAL_MONTH(ClosedMonth__c)];

		List<ChartData> chartList = new List<ChartData>();
		for (AggregateResult ar: caseList) {
			chartList.add(new ChartData(
				String.valueOf(intToFiscalMonth(Integer.valueOf(ar.get('month')))),
				Integer.valueOf(ar.get('age')))
			);
		}

		return chartList;
	}


	 public static String intToFiscalMonth(Integer fiscalMonth) {
		Integer FiscalYearStartMonth  = [SELECT FiscalYearStartMonth 
			FROM Organization 
			WHERE Id =: System.UserInfo.getOrganizationId()].FiscalYearStartMonth ;

		Integer relativeMonth = 
			Math.mod( (fiscalMonth + FiscalYearStartMonth ), 13);

		return DateHelper.getMonthText(relativeMonth);
	}


	public List<ChartData> getCaseClosedByMonth() {
		List<AggregateResult> caseList = [SELECT COUNT(Id) tot, ClosedMonth__c
			FROM Case WHERE ClosedMonth__c != null
			GROUP BY ClosedMonth__c ORDER BY ClosedMonth__c];

		List<ChartData> chartList = new List<ChartData>();
		for (AggregateResult ar: caseList) {
			chartList.add(new ChartData(String.valueOf(ar.get('ClosedMonth__c')),
										Integer.valueOf(ar.get('tot'))));
		}

		return chartList;
	}

	public List<ChartData> getCaseCountByReason() {
		List<AggregateResult> caseList = [SELECT COUNT(Id) tot, Reason
			FROM Case WHERE Reason != null
			GROUP BY Reason ORDER BY Reason];

    	return toChartData(caseList, 'tot', 'Reason');
	}


	public List<AggregateResult> getCaseCountByReasonComplex() {
		return [SELECT CALENDAR_MONTH(CreatedDate) createdMonth, count(id) num,
			   COUNT(reason) reason
			   FROM Case WHERE reason != null 
			   GROUP BY CALENDAR_MONTH(CreatedDate), FISCAL_MONTH(CreatedDate) 
			   ORDER BY FISCAL_MONTH(CreatedDate)];	
	}


	public List<ReasonWrapper> getCaseReasonSplit() {
		List<AggregateResult> agg = 
				[select CALENDAR_MONTH(CreatedDate) createdMonth, 
				count(id) reasonCount, reason 
				from case where reason != null 
				group by reason, CALENDAR_MONTH(CreatedDate), FISCAL_MONTH(CreatedDate) 
				ORDER BY FISCAL_MONTH(CreatedDate)];

		Set<ReasonWrapper> reasonList = new Set<ReasonWrapper>();
		for (AggregateResult a: agg) {
			reasonList.add(ReasonWrapper.getInstance(a));
		}

		System.debug('Reason list: '+ reasonList);

		return new List<ReasonWrapper>(reasonList);
	}

	

	public List<ChartData> toChartData(List<AggregateResult> aggList,
									   String aggField,
									   String catField) {
		
		List<ChartData> datalist = new List<ChartData>();
		for (AggregateResult ar: aggList) {
			datalist.add(new ChartData(String.valueOf(ar.get(catField)),
									   Integer.valueOf(ar.get(aggField))));
		}

		return datalist;
	}
}