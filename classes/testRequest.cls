global with sharing class testRequest {
    public static Integer counter {get;set;}
 
    
    public void testRequest(){
    counter = 0;   
    }
    
    
    public void insertRequest(String userid){

        
        Request__c req = new Request__c(userid__c=userid);
        insert req;
         
        
    }


    
    public void processRequest(){
        
        
        List<Case> newcase =  [select id, casenumber from case limit 3];
        
        List<Request__c> req = [select userid__c, caseid__c, isprocessed__c from Request__c where isprocessed__c = false];
        
        System.debug('size=' + req.size());
        
        System.debug('newcase size=' + newcase.size() + ', req size=' + req.size());
        
        for(Integer x=0;x<req.size(); x++){
           
            System.debug('inx row:' + x);
             
            
                req[x].caseid__c = String.valueof(x);
                req[x].isprocessed__c = true;
                newcase.remove(x);
             
        }
          
              update req;
        
        List<Request__c> req2 = [select userid__c, caseid__c, isprocessed__c from Request__c where isprocessed__c = false];
        System.debug('req2 size:' + req2);
        
        
    }



}