public with sharing class Billing_Case_JSON_Generator {
	
	public Billing_Case_JSON_Generator() { }
	
	public String gen_JSON() {
		
		List<Billing_Case__c> caseList = [select Name,
												 From__c,
												 Date_From__c,
												 Work_Item__c,
												 Worked_By_Activity__c,
												 Priority__c,
												 Link__c,
												 Worked__c,
												 Owner.Name	from Billing_Case__c where Worked__c = false];
		
		
		// Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        
        // Write data to the JSON string.
        gen.writeStartObject(); // {
        
        gen.writeFieldName('data'); // { data: 

        gen.writeStartArray(); // { data: [ 
        
        for (Billing_Case__c bCase : caseList) {
        	
        	gen.writeStartObject(); // { data: [ { 
        	
        	if (bCase.Name != null) {
        		gen.writeStringField('Billing Case Number', bCase.Name); // { data: [ { 'Case Id': ...., 
        	}
        	else gen.writeNullField('Billing Case Number');
        	
        	if (bCase.From__c != null) {
        		gen.writeStringField('From', bCase.From__c);
        	}
        	else gen.writeNullField('From');
        	
        	if (bCase.Date_From__c != null) {
        		gen.writeDateField('Date From', bCase.Date_From__c);
        	}
        	else gen.writeNullField('Date From');
        	
        	if (bCase.Work_Item__c != null) {
        		gen.writeStringField('Work Item', bCase.Work_Item__c);
        	}
        	else gen.writeNullField('Work Item');
        	
        	if (bCase.Worked_By_Activity__c != null) {
        		gen.writeStringField('Worked By Activity', bCase.Worked_By_Activity__c);
        	}
        	else gen.writeNullField('Worked By Activity');
        	
        	if (bCase.Priority__c != null) {
        		gen.writeStringField('Priority', bCase.Priority__c);
        	}
        	else gen.writeNullField('Priority');
        	
        	if (bCase.Link__c != null) {
        		gen.writeStringField('Link', '<a id="erm_link_'+bCase.Name+' href="'+bCase.Link__c+'">Link</a>');
        	}
        	else gen.writeNullField('Link');
        	
        	if (bCase.Worked__c != null) {
        		gen.writeStringField('Worked', '<button class="btn btn-mini text-center center" id="wrk_btn_'+bCase.Name+'">Mark Worked</button>');
        	}
        	else gen.writeNullField('Worked');
        	
        	if (bCase.Owner.Name != null) {
        		gen.writeStringField('Owner', bCase.Owner.Name);
        	}
        	else gen.writeNullField('Owner');
        	
        	gen.writeEndObject();	// { data: [ { .... }, 
        }
        
        gen.writeEndArray(); // { data: [ { .... }, { .... }, { .... } ... ]
        gen.writeEndObject(); // { data: [ { .... }, { .... }, { .... } ... ] }
        
        return gen.getAsString();
	}
}