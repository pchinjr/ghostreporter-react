trigger SentimentTrigger on Case (before insert) {
    //maybe build list here
    List<Case> caseList = new List<Case>();
    //add only cases that have not yet been analyzed 
    for(Case c : trigger.new)
    {
        if(c.isAnalyzed__c == false)
        {
            caseList.add(c);
        }

    }
    //Send case list to be scored by SentimentAnalysis_B class 
    SentimentAnalysis_B scorer = new SentimentAnalysis_B();
    scorer.caseScorer(caseList);
        
}