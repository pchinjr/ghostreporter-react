public with sharing class Activities_JSON_Generator {
	
	public Activities_JSON_Generator() { }
	
	/** retrieveActivitiesData refreshes the JSONString_Activities global field.
	 *	It queries the database for case data and constructs a JSON object using
	 *  the JSON Generator class
	 *  @params: none
	 *  @returns: none
	 *  @author: Matthew Bald
	 */
	public String retrieveActivitiesData() {
		
		List<Event> lstAcData = [select Id,
										ActivityDate,
										Location,
										Subject,
										CreatedBy.Name,
										Description,
										EndDateTime,
										Who.Name,
										Who.Phone,
										StartDateTime, 
										Type, 
										CRT_Subject__c, 
										Completed__c
										from Event where OwnerID = :System.UserInfo.getUserId() AND Completed__c = null];	
		List<Task> lstAtData = [select  Id,
										ActivityDate,
										Subject,
										CallType,
										Description,
										Who.Name,
										Who.Phone,
										Priority,
										Status,
										Type,
										CreatedBy.Name
										from Task where OwnerID = :System.UserInfo.getUserId() ];
	
		JSONGenerator gen = JSON.createGenerator(true);
		
		gen.writeStartObject();
		
		gen.writeFieldName('data');
		
		gen.writeStartArray();
		
		for (Event ev : lstAcData) {
			gen.writeStartObject();
			
			if (ev.ActivityDate != null) { 
				gen.writeDateField('ActivityDate', ev.ActivityDate);
			}
			else gen.writeNullField('ActivityDate');
			
			if (ev.Subject != null) {
				gen.writeStringField('Subject', ev.Subject);
			}
			else gen.writeNullField('Subject');
			
			if (ev.Location != null) {
				gen.writeStringField('Location', ev.Location);
			}
			else gen.writeNullField('Location');
			
			if (ev.Id != null) {
				gen.writeIdField('Id', ev.Id);
			}
			else gen.writeNullField('Id');
			
			if (ev.CreatedBy.Name != null) {
				gen.writeStringField('Created By', ev.CreatedBy.Name);
			}
			else gen.writeNullField('Created By');
			
			if (ev.Description != null) {
				gen.writeStringField('Description', ev.Description);
			}
			else gen.writeNullField('Description');
			
			if (ev.EndDateTime != null) {
				gen.writeDateTimeField('Endtime', ev.EndDateTime);
			}
			else gen.writeNullField('Endtime');
			
			if (ev.Who.Name != null) {
				gen.writeStringField('ContactName', ev.Who.Name);
			}
			else gen.writeNullField('ContactName');
			
			if (ev.Who.Phone != null) {
				gen.writeStringField('Phone', ev.Who.Phone);
			}			
			else gen.writeNullField('Phone');
			
			if (ev.StartDateTime != null) {
				gen.writeTimeField('Starttime', ev.StartDateTime.time());
			}
			else gen.writeNullField('Starttime');
			
			if (ev.Type != null) {
				gen.writeStringField('Type', ev.Type);
			}
			else gen.writeNullField('Type');
			
			if (ev.CRT_Subject__c != null) {
				gen.writeStringField('CRT_Subject', ev.CRT_Subject__c);
			}
			else gen.writeNullField('CRT_Subject');
			
			if (ev.Completed__c != null) {
				gen.writeBooleanField('Completed', ev.Completed__c);
			}
			else gen.writeNullField('Completed');
			
			gen.writeNullField('Account Number');
		
			gen.writeEndObject();
		}
		
		for (Task ta : lstAtData) {
			gen.writeStartObject();
			
			if (ta.ActivityDate != null) {
				gen.writeDateField('ActivityDate', ta.ActivityDate);
			}
			else gen.writeNullField('ActivityDate');
			
			//gen.writeTime(ta.ActivityDate.time());
			if (ta.Subject != null) {
				gen.writeStringField('CRT_Subject', ta.Subject);
			}
			else gen.writeNullField('CRT_Subject');
			
			//location does not exist for tasks, write null
			gen.writeNullField('Location');
			
			if (ta.Id != null) {
				gen.writeIdField('Id', ta.Id);
			}
			else gen.writeNullField('Id');
			
			if (ta.CreatedBy.Name != null) {
				gen.writeStringField('Created By', ta.CreatedBy.Name);
			}
			else gen.writeNullField('Created By');
			
			if (ta.CallType != null) {
				gen.writeStringField('Calltype', ta.CallType);
			}
			else gen.writeNullField('Calltype');
			
			if (ta.Description != null) {
				gen.writeStringField('Description', ta.Description);
			}
			else gen.writeNullField('Description');
			
			gen.writeNullField('Starttime');
			gen.writeNullField('Endtime');
			
			gen.writeNullField('Phone');
			
			if (ta.Who.Name != null) {
				gen.writeStringField('ContactName', ta.Who.Name);
			}
			else gen.writeNullField('ContactName');
			
			if (ta.Who.Phone != null) {
				gen.writeStringField('Phone', ta.Who.Phone);
			}
			else gen.writeNullField('Phone');
			
			if (ta.Priority != null) {
				gen.writeStringField('Priority', ta.Priority);
			}
			else gen.writeNullField('Priority');
			
			if (ta.Status != null) {
				gen.writeStringField('Status', ta.Status);
			}
			else gen.writeNullField('Status');	
		
			if (ta.Type != null) {
				gen.writeStringField('Type', ta.Type);
			}
			else gen.writeNullField('Type');
			
			gen.writeNullField('Account Number');
			
			gen.writeEndObject();
		}
		
        gen.writeEndArray();
        gen.writeEndObject();		
		
		return gen.getAsString(); 
	}
	
}