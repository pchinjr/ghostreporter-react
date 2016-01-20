trigger SendEmailUpdateOnEmailMessageForCase on EmailMessage (before insert, after insert) { 

    try{    
        for(EmailMessage e: trigger.new){
        
            //system.debug('@@@###$$$%%^^ Inserted email' + 'trigger size = ' + trigger.new.size());
            string caseId = string.valueof(e.ParentId);
                        
            if(caseId.startsWith('500')){   //This Email Message is for a Case 
                
                //Look up Case Details
                Case theCase = [SELECT Id, ContactId, OwnerID, Subject, Priority, IsClosed, 
                Description, CreatedDate, CaseNumber, AccountId  FROM Case WHERE Id =: caseId Limit 1];         
                
                if(trigger.isBefore){   
        
                    
                }else if(trigger.isAfter){
                    
                //  system.debug('***** the email Id is ' + e.id);
                //  Set<ID> toEmailId = new Set<ID>();
            //      toEmailId.add(theCase.OwnerId);
                    //Get Ids of the Case Team Members
                //  List<CaseTeamMember> member = [Select MemberId From CaseTeamMember where ParentId =:caseId];
                    
                //  for(CaseTeamMember m: member){
                //      toEmailId.add(m.MemberId);          
                //  }
                    //system.debug('%%%List of Members %%%%% ' + toEmailId);
                    
                    //Get contact and user list from the set of Id's            
                //  List<Contact> listContactEmails = [SELECT Email FROM Contact Where ID IN: toEmailId];
                //  List<User> listUserEmails =  [SELECT Email FROM User Where ID IN: toEmailId]; 
        
                    //Get all email address in unique set
                    Set<String> setOfContactEmails = new Set<String>();
                    Set<String> setOfUserEmails = new Set<String>();
                 
                        setOfContactEmails.add('rortiz@ouc.com');
                 
                 
                        setOfUserEmails.add('rortiz@ouc.com');
                 
                                
                    list<String> listOfEmails = new list<String>();
                    listOfEmails.addAll(setOfContactEmails);
                    listOfEmails.addAll(setOfUserEmails);
                    listOfEmails.sort();        
                
                    //Create the email message body
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                    EmailTemplate emailTemp = [Select id From EmailTemplate Where developerName = 'SUPPORTCaseescalationnotificationSAMPLE' Limit 1]; //A email template for Cases
                    email.orgWideEmailAddressId = '0D2e000000001Pq';    //Our Org Wide default
                    email.replyTo = 'support.test@ictnetworks.com.au';
                            email.saveAsActivity = false;
                    email.settargetObjectId(theCase.ContactId);
                    email.setCcAddresses(listOfEmails);
                    email.setTemplateId(emailTemp.Id);
                    email.setwhatId(theCase.Id);
                    
                    //Check for Attachments
                    
                
                    
                    system.debug('H$H$H$H$H Attachment Flag: ' + e.HasAttachment);
                    if(e.HasAttachment){
                        //Create list of Messageing email File Attachments
                        list<Messaging.EmailFileAttachment> fileAttachments = new list<Messaging.EmailFileAttachment>();
                
                        list<Attachment> allAttachmentsInEmail = [Select Name, ContentType, Body From Attachment Where parentId =: email.whatId]; 
                        system.debug('---->number of attachments: ' + allAttachmentsInEmail.size());
                        for(Attachment a: allAttachmentsInEmail){
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                        }
                        email.setFileAttachments(fileAttachments);
                    }   
                    
                    system.debug('@@@@@emailid = ' + e.id);
                    system.debug('@@@@@targetI ObjectID = ' + email.targetObjectId);
                    system.debug('@@@@@emailTemp.Id = ' + emailTemp.Id);
                    system.debug('@@@@@whatId = ' + email.whatId);
                //  email.setPlainTextBody('Hello!'); 
                //  email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa}); 
                    system.debug(email); 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                                        
                }
            }
        }
    } catch (exception e){
        System.debug('The following exception has occurred: ' + e.getMessage());
    }       

}