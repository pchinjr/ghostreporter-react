public class CaseAssign {
public List<AggregateResult> caseCountbyUser {get;set;}
public String userid {get;set;}
public Case currentCase {get;set;}
public String minUserId {get;set;}
public Boolean amountsEqual {get;set;}
public List<User> caseuser {get;set;}

public CaseAssign(Case caseAssign, List<User> caseuser){
    this.currentCase = caseAssign;
    this.caseuser = caseuser;
    System.debug('currentCase:' + this.currentCase.ownerid + ', getTheUser:' + getTheUser());
    minUserId = getTheUser();
    this.currentCase.ownerid = minUserId;
    //insert this.currentCase;
}

//will return the user with least cases or a random user
//when all users have the same quantity of cases.
public String getTheUser(){
    Integer counter;
    Integer totalCount;
    Integer firstCount;
    counter = 0;
    totalCount = 0;
    List<AggregateResult> userList = [select owner.id uid, count(casenumber) ucount  from case group by owner.id order by count(casenumber) asc];
   
   //Assign case to user with least cases, if all equal random assign
    for(Integer x = 0 ; x < userList.size(); x++){
        //first user in list should be the min count user
        if(x==0){
           minUserId = String.valueof(userList[x].get('uid'));
           userid = minUserId;
           firstCount = Integer.valueof(userList[x].get('ucount'));
        }
        totalCount = totalCount + Integer.valueof(userList[x].get('ucount')); 
    }
   
    //determine if all users have equal cases 
    if((totalCount / userList.size()) == firstCount){
        //do some random assignment
        this.amountsEqual = true;
        //call some random function
        userid = getRandomUser(this.caseuser, userList.size()).id;
        
        return userid;
        
    }
    System.debug('userid:'+userid);
    return userid; 
}

//returns a random user from the user List
public User getRandomUser(List<User> ruser, Integer maxSize){
    return ruser[Math.round(Math.random() * (maxSize - 1)) + 1];
}

}