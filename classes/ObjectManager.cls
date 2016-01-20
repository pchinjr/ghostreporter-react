/**
 * This class is used to access the metadata of an object and to provide query strings
 * in order to more dynamically query the fields on an object. 
 * @author Mike McGee
 */
public with sharing class ObjectManager {

	/** The name of the object being accessed */
	private String objectName; 

	/** Map from all field names to their associated type */
	private Map<String, Schema.SObjectField> fieldMap; 

	public ObjectManager(String objectName) {
		this.objectName = objectName; 
	}

	/**
	 * Creates the field map for the Object name 
	 */
	private void createFieldMap() {
		fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
	}


	/** 
	 * Gets list containing all of the objects field names.
	 * @return list containing all field names for object. 
	 */
	public List<String> getAllFieldNames() {
		if (fieldMap == null) {
			createFieldMap(); 
		} 

		Set<String> fieldNameSet = fieldMap.keySet();

		return new List<String>(fieldNameSet); 
	}

	/**
	 * Gets a list of all fields that are of one of the passed in types. 
	 * @param typeList	the list of types to be included. 
	 * @return allFieldsMatching that tyoe. 
	 */
	public List<Schema.SObjectField> getAllFieldsOfTypes(List<String> typeList) {
		if (fieldMap == null) {
			createFieldMap();
		}
		// Place list of typenames in set for easy searching. 
		Set<String> typeNames = new Set<String>();
		for (Integer i = 0, j = typeList.size(); i < j; ++i) {
			typeNames.add(typeList.get(i).toLowerCase()); 
		}

		// Add fields that match the types to the list of fields to return
		List<Schema.SObjectField> fieldList = new List<Schema.SObjectField>();
		for (String s : fieldMap.keySet()) {
			Schema.SObjectField field = fieldMap.get(s);
			if (typeNames.contains(String.valueOf(field.getDescribe().Type).toLowerCase())) {
				fieldList.add(field); 
			}
		}

		return fieldList; 
	}
}