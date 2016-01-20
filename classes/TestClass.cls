public class TestClass {
    
    private List<Case> ccase{get;set;}
    
    
    public TestClass(){
        ccase = getNewCases();
        
    }


    private List<Case> getNewCases(){
        
        
        return [select id from case where status = 'Unassigned' and createddate = today];
    }
    
    private void changeOwner(List<Case> ccase){
        String adminId = [select id from user where profile.name = 'Administrator' and user.name = 'Ruben Ortiz' limit 1].id;
        
        for(Case c: ccase){
            c.ownerid = adminId;
            ccase.add(c);    
        }
        
        update ccase;
        
        
    }

}