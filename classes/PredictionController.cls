public class PredictionController {
	
    
    public static void organizeCases(List<Case> casesToBeOrganized)
    {
        System.debug('PrectionController activated');
        for(Case c : casesToBeOrganized)
        {
            if(c.GoogleLabel__c == '"Extreme"')
            {
                //Do logic
                //test is simply marking isMoved to true 
                c.isMoved__c = true; 
            }
            
            else if(c.GoogleLabel__c == '"High"')
            {
                //Do logic
                c.isMoved__c = true;
            }
            
            else if(c.GoogleLabel__c == '"Medium"')
            {
                //Do logic
                c.isMoved__c = false; 
            }
            
            else if(c.GoogleLabel__c == '"Low"')
            {
                //Do logic
                c.isMoved__c = false; 
            }
            
        }
        
        if(Test.isRunningTest())
        {
            System.debug('Test is running');
        }
        else{
            update casesToBeOrganized; 
        }
    }
    
}