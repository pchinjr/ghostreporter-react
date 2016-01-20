global with sharing class CaseDetailsController {
	
   transient public String JSONString {get; set;}
    public static String JSONString_Activities {get; set;}
    public String JSONString_CaseChart {get; set;}
    
	public String objId {get; set;}
	public String objType {get; set;}
	public String userName {get; set;}
    
    public Integer in_PC {get; set;}
    public Integer unaC {get; set;}
    public Integer promoC {get; set;}
    
    public Boolean userUpdatedStatus {get; set;}
    public Boolean userStatus {get; set;}
    
    //public static Boolean userIsChangingStatus {get; set;}
    
    public static Case_Allocator shuffler {get; set;}
    public List<Case> crtDetail{get;set;}
    public String timeId{get;set;}
    
    public CaseDetailsController() {
	    retrieveData();
	}
	
	public void retrieveData() {	
	
        
		
		JSONString = getAgentStatsbyOrigin2();
		
	}
	
public String getAgentStatsbyOrigin2 (){
  DateTime maxDT;
  List<CaseDetail_Wrapper> cdw;
  Boolean isCurrent;
  List<User> agent; 
  String caseNumber;
    
  agent = [select name, available__c  from user  where   profile.name = 'CRT Member' 
                    or profile.name = 'CRT Member'  ];
    
 
 
   
  this.crtDetail = [select owner.name , origin, source__c, status, description, Note_Type__c, id, crt_review_dt__c,
                            casenumber, case_age_in_business_hours__c, maxDate__c, priority  
                            from case where owner.profile.name = 'CRT Member' and (status != 'Unassigned' and status != 'Duplicate') 
                            and (maxDate__c = today or crt_review_dt__c = today or closeddate = today)];
    
 User_Wrapper userCase = new User_Wrapper();
   
   
 cdw = new List<CaseDetail_Wrapper>();
 Case tempcase;
 //Loop through agents and get current case number
 
  for(Integer x=0; x < agent.size();x++){
      caseNumber = userCase.getCurrentCaseID(String.valueof(agent[x].get('name')));
  
      for(Integer y=0; y < this.crtDetail.size();y++){
        
         if(agent[x].name == this.crtDetail[y].owner.name){

            cdw.add(new CaseDetail_Wrapper(this.timeId, this.crtDetail[y].owner.name, this.crtDetail[y].origin, this.crtDetail[y].source__c, this.crtDetail[y].status,
            this.crtDetail[y].description, this.crtDetail[y].note_type__c, this.crtDetail[y].id, this.crtDetail[y].crt_review_dt__c, this.crtDetail[y].casenumber,
            casenumber));
         } 
         
      }
 }
   



 return gen_JSON(cdw);
}


 public String gen_JSON(List<CaseDetail_Wrapper> cdw) {  
    
     
        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);

        // Write data to the JSON string.
        gen.writeStartObject();
        
        gen.writeFieldName('data');

        gen.writeStartArray();
        
        for (CaseDetail_Wrapper acc : cdw) {  
          gen.writeStartObject();
          
            if (acc.agent != null)
              gen.writeStringField('Agent', acc.agent);
            else gen.writeNullField('agent');
            
         
            if (acc.origin != null)
              gen.writeStringField('origin', acc.origin);
            else gen.writeNullField('origin');
            
            if (acc.source != null)
              gen.writeStringField('source', acc.source);
            else gen.writeNullField('source');
            
            if (acc.status != null)
              gen.writeStringField('status', acc.status);
            else gen.writeNullField('status');
            
            if (acc.casenumber != null)
              gen.writeIdField('casenumber', acc.casenumber);
            else gen.writeNullField('casenumber');
            
         
            
          gen.writeEndObject();
    }
    
        gen.writeEndArray();
        gen.writeEndObject();
    
        return gen.getAsString();            

  }
	
	
}