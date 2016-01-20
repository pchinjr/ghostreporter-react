public class SevereStreamController{

    public List<Case> severeCase {get; set;}
    public String caseId {get;set;}
    public SevereStreamController(){
        reloadSevereCase();
    }
    public void reloadSevereCase(){
        severeCase = [select id, status, priority, origin from case where status = 'Unassigned' and priority='Severe' order by createddate limit 1];
    }
   

}