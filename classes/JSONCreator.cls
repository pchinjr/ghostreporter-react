public with sharing class JSONCreator {
	
	transient public String JSONString {get; set;}
	public Integer lowP {get; set;}
	public Integer medP {get; set;}
	public Integer hiP {get; set;}
	
	public JSONCreator() {
		// constructor
		constructJSON();
	}
	
	public void constructJSON() {
		
		/*
			'Unassigned', 'In Progress', 'CRT Follow-Up', 'Promoted', 'Reviewed',
         	'Prevented', 'Resolved', 'Cancelled'
		*/
		List<String> statuses = new List<String> {'Unassigned', 'In Progress', 'CRT Follow-Up', 'Promoted',
												  'Reviewed'};
		
		List<Double> lowCounts = new List<Double>();
		List<Double> medCounts = new List<Double>();
		List<Double> highCounts = new List<Double>();
		
		// get case counts for each status
		for (Integer i = 0; i < statuses.size(); i++) {
			lowCounts.add([select count() from Case where isClosed = false and Priority = 'low' and Status = :statuses.get(i)]);
			medCounts.add([select count() from Case where isClosed = false and Priority = 'medium' and Status = :statuses.get(i)]);
			highCounts.add([select count() from Case where isClosed = false and Priority = 'high' and Status = :statuses.get(i)]);
		}
		
		Double lowCaseCount = [select count() from Case where isClosed = false and Priority = 'low'];
		Double medCaseCount = [select count() from Case where isClosed = false and Priority = 'medium'];
		Double hiCaseCount = [select count() from Case where isClosed = false and Priority = 'high'];
		
		lowP = lowCaseCount.intValue();
		medP = medCaseCount.intValue();
		hiP = hiCaseCount.intValue();
		
		// divide each status count by the total number of cases to find the equivalent percentage		
		for (Integer i = 0; i < statuses.size(); i++) {
			lowCounts.set(i, Math.roundtoLong((lowCounts.get(i) / lowCaseCount)*1000.0)/10.0); 
			medCounts.set(i, Math.roundtoLong((medCounts.get(i) / medCaseCount)*1000.0)/10.0);
			highCounts.set(i, Math.roundtoLong((highCounts.get(i) / hiCaseCount)*1000.0)/10.0);
		}
		
			
		// generate JSON string
		// Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartArray();
        
	        gen.writeStartArray();
	        
	        gen.writeString('Status');
	        
	        for (Integer i=0; i < statuses.size(); i++)
				gen.writeString(statuses.get(i));
			
			gen.writeStartObject();
			
				gen.writeStringField('role', 'annotation');
			
			gen.writeEndObject();
			
	        gen.writeEndArray();
	        
	        gen.writeStartArray();
	        
		        gen.writeString('Low');
		        for (Integer i = 0; i < statuses.size(); i++)
		        	gen.writeNumber(lowCounts.get(i));
		        
		        gen.writeString('');
	                
	        gen.writeEndArray();
	        
	        gen.writeStartArray();
	        
		        gen.writeString('Medium');
		        for (Integer i = 0; i < statuses.size(); i++) 
		        	gen.writeNumber(medCounts.get(i));
		        //gen.writeObject(medCounts);
		        		        
		        gen.writeString('');
		        
	        gen.writeEndArray();
	        
	        gen.writeStartArray();
	        
	        	gen.writeString('High');
	        	for (Integer i = 0 ; i < statuses.size(); i++) 
	        		gen.writeNumber(highCounts.get(i));
	        	//gen.writeObject(highCounts);	
        		gen.writeString('');
        	
        	gen.writeEndArray();
        	
        gen.writeEndArray();
        
        JSONString = gen.getAsString();
	}
}