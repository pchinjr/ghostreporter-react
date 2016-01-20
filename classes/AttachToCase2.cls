public class AttachToCase2 {
//executes by Case creation rather than email insert
public List<Case> ucase {get;set;}
 
 
 


public AttachToCase2(List<Case> ucase){
    this.ucase = ucase;
    
    System.debug('caseid = ' + this.ucase[0].id);

    if(this.ucase[0].origin == 'Email'){
        sendEmail(this.ucase[0].id, this.ucase[0].contactid);
    }
    
}
 
   @future
   public static void sendEmail(String caseid, String contactid){
    String emailid;
    
    emailid = [select id from EmailMessage where parentid =: caseid order by createddate asc limit 1].id;
    System.debug('EmailMessageId=' + emailid);
    Integer attachSize;
   
   attachSize = 0;
   List<EmailMessage> em = [select id, parentid, HasAttachment from EmailMessage where id =: emailid];
   System.debug('em size=' + em.size());
   
   List<User> userEmails = [select email from user where getSevereAlert__c = true];
   
   for(EmailMessage e: em){
 
               
					//Get all email address in unique set
					Set<String> setOfContactEmails = new Set<String>();
					Set<String> setOfUserEmails = new Set<String>();
				 
					
					    //Add users that are configured to get the severe alert
				        for(User u: userEmails){
				             
				            setOfContactEmails.add(u.email);
				        }
				        
 
								
					list<String> listOfEmails = new list<String>();
					listOfEmails.addAll(setOfContactEmails);
					listOfEmails.addAll(setOfUserEmails);
					listOfEmails.sort();		
				
					//Create the email message body
					Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
					EmailTemplate emailTemp = [Select id From EmailTemplate Where developerName = 'CRT_Team_Alert' Limit 1]; //A email template for Cases
	 
		      		email.saveAsActivity = false;
					email.settargetObjectId(ContactId);
					//email.setCcAddresses(listOfEmails);
					email.setTemplateId(emailTemp.Id);
					email.setwhatId(caseid);
					
					//Check for Attachments
					
				
					
					system.debug('H$H$H$H$H Attachment Flag: ' + e.HasAttachment);
					if(e.HasAttachment){
						//Create list of Messageing email File Attachments
						list<Messaging.EmailFileAttachment> fileAttachments = new list<Messaging.EmailFileAttachment>();
				
					    list<Attachment> allAttachmentsInEmail = [Select Name, ContentType, Body From Attachment Where parentId =: e.id]; 
						system.debug('---->number of attachments: ' + allAttachmentsInEmail.size());
						attachSize = allAttachmentsInEmail.size();
						for(Attachment a: allAttachmentsInEmail){
							Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
							efa.setFileName(a.Name);
							efa.setBody(a.Body);
							fileAttachments.add(efa);
						}
						email.setFileAttachments(fileAttachments);
					}	
 
					system.debug(email); 
					
					 
				    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
				 
										
                
			
		}
       
   }


}