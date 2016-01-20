public class SendSevereEmailAlert {
/* Developer: Ruben Ortiz
   Date: 12/30/2016
   Purpose: When an email is sent to crt@ouc.com, a case is generated. The email may contain attachments. 
            A workflow exists that send an email alert to individuals. They now desire to see the files attached
            in the original email. Therefore, the following code has materialized. It is an expression of the 
            hopes and desires of a group of individuals wishing to remain alert and vigilant to the outpouring of severe cases.
  
   Call Order: This Class is called by the following
   Workflow--> CRT Severe Case-1st Response on update of SendSevereEmailAlert__C == true
   CaseTriggerHandler-->HandleAfterUpdate
   
   Test Class: TestEmailAttach
   
*/
public List<Case> ucase {get;set;}
 
 
 


public SendSevereEmailAlert(List<Case> ucase){
    this.ucase = ucase;
    
    System.debug('caseid = ' + this.ucase[0].id);

    //Here we send the email
    if(this.ucase[0].origin == 'Email'){
        sendEmail(this.ucase[0].id, this.ucase[0].contactid);
    }
    
}
/*
A future call was used since the files may not have been attached at the time the case object was committed to the db

*/
 
   @future
   public static void sendEmail(String caseid, String contactid){
       
    
    
    String emailid;
    
    System.debug('in future method, caseid=' + caseid);
    
    //this limit was used to explicitely select the first email and not replies etc...
    emailid = [select id from EmailMessage where parentid =: caseid order by createddate asc limit 1].id;

   System.debug('In future method');
   
   //check for attached files
   List<EmailMessage> em = [select id, parentid, HasAttachment from EmailMessage where id =: emailid];
   System.debug('em size=' + em.size());
   
   //list of users that should receive the email alert
   List<User> userEmails = [select email from user where getSevereAlert__c = true];
   
   //loop through the email messages
   for(EmailMessage e: em){
 
               
					//Get all email address in unique set
					Set<String> setOfContactEmails = new Set<String>();
					Set<String> setOfUserEmails = new Set<String>();
				 
					
					    //Add users that are configured to get the severe alert
				        for(User u: userEmails){
				            
				             
				            //setOfContactEmails.add(u.email);
				           setOfUserEmails.add(u.email);
				        }
				        
 
				 
								
					list<String> listOfEmails = new list<String>();
					//listOfEmails.addAll(setOfContactEmails);
					listOfEmails.addAll(setOfUserEmails);
					listOfEmails.sort();		
				
					//Create the email message body
					Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
					
					//Get the email template
					//EmailTemplate emailTemp = [Select id From EmailTemplate Where developerName = 'CRT_Team_Alert' Limit 1]; //A email template for Cases
	 
	 
	                String bodycontent;
	                String casenumber;
	                String subjectContent;
	                String Description;
	                
	                casenumber = [select casenumber from case where id =: + caseid].casenumber;
	                Description = [select description from case where id =: + caseid].description;



	                
	                bodycontent = '   *** CASE ESCALATION ALERT ***  \n'
	                            + 'The following case has been escalated:  \n'
                                + 'Case: ' + casenumber + '\n'
                                + 'Case description: ' + Description + '\n'
                                + 'Click on the link to access the case:  https://na15.salesforce.com/' + caseid;
	                subjectContent = 'Case # ' + casenumber + ': dsa has been escalated.';
	 
		      		email.saveAsActivity = false;
					//email.settargetObjectId(ContactId);
					//email.setTemplateId(emailTemp.Id);
					email.setwhatId(caseid);
					email.SetToAddresses(listOfEmails);
					//email.setReplyto('rortiz@asd.com');
					email.setPlainTextBody(bodycontent);
					email.setSubject(subjectContent);
					

					if(e.HasAttachment){
						//Create list of Messageing email File Attachments
						list<Messaging.EmailFileAttachment> fileAttachments = new list<Messaging.EmailFileAttachment>();
				
					    list<Attachment> allAttachmentsInEmail = [Select Name, ContentType, Body From Attachment Where parentId =: e.id]; 
			 
						for(Attachment a: allAttachmentsInEmail){
							Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
							efa.setFileName(a.Name);
							efa.setBody(a.Body);
							fileAttachments.add(efa);
						}
						email.setFileAttachments(fileAttachments);
					}	
 
					system.debug(email); 
					
			 
					//send email 
				    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
				
    				Case cup = [select SevereEmailSent__C from Case where id =: caseid];
    				cup.severeEmailSent__c = true;
    				update cup;
				 
										
                
			
		}
		
 
       
   }


}