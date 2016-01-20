public class BatchTestFactory {

public void BatchTestFactory(){}

    public static void insertRec(){
    List<AgentRankStarter__c> ars = new List<AgentRankStarter__c>();
    
      for(Integer x=0; x <= 1600; x++){
          AgentRankStarter__c ag = new AgentRankStarter__c();
          ag.LastRankDateTime__c = DateTime.Now();
          ag.rankkey__c = 'key' + x;
          ars.add(ag);
          }
      insert ars;
    }

   public static void deleteAll(){
     List<AgentRankStarter__c> delars = [select id from AgentRankStarter__c];  
       for(AgentRankStarter__c c: delars){
           delars.add(c);
       }
       
       delete delars;
   }
   
   public static void updateArs(){
     List<AgentRankStarter__c> upArs = [select rankkey__c from AgentRankStarter__c];  
       if(upArs.size() > 50){
           startBatch();
       }
       else
         {
             //regular update
             
         }
       
   }
   
    public static void startBatch() {
         String query = 'select id, LastRankDateTime__c, rankkey__c from AgentRankStarter__c';
        Id batchInstanceId = Database.executeBatch(new Batch_RubensTest(query), 50); 
    }
    
    public static void startInsertBatch() {
        //cast all sOjbects in scope to cases in order to consolidate. 
        List<AgentRankStarter__c> ars = new List<AgentRankStarter__c>();
        
        //Do something Batchy
        for(Integer x=0; x < 30000; x++){
            AgentRankStarter__c newars = new AgentRankStarter__c();
            newars.rankkey__c = x + '123';
            newars.LastRankDateTime__c = DateTime.now();
            ars.add(newars);
        }
        
        Id batchInstanceId = Database.executeBatch(new Batch_Template_Insert(ars), 50); 
    }
    
    
}