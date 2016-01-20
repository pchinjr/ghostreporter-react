@isTest
global class SentimentAnalysis_B_Test {
	//run positive test cases 
	static testMethod void runPositiveTestCases()
    {
        //Test for single case 
        SentimentAnalysis_B test = new SentimentAnalysis_B(); 
        //not real tests ; used for code coverage
        system.assertEquals(test.testString, 'I have been working with OUC for the past ten years and I am extremely upset with the poor service that I have received over the past several days. The service has been slow and at times confrontational. I will not be continuing my service with this company. Sincerely a dissatisfied customer.');
        system.assertEquals(test.testString2, 'This has been the most vile disgusting customer service experience that I have ever had. I hate this company!');
        
        test.mapBuilder(); 
        system.assertEquals(test.scoreText(test.testString), -1);
        
        //Test for bulk case 
        List<String> descriptionList = new List<String>();
            
       	String s1 = 'I have been working with OUC for the past ten years and I am extremely upset with the poor service that I have received over the past several days. The service has been slow and at times confrontational. I will not be continuing my service with this company. Sincerely a dissatisfied customer.'; 
       	String s2 = 'This has been the most vile disgusting customer service experience that I have ever had. I hate this company!';
       	String s3 = 'Thank you so much for the wonderful service. I am truly satisfied with everything. The representative was polite and patient. Thanks again.'; 
       	String s4 = 'This place keeps messing up all of my orders, it is terrible.';
        
        descriptionList.add(s1);
        descriptionList.add(s2);
        descriptionList.add(s3);
        descriptionList.add(s4);
        
        test.bulkScorer(descriptionList);
        
        test.testAll();
        List<Case> caseList = [Select Id, Description from Case WHERE isAnalyzed__c = false]; 
        test.caseScorer(caseList); 
    }
}