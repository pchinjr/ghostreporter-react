public with sharing class Dash_JSON_Generator {
		
	private Integer in_PC;
	private Integer unaC;
	private Integer promoC;
		
	public Dash_JSON_Generator() { }
	
	public Integer get_Progress_Count() {
		return in_PC;
	}
	
	public Integer get_Unassigned_Count() {
		return unaC;
	}
	
	public Integer get_Promoted_Count() {
		return promoC;
	}
		
	public String gen_Dash_JSON_Pivoted() {			

		List<String> priorities = new List<String> {'Low', 'Medium', 'High', 'Severe' };
		
		List<Double> in_Prog = new List<Double>();
		List<Double> una = new List<Double>();
		List<Double> promo = new List<Double>();
			
		// Get case counts for each status
		in_PC = [select count() from Case where isClosed = false and Status = 'In Progress'];
		unaC = [select count() from Case where isClosed = false and Status = 'Unassigned'];
		promoC = [select count() from Case where isClosed = false and Status = 'Promoted'];
		
		// get case counts for each status
		for (Integer i = 0; i < priorities.size(); i++) {
			in_Prog.add([select count() from Case where isClosed = false and Priority = :priorities.get(i) and Status = 'In Progress']);
			una.add([select count() from Case where isClosed = false and Priority = :priorities.get(i) and Status = 'Unassigned']);
			promo.add([select count() from Case where isClosed = false and Priority = :priorities.get(i) and Status = 'Promoted']);
		}

		// divide each status count by the total number of cases to find the equivalent percentage		
		for (Integer i = 0; i < priorities.size(); i++) {
			if (in_PC > 0) in_Prog.set(i, ((in_Prog.get(i) / in_PC)*100.0)); 
			else in_Prog.set(i, 0);
			if (unaC > 0) una.set(i, ((una.get(i) / unaC)*100.0));
			else una.set(i, 0);
			if (promoC > 0) promo.set(i, ((promo.get(i) / promoC)*100.0));
			else promo.set(i, 0);
		}
			
				
		// generate JSON string
		// Create a JSONGenerator object.
        // Pass true to the constructor for pretty print formatting.
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartArray();
        
        gen.writeStartArray();
        
        gen.writeString('Status');
        
        for (Integer i=0; i < priorities.size(); i++) {
			gen.writeString(priorities.get(i));
			gen.writeStartObject();
        		gen.writeStringField('role', 'annotation');
    		gen.writeEndObject();
    		
    		gen.writeStartObject();
    			gen.writeStringField('role', 'tooltip');
        	gen.writeEndObject();
        }
        /*
		gen.writeStartObject();
		
			gen.writeStringField('role', 'annotation');
		
		gen.writeEndObject();
		*/
        gen.writeEndArray();
        
        gen.writeStartArray();
        
	        gen.writeString('In Progress');
			
	        for (Integer i = 0; i < priorities.size(); i++) {
	        	gen.writeNumber(in_Prog.get(i));
	        	
				if (in_Prog.get(i) > 4) gen.writeString(Math.roundToLong(in_Prog.get(i)*in_PC/100).format());
				else gen.writeString('');
				gen.writeString(priorities.get(i)+' Priority: '+Math.roundToLong(in_Prog.get(i)*in_PC/100).format());
			}
			
	       // gen.writeString('');
	                
        gen.writeEndArray();
         
        gen.writeStartArray();
        
	        gen.writeString('Unassigned');
	        
	        for (Integer i = 0; i < priorities.size(); i++) {
	        	gen.writeNumber(una.get(i));
	        	
	        	if (una.get(i) > 4) gen.writeString(Math.roundToLong(una.get(i)*unaC/100).format());
	        	else gen.writeString('');
	        	gen.writeString(priorities.get(i)+' Priority: '+Math.roundToLong(una.get(i)*unaC/100).format());
	        }
		        	        
	       // gen.writeString('');
	        
        gen.writeEndArray();
        
        gen.writeStartArray();
	        
    	gen.writeString('Promoted');
    	for (Integer i = 0 ; i < priorities.size(); i++) {
    		gen.writeNumber(promo.get(i));
    		
    		if (promo.get(i) > 4) gen.writeString(Math.roundToLong(promo.get(i)*promoC/100).format());
    		else gen.writeString('');
    		//gen.writeString(colorWheel.get(i));
    		gen.writeString(priorities.get(i)+' Priority: '+Math.roundToLong(promo.get(i)*promoC/100).format());
    	}
    		
    	gen.writeEndArray();

        gen.writeEndArray();
	        
        return gen.getAsString();
	}
}