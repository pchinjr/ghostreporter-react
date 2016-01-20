public class SentimentAnalysis_B {
 
    map<String, double> valueMap = new map<String, double>();
    
    
    public String testString = 'I have been working with OUC for the past ten years and I am extremely upset with the poor service that I have received over the past several days. The service has been slow and at times confrontational. I will not be continuing my service with this company. Sincerely a dissatisfied customer.';
    public String testString2 = 'This has been the most vile disgusting customer service experience that I have ever had. I hate this company!';
    public String testString3 = 'Thank you so much for the wonderful service. I am truly satisfied with everything. The representative was polite and patient. Thanks again.';
    public String testString4 = 'This place keeps messing up all of my orders, it is terrible.';
    public String testString5 = '';
    Integer testScore = -1; //Calculated by hand, used for testing. 
 
    //constructor for testing 
    public SentimentAnalysis_B()
    {
        
    }
    
    //constructor for single case 
    public SentimentAnalysis_B(String toAnalyze)
    {
        if(toAnalyze.equalsIgnoreCase('Bulk'))
        {
            testAll();
        }
        else if(toAnalyze.equalsIgnoreCase('rescore'))
        {
            rescoreAll();
        }
        else {
            Map<String, double> affectiveWordMap = new Map<String, double>();
            System.debug('Test score = '+ scoreText(toAnalyze, affectiveWordMap));
        }
                    
    }
    
    //Contructor to test all uunalalyzed cases. 
    public SentimentAnalysis_B(Integer EnterAnyNumberToRunBulk)
    {
        testAll();
    }

    
    /**
     * Builds map of word value pairs using query to Sentiment Table object 
     * Map will only contain the words that are in the sentece. 
     * 
     */
	public void mapBuilder2()
    {
        List<Sentiment_Table__c> sb = [SELECT Word__c, Value__C from Sentiment_Table__c];
        for(Sentiment_Table__c st : sb)
        {
            valueMap.put(st.Word__c, st.Value__c);
        }
        
    }
    
    

    /**
     * Recieves list of cases from trigger, gets score for case and updates case with score
     * @author Mike McGee 
     * @param caseList list of cases to be scored
     */
    public void caseScorer(List<Case> caseList)
    {
        if(caseList.size() > 10)
        {
            testAll();
            return;
        }
       
        //If case list is too big it will exceed sql querie limit, use map to score
       /* if(caseList.size() > 10){
            mapBuilder2();

            for(Case c : caseList)
            {
                Map<String, double> affectiveWordMap = new Map<String, double>();
                double score = scoreTextWithMap(c.Description, affectiveWordMap); 
                c.SentimentScore__c = score; 
                c.isAnalyzed__c = true;
                
                //Build string of affective words to add to AffectiveWords__c
                String affective = ''; 
                for(String word : affectiveWordMap.keySet())
                {
                    String temp = '"' + word + ' , ' + affectiveWordMap.get(word)+'"'; 
                    affective += temp;
                    
                }
                
                c.Affective_Words__c = affective; 
            }
        }*/
        else{
            for(Case c : caseList)
            {
                Map<String, double> affectiveWordMap = new Map<String, double>();
                double score = scoreText(c.Description, affectiveWordMap); 
                c.SentimentScore__c = score; 
                c.isAnalyzed__c = true;
                
                //Build string of affective words to add to AffectiveWords__c
                String affective = ''; 
                for(String word : affectiveWordMap.keySet())
                {
                    String temp = ' "' + word + ' , ' + affectiveWordMap.get(word)+'" '; 
                    affective += temp;
                    
                }
                
                c.Affective_Words__c = affective;
            } 
        }
       	
        
        
        //if(Test.isRunningTest())
        //{
        //    system.debug('Test is running');
        //}
       	//else
       	//
        try{
            update caseList;
        }catch(SObjectException e){}
    }

    
    //To test all non aanlyzed cases
    /**
     * Gets sentiment score for all non analyzed cases
     * @author Mike McGee 
     */ 
    public void testAll()
    {
        mapBuilder2();
        List<Case> caseList = [SELECT Id, Description FROM Case WHERE isAnalyzed__c = false]; 
        
        if(caseList.size() > 199)
        {
            String query = 'SELECT Id, Description FROM Case WHERE isAnalyzed__c = false';
           	Id batchInstanceId = Database.executeBatch(new SentimentAnalysis_Batch(query, valueMap));
			
        }
        
        else {
            
            Map<String, double> affectiveWordMap = new Map<String, double>();
            for(Case c : caseList)
            {
                double score = scoreTextWithMap(c.Description, affectiveWordMap);
                system.debug('Score for case: '+c.Id+' = '+score);
                //add score to case or move case based on level of score 
                c.SentimentScore__c = score; 
                c.isAnalyzed__c = true; 
                
                //Build string of affective words to add to AffectiveWords__c
                String affective = ''; 
                for(String word : affectiveWordMap.keySet())
                {
                    String temp = ' "' + word + ' , ' + affectiveWordMap.get(word)+'" '; 
                    affective += temp;
                    
                }
                
                c.Affective_Words__c = affective;
            }
            //if(Test.isRunningTest()){
                //System.debug('Test running...');
            //}   
            //else 
            try{
                update caseList; 
            }catch (SObjectException e){}
            	 
            
        }
        
        
    }
    
    public void rescoreAll()
    {
        mapBuilder2();
        List<Case> caseList = [SELECT Id, Description FROM Case ]; 
        
        if(caseList.size() > 199)
        {
            String query = 'SELECT Id, Description FROM Case';
            Id batchInstanceId = Database.executeBatch(new SentimentAnalysis_Batch(query, valueMap));
			
        }
        
        else {
            
            Map<String, double> affectiveWordMap = new Map<String, double>();

            for(Case c : caseList)
            {
                double score = scoreTextWithMap(c.Description, affectiveWordMap);
                system.debug('Score for case: '+c.Id+' = '+score);
                //add score to case or move case based on level of score 
                c.SentimentScore__c = score; 
                c.isAnalyzed__c = true; 
                
                //Build string of affective words to add to AffectiveWords__c
                String affective = ''; 
                for(String word : affectiveWordMap.keySet())
                {
                    String temp = ' "' + word + ' , ' + affectiveWordMap.get(word)+'" '; 
                    affective += temp;
                    
                }
                
                c.Affective_Words__c = affective;
            }
            //if(Test.isRunningTest()){
                //System.debug('Test running...');
            //}   
            //else 
            
            try{
               update caseList;
            }catch(SObjectException e){}
            	  
            
        }
    }
    
    
    
        /**
     * Gets a sentiment score for the string passed in.
     * @author  Mike McGee 
     * @param toTest string description of the case
     * @return double value of sentiment score 
     */ 
    public double scoreText(String toTest, Map<String, double> affectiveWordMap)
    {
        if(toTest == null || toTest.length()== 0)
        {
            return 0; 
        }
        
       	//Use a list to track score and matches so it can be passed by reference to scoring method. 
        //declaration of score and matches left for readeability
        Double score = 0; 
        Double matches = 0;
        List<Double> scoreANDMatches = new List<Double>();
        scoreANDMatches.add(score);
        scoreANDMatches.add(matches);
        
        
        //break string into words
        String[] listOfWords = toTest.split('\\s+');
        //build value list
        List<Sentiment_Table__c> valueTable1 = [SELECT Value__C, Word__c from Sentiment_Table__c where Word__C IN :(listOfWords)];
        //score list one
        scoreListWithValueTable(valueTable1, scoreANDMatches);
        
        //add affective words to affective word table. 
            for(Sentiment_Table__c s : valueTable1)
            {
                affectiveWordMap.put(s.Word__c, s.Value__C);
            }
        
        //Need list of two word combos to test
        //Description must be at least 2 words long to build double word list
        if(listOfWords.size() > 2){
            
            String[] listOfDoubleWords = new String[listOfWords.size()-1];
            
            for(Integer i = 0; i < listOfWords.size()-1; i++)
            {
                listOfDoubleWords[i] = listOfWords[i]+' '+listOfWords[i+1]; 
            }
            
            List<Sentiment_Table__c> valueTable2 = [SELECT Value__C, Word__c from Sentiment_Table__c where Word__C IN :(listOfDoubleWords)];
            scoreListWithValueTable(valueTable2, scoreANDMatches);
			
            //add affective words to affective word table. 
            for(Sentiment_Table__c s : valueTable2)
            {
                affectiveWordMap.put(s.Word__c, s.Value__C);
            }
        }
        
        //Need list of three word combos to test
        //Description must be at least 3 words long to build double word list
        if(listOfWords.size() > 3){
            
            String[] listOfTripleWords = new String[listOfWords.size()-2];
            
            for(Integer i = 0; i < listOfWords.size()-2; i++)
            {
                listOfTripleWords[i] = listOfWords[i]+' '+listOfWords[i+1] + ' '+listOfWords[i+2]; 
            }
            
            List<Sentiment_Table__c> valueTable3 = [SELECT Value__C, Word__c from Sentiment_Table__c where Word__C IN :(listOfTripleWords)];
            scoreListWithValueTable(valueTable3, scoreANDMatches);
            
			//add affective words to affective word table. 
            for(Sentiment_Table__c s : valueTable3)
            {
                affectiveWordMap.put(s.Word__c, s.Value__C);
            }            
        }

        if(scoreANDMatches[1] == 0)
        {
            return 0;
        }

        //0 index is score, 1 index is matches
        return scoreANDMatches[0] / scoreANDMatches[1];
    }
    
    /**
     * Scores word list based off of value table pased in
     * updates score and matches in list.
     * @params valueTable (list of sentiment tables containing values for all words in word list) , 
     * 						scoreANDmatches (list containing score in index 0 and matches in index 1)
     */
    public void scoreListWithValueTable(List<Sentiment_Table__c> valueTable, List<Double> scoreANDMatches)
    {
        System.debug(valueTable);
        for(Sentiment_Table__c st : valueTable )
        {
            //0 index is score, 1 index is matches
            scoreANDMatches[0] += st.Value__c;
            scoreANDMatches[1] += 1;
        }
    }
    
    
    
    
    /**
     * Scores a s string of text using map. Used for bulk testing to avoid governor limits on 
     * @author Mike McGee 
     * @param text description of case to score 
     * @returns sentiment score 
     */ 
    public double scoreTextWithMap(String text, Map<String, double> affectiveWordMap )
    {
        if(text == null || text.length() == 0)
        {
            return 0; 
        }
		
        //Use a list to track score and matches so it can be passed by reference to scoring method. 
        //declaration of score and matches left for readeability
        double score = 0; 
        double matches = 0; 
        List<double> scoreANDMatches = new List<double>();
        scoreANDmatches.add(score);
        scoreANDmatches.add(matches);
        
        //break string into words
        String[] listOfWords = text.split('\\s+');
		//score list of single words
		scoreListWithMap(listOfWords, scoreANDmatches, affectiveWordMap);
        
        //Description must be at least two words long to build double word list
        if(listOfWords.size() > 2){        
        
            String[] listOfDoubleWords = new String[listOfWords.size()-1];
            //Need list of two word combos to test
            for(Integer i = 0; i < listOfWords.size()-1; i++)
            {
                listOfDoubleWords[i] = listOfWords[i]+' '+listOfWords[i+1]; 
            }
            
            //score double word list 
            scoreListWithMap(listOfDoubleWords, scoreANDmatches, affectiveWordMap);
        
        }
        
        //Description must be at least three words long to build triple word list. 
        if(listOfWords.size() > 3){
            String[] listOfTripleWords = new String[listOfWords.size()-2];
            //Need list of three word combos to test
            for(Integer i = 0; i < listOfWords.size()-2; i++)
            {
                listOfTripleWords[i] = listOfWords[i]+' '+listOfWords[i+1] + ' '+listOfWords[i+2]; 
            }
            
                 
            //score triple word list
           	scoreListWithMap(listOfTripleWords, scoreANDmatches, affectiveWordMap);
        }
        
        
        //Must check that matches exist in order to not divide by zero
        if(scoreANDmatches[1] == 0)
        {
            return 0; 
        }
        
        else 
        {
            //0 index is score, 1 index is matches
            return scoreANDmatches[0] / scoreANDmatches[1]; 
        }
            
        
    }
    
    
    /**
     * updates scoreANDmatches List using passed in wordList
     * Method for scoring list of words, must pass in Lists because prmitive variables cannot be passed by reference in apex 
     * @params wordList (list of words to be scored), scoreANDmatches (list containing the score in the 0 index and matches in the 1 index)
     */
    public void scoreListWithMap(List<String> wordList, List<double> scoreANDmatches, Map<String, double> affectiveWordMap)
    {
        for(String s : wordList)
        {
            //all words in map are in lower case 
                s = s.toLowerCase();
                
                 double toAdd = valueMap.get(s);
                
                if(toAdd != null)
                {
                    affectiveWordMap.put(s, toAdd);
                    //0 index is score, 1 index is matches
                    scoreANDmatches[0] += toAdd; 
                    scoreANDmatches[1] += 1; 
                }
        }
    }
    
}