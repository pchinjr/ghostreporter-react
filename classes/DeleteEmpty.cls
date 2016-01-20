public class DeleteEmpty {

public List<Case> caseList{get;set;}
public List<Case> tempList{get;set;}

public DeleteEmpty(List<Case> newCase){
    this.caseList = newCase;
    deleteEmptyCase();
}


public void deleteEmptyCase(){
    tempList = new List<Case>();
 
    if(this.caseList != null){
    
    for(Integer x = 0, j = this.caseList.size(); x < j; ++x){    
       
        if(this.caseList[x].origin == null && this.caseList[x].Description == null && this.caseList[x].Origin != 'email'){
             tempList.add(this.caseList[x]);
        } 
    
        
    }
        System.debug('deleted case' +  tempList[0].id);
        
        delete tempList;
        
        if(tempList[0].id != null){
          System.debug('isnull=' + tempList[0].id);
        }
    }
    
    
    
}

}