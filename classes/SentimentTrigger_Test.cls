@isTest
global class SentimentTrigger_Test {
	//run Positive test cases 
	static testMethod void runPositiveTestCases()
    {
        Case testCase = new Case(Description = 'This has been the most vile disgusting customer service experience that I have ever had. I hate this company!');
        insert testCase; 
        update testCase; 
    }
}