public class AgentErrorWrapper {

public String agentName{get;set;}
public String errorType{get;set;}
public Date edate {get;set;}
public Integer errorCount {get;set;}

public void AgentErrorWrapper(String agentName, String ErrorType, Date edate, Integer errorCount){
    this.agentName = agentName;
    this.ErrorType = ErrorType;
    this.edate = edate;
    this.errorCount = errorCount;
}




}