public class UserInfo {
    private static Boolean available = false;
    private static Boolean isAvailable = false;
    private static Boolean cached = false;
    
    
    
    public static Boolean getUserInfo(){
         
        if(cached) return isAvailable;
        cacheUser();
        
        return Available;
    }
    
    private static void cacheUser(){
        String userid;
        
        User usr = [select id, available__c from user where id=:System.UserInfo.getUserId()];
        isAvailable = usr.available__c;
        
        cached = true;
        
    }
    
    
}