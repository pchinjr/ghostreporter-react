trigger Case_Shuffle on Case (after update) {

    List<User> users = [select Id, Lastlogindate from User where profile.name = 'CRT Member' and available__c = true];
    
    String test = UserInfo.getProfileId();
    
    String id = [select Id from Profile where Name = 'CRT Member' limit 1].id;
    
    // Only run if the user is a CRT Member
    if (test == id) {
        // Loop through the Available CRT Members, check if they have zero cases, redistribute cases if they do
        for (User testUser : users) {
            if (getUserCases(testUser.id) == 0) { 
                Case_Allocator shuffler = new Case_Allocator();
                break;
            }
        }
    }
    
    // Return the number of Unassigned cases that belong to a user
    public Integer getUserCases(String userId) {
    
        return [select count() from Case where OwnerId = :userId and Status = 'Unassigned' and isClosed = false];
    }   
}