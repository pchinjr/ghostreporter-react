public class CaseDetail_Wrapper {
public String agent {get;set;}
public String origin {get;set;}
public String source {get;set;}
public String status {get;set;}
public String priority {get;set;}
public Integer inprogress {get;set;}
public Integer unassigned {get;set;}
public Integer closed {get;set;}
public Integer promoted {get;set;}
public Integer queue {get;set;}
public String description{get;set;}
public String NoteType{get;set;}
public String caseNumber{get;set;}
public Integer avgHandle {get;set;}
public Boolean isCurrent {get;set;}
public DateTime maxDate{get;set;}
public String caseId {get;set;}
public Time caseAge {get;set;}
public String minute; 
public String second;
public String hour;
public String formattedTime{get;set;}
public DateTime crtdate{get;set;}
public String timeId{get;set;}

public CaseDetail_Wrapper(){}

public CaseDetail_Wrapper(String timeID, String aname, String origin, String source, String status, String description, String noteType, String cid, DateTime crtReviewDT, String casenumber,
                            String currentCaseNumber){
  this.agent = aname;
  this.origin = origin;
  this.source = source;
  this.priority = priority;
  this.description = description;
  this.noteType = noteType;
  this.caseId = cid;
  this.casenumber = casenumber;
  this.crtdate = crtReviewDT;
  this.status = status;
  this.caseAge =  GetElapsedTime(crtReviewDt, timeId);
  
    if( this.caseAge.minute() <= 9)
     this.minute =  '0' + this.caseAge.minute();
    else
     this.minute = '' + this.caseAge.minute();
  
    if( this.caseAge.hour() <= 1)
     this.hour = '0' +  this.caseAge.hour();
    else
     this.hour = '' + this.caseAge.hour();
    
    if(this.caseAge.second() <= 9)
     this.second = '0' + this.caseAge.second();
    else
      this.second = '' +  this.caseAge.second();
    
   this.formattedTime =  this.hour + ':' + this.minute + ':' + this.second;

 
  if(this.casenumber == currentCaseNumber)
   this.iscurrent = true;
  else
   this.iscurrent = false;                              
                               
                               
                               
                               
}

public Time GetElapsedTime(DateTime startTime, String timeID1)
{
    if(startTime == null )
        return Time.newInstance(0, 0, 0, 0);
String timeId = timeId1;

Long milliseconds = BusinessHours.diff(timeId,startTime, DateTime.now());
   System.debug('milliseconds=' + milliseconds + ' in int=' + (Integer)milliseconds);
Long seconds = milliseconds / 1000;
Long minutes = seconds / 60;
Long hours = minutes / 60;
Long days = hours / 24;

     
    System.debug(Time.newInstance((Integer)hours, (Integer)minutes, (Integer)seconds, (Integer)milliseconds));
    return Time.newInstance((Integer)hours, (Integer)minutes, (Integer)seconds, (Integer)milliseconds);
}
 
 
public Integer getOne(){
    
    return 1;
}




}