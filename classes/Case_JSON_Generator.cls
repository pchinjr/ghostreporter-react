public with sharing class Case_JSON_Generator {
  
  public Case_JSON_Generator() { }
  
  /** gen_JSON returns a JSON String. It queries the database for case data
   *  and constructs a JSON object using the JSON Generator class
   *  @params: none
   *  @returns: String of JSON
   *  @author: Matthew Bald
   */
  public String gen_JSON() {  
    
        List<Case> lstAaData = [SELECT  Id,
                      CaseNumber,
                      Priority,
                      Status,
                    CRDate__c,
                    Customer_Name__c,
                    Note_Type__c,
                    Origin,
                    Source__c,
                    Owner.Name,
                    Contact.Phone,
                    Contact.Email,
                    CC_ID__c,
                    Description,
                    Case_Age_In_Business_Hours__c,
                    Owner.Id,
                    Contact.Id,
                    Account_ID__c
                    FROM Case where isClosed = false];
                     

        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);

        // Write data to the JSON string.
        gen.writeStartObject();
        
        gen.writeFieldName('data');

        gen.writeStartArray();
        
        for (Case acc : lstAaData) {  
          gen.writeStartObject();
          
            if (acc.CaseNumber != null)
              gen.writeStringField('CaseNumber', acc.CaseNumber);
            else gen.writeNullField('CaseNumber');
            
            if (acc.Priority != null) {
              if (acc.Priority == 'High') 
                gen.writeStringField('Priority', '  '+acc.Priority); 
              
              else if (acc.Priority == 'Medium')  
                gen.writeStringField('Priority', ' '+acc.Priority); 
            else
                gen.writeStringField('Priority', acc.Priority);
            }
            else gen.writeNullField('Priority');
            
            if (acc.Status != null)
              gen.writeStringField('Status', acc.Status);
            else gen.writeNullField('Status');
            
            if (acc.Customer_Name__c != null)
              gen.writeStringField('Cust_Name', acc.Customer_Name__c);
            else gen.writeNullField('Cust_Name');
            
            if (acc.CRDate__c != null)
              gen.writeDateField('CR_Date', acc.CRDate__c);
            else gen.writeNullField('CR_Date');
            
            if (acc.Id != null)
              gen.writeIdField('CaseId', acc.Id);
            else gen.writeNullField('CaseId');
            
            if (acc.Customer_Name__c != null)
              gen.writeStringField('Cust_Name', acc.Customer_Name__c);
            else gen.writeNullField('Cust_Name');
            
            if (acc.Note_Type__c != null)
              gen.writeStringField('Note', acc.Note_Type__c);
            else gen.writeNullField('Note');
            
            if (acc.Origin != null)
              gen.writeStringField('Origin', acc.Origin);
            else gen.writeNullField('Origin');
            
            if (acc.Source__c != null)
              gen.writeStringField('Source', acc.Source__c);
            else gen.writeNullField('Source');
            
            if (acc.Owner.Name != null)
              gen.writeStringField('Owner_Name', acc.Owner.Name);
            else gen.writeNullField('Owner_Name');
            
            if (acc.Contact.Phone != null)
              gen.writeStringField('Cont_Phone', acc.Contact.Phone);
            else gen.writeNullField('Cont_Phone');
            
            if (acc.Contact.Email != null)
              gen.writeStringField('Cont_Email', acc.Contact.Email);
            else gen.writeNullField('Cont_Email');
            
            if (acc.CC_ID__c != null)
              gen.writeStringField('CC_ID', acc.CC_ID__c);
            else gen.writeNullField('CC_ID');
            
            if (acc.Description != null)
              gen.writeStringField('Description', acc.Description);
            else gen.writeNullField('Description');
            
            if (acc.Owner.Id != null) 
              gen.writeStringField('OwnerId', acc.Owner.Id);
            else gen.writeNullField('OwnerId');
            
            if (acc.Case_Age_In_Business_Hours__c != null)
              gen.writeNumberField('CaseAge', Integer.valueOf(acc.Case_Age_In_Business_Hours__c));
            else gen.writeNullField('CaseAge');
            
            if (acc.Id != null) {
              gen.writeIdField('Id', acc.Id);
            }
            else gen.writeNullField('Id');
            
            if (acc.Contact.Id != null) {
              gen.writeIdField('ContactId', acc.Contact.Id);
            }
            else gen.writeStringField('ContactId', '');
            
            if (acc.Account_ID__c != null) {
              gen.writeStringField('AccountID', acc.Account_ID__c);
            }
            else gen.writeNullField('AccountID');
            
          gen.writeEndObject();
    }
    
        gen.writeEndArray();
        gen.writeEndObject();
    
        return gen.getAsString();            

  }
}