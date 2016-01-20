public with sharing class JSON_Generator {
	
	public JSON_Generator() { }
	
	/** gen_JSON returns a JSON String. It queries the database for case data
	 *  and constructs a JSON object using the JSON Generator class
	 *  @params: none
	 *  @returns: String of JSON
	 *  @author: Matthew Bald
	 */
	public String gen_JSON() {	
		
        List<Case> lstAaData = [SELECT  origin,
                                        createddate,
                                       id 
                                        FROM Case 
                                        where createddate >= LAST_N_DAYS:7 ];
									   

        // Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);

        // Write data to the JSON string.
        gen.writeStartObject();
        
        gen.writeFieldName('data');

        gen.writeStartArray();
        
        for (Case acc : lstAaData) {  
        	gen.writeStartObject();

            if (acc.Origin != null)
            	gen.writeStringField('Origin', acc.Origin);
            else gen.writeNullField('Origin');



            if (acc.createddate != null) {
            	gen.writeDateField('CreatedDate', (Date)acc.createddate);
            }
            else gen.writeNullField('CreatedDate');
            
            gen.writeIdField('id', acc.id);
            
            
        	gen.writeEndObject();
		}
		
        gen.writeEndArray();
        gen.writeEndObject();
		
        return gen.getAsString();     		   

	}
}