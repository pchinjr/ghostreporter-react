public with sharing class Case_Age_Calculator {
	
	private Case currentCase; //case that we are calculating times for  
	private DateTime creationOfCase; //Date that case was created
	private DateTime toInProgress; 	//Date case was addigned to someone and put in progress 
	private DateTime caseClosed; //Date case was closed 
	private double hoursUnassigned; //Total hours case was unassigned (toIPprogress - creationOfCase)
	private double hoursInProgress; //Total hours case was in progress (caseClosed - toInProgress)
	
	
	public Case_Age_Calculator(Case currentCase)
	{
		this.currentCase = currentCase;
	}
	
	//Check for status of case
	public void caseStatus(){
		if(currentCase.Status == 'Unassigned')
		{
			creationOfCase = System.now();
		}
		
		else if(currentCase.Status == 'In Progress')
		{
			toInProgress = System.now();
			hoursUnassigned = BusinessHours.diff('01mi0000000HldpAAC', creationOfCase, System.now());
			//toInProgress - creationOfCase;
			currentCase.Hours_Until_InProgress__c = hoursUnassigned;  
		}
		
		else if(currentCase.Status == 'Closed')
		{
			caseClosed = System.now();
			hoursInProgress = BusinessHours.diff('01mi0000000HldpAAC', toInProgress, System.now());
			//caseClosed - toInProgress;
			currentCase.Hours_UntilClosed__c = hoursInProgress; 
		}
	}
	
	
	
}