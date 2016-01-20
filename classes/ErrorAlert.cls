/**
 * Class used to send email alerts to agents who have commited errors.
 * @author Mike McGee
 */
global with sharing class ErrorAlert {

	
	@InvocableMethod(label='Alert Agents' description='Sends Email to Agent alerting them to the errors they commited')
	global static void alertAgents(List<Error__c> errorObjs) {

		/**
	 	* To use a template, a targetId must be set.
	 	* This targetId can be one of three types: Contact, User, Lead.
	 	* To still use a template without sending the email to one of the above
	 	* a dummy email will be created and not sent. 
	 	* The flow looks like this:
	 	* 1.) Create dummy email using template with a targetId set as a contact
	 	* 2.) Create save point
	 	* 3.) "Send" dummy email
	 	* 4.) Rollback to created save point
	 	* 5.) Use dummy email fields to fill real emails that will be sent
	 	* 6.) Send real emails
	 	* 7.) Rejoice in success
	 	*/
	 	
		if (errorObjs.isEmpty()) return; // Should never happen.
		
		// List of emails to send
		List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

		
		// Build all emails
		for (Error__c err: errorObjs) {
			// Build dummy email
			Messaging.SingleEmailMessage dummyEmail = buildDummyEmail(err);
			// Steps 2 - 4
			SavePoint sp = Database.setSavepoint();
			Messaging.sendEmail(new Messaging.SingleEmailMessage[]{dummyEmail});
			Database.Rollback(sp);
			// Build real email
			Messaging.SingleEmailMessage email = buildEmail(err, dummyEmail);
			emailsToSend.add(email);
		}
		
		// Send emails
		Messaging.SendEmailResult[]  resultList = Messaging.sendEmail(emailsToSend);
		for (Messaging.SendEmailResult res: resultList) {
    		if (!res.isSuccess()) {
        		System.debug(LoggingLevel.ERROR, res.getErrors());
    		}
		}
	}


	/**
	 * Builds a dummy email to be used in the appeasment of salesforce
	 * @param err The Error object the emails are related to
	 * @return An email with the error alert template
	 */
	private static Messaging.SingleEmailMessage buildDummyEmail(Error__c err) {
		Messaging.SingleEmailMessage dummy = new Messaging.SingleEmailMessage();
		dummy.setTemplateId([SELECT Id FROM EmailTemplate WHERE Name = 'ErrorAlert'].Id);
		dummy.setTargetObjectId([SELECT Id FROM Contact WHERE Email != null LIMIT 1].Id);
		dummy.setWhatId(err.Id);
		return dummy;
	}



	/**
	 * Builds an alert email based on the passed in error object.
	 * @param errObj The Error object to alert about
	 * @return An email ready to be sent
	 */
	private static Messaging.SingleEmailMessage buildEmail(Error__c errObj, 
									Messaging.SingleEmailMessage emailTemp) {

		List<String> toAddresses = getAdressList(errObj);
		toAddresses.add('mmcgee@ouc.com'); // Testing for now
		//toAddresses.add('dlove@ouc.com'); // Testing for now

		System.debug('The email will be sent to '+toAddresses);
		
		// Build email 
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setWhatId(emailTemp.getWhatId());
		email.setToAddresses(toAddresses);
		email.setHtmlBody(emailTemp.getHtmlBody());
		email.setPlainTextBody(emailTemp.getPlainTextBody());
		email.setSubject(emailTemp.getSubject());
		// Attach files
		email.setFileAttachments(getAttachmentList(errObj));

		return email;
	}


	/**
	 * Gets all of the attachments where the parent id is the passed in errObj Id
	 * @param errObj The error object that has attachments to get
	 * @return The list of attachments where the parentId was errObj Id
	 */
	private static List<Messaging.EmailFileAttachment> getAttachmentList(Error__c errObj) {
		List<Messaging.EmailFileAttachment> attList = new List<Messaging.EmailFileAttachment>();

		for (Attachment a: [SELECT Id, Name, Body FROM Attachment  
							WHERE ParentId =: errObj.Id]) {
			Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
			att.setFileName(a.Name);
			att.setBody(a.Body);
			attList.add(att);
		}

		return attList;
	}



	/**
	 * Gets the list of email addresses that need to be alerted of the error.
	 * @param errObj The Error object containing the addresses
	 * @return The list of email addresses
	 */
	private static List<String> getAdressList(Error__c errObj) {
		// Add AgentTeam email and their supervisor email
		// Can't traverse up to grandparent will need to SOQL it.

		List<Error__c> errList = [SELECT AgentErrors__r.Agent__r.Agent_Email__c, 
			AgentErrors__r.Agent__r.Supervisor_Email__c FROM Error__c WHERE Id =: errObj.Id];	

		List<String> toList = new List<String>();
		try {
			System.debug(errList.get(0).AgentErrors__r.Agent__r.Agent_Email__c);
		} catch (Exception e) {
			System.debug('Got error when trying to print email');
		}

		if (errList.get(0).AgentErrors__r.Agent__r.Agent_Email__c != null) {
			toList.add(errList.get(0).AgentErrors__r.Agent__r.Agent_Email__c);
		}
		
		//TODO: Update to actually send email to supervisor
		if (errList.get(0).AgentErrors__r.Agent__r.Supervisor_Email__c != null) {
			System.debug('Also would have sent an email to '+errList.get(0).AgentErrors__r.Agent__r.Supervisor_Email__c);
		}

		return toList;
	}
	
}