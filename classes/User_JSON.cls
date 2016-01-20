public class User_JSON {
public List<User_Wrapper> uwrap;

public User_JSON(){}


public String makeUserJSON(List<User_Wrapper> uw){
    
    uwrap = uw;
    
    JSONGenerator gen = JSON.createGenerator(true);

        // Write data to the JSON string.
        gen.writeStartObject();
        
        gen.writeFieldName('data');

        gen.writeStartArray();
        
        for (User_Wrapper acc : uwrap) {  
            gen.writeStartObject();
          
            if (acc.agent != null)
              gen.writeStringField('agent', acc.agent);
            else gen.writeNullField('agent');

            if (acc.state != null)
              gen.writeStringField('state', acc.state);
            else gen.writeNullField('state');
            
             if (acc.origin != null)
              gen.writeStringField('origin', acc.origin);
            else gen.writeNullField('origin');
            
            if (acc.source != null)
              gen.writeStringField('source', acc.source);
            else gen.writeNullField('source');
            
            if (acc.person_id != null)
              gen.writeStringField('person_id', acc.person_id);
            else gen.writeNullField('person_id');
            
            
            if (acc.crt_review_dt != null)
              gen.writeDateTimeField('crt_review_dt', acc.crt_review_dt);
            else gen.writeNullField('crt_review_dt');
      
                 
            
            if (acc.handletime != null)
              gen.writeTimeField('handletime', acc.handletime);
            else gen.writeNullField('handletime');
      
      
            gen.writeEndObject();
        }
    
        gen.writeEndArray();
        gen.writeEndObject();
    
        return gen.getAsString();      
        
}

}