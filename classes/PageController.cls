/**
 * Abstract class for all page controllers. Used to define
 * behaviors and provide a means for generalization. 
 */
public abstract class PageController {
	
    protected transient SelectListBuilder selectListBuilderType; 
    
    public List<SelectOption> buildSelectList(List<sObject> optionList) {
        return selectListBuilderType.buildSelectList(optionList);
    }
    
    /**
     * Initializes fields in list of sObjects 
     * <p>
     * If the values of the field are either a number or string, sets the value
     * of the field to a 0 or '' respectively. 
     * @author  Mike McGee 
     * @param   objectList  list to be initialized
     * @param   objectName  the name of the sObject that the list consists of.
     * @return  an initializeList suitable for use in a chart or datatable. 
     */ 
    public List<sObject> initializeList(List<sObject> objectList, String objectName) {
        if (objectList.isEmpty()) {
            return objectList; 
        }
        
        //Get set of fields from object type passes in. 
        SObjectType objToken = Schema.getGlobalDescribe().get(objectName); 
        DescribeSObjectResult objDef = objToken.getDescribe(); 
        Map<String, sObjectField> fields = objDef.fields.getMap(); 
        Set<String> fieldSet = fields.keySet();
        
        //loop through the set setting value to 0 or '' respectively
        for (String s: fieldSet) {
        	sObjectField fieldToken = fields.get(s);
        	DescribeFieldResult selectedField = fieldToken.getDescribe();
        	DisplayType type = selectedField.getType();
        	//get type of field and set value accordingly 
        	if (type == Schema.DisplayType.DOUBLE || type == Schema.DisplayType.INTEGER || type == Schema.DisplayType.STRING) {
        		//Need to loop through the object list setting each field accordingly
        		//Put in try catch so that it will not breK if field was not queried for. 
        		//This makes the algo much slower, if better method is known, fix this. 
        		try {
        		    for (sObject o: objectList) {
            			if (o.get(s) == null) {
                            if (type == Schema.DisplayType.STRING) {
                                o.put(s, ''); 
                            } else {
                                o.put(s, 0); 
                            }
            			}
            		}
        		    
        		} catch (SObjectException e) {}
        		
        	}
        
        }
        
        return objectList; 
    }
    
}