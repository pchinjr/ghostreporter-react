/**
 * Utilitly class for building dymanic queries. 
 * <p> Needs to be updated to allow not equal filters. 
 * @author Mike McGee
 */
public class QueryManager {
	/** Map that is used to filter the dynamic queries */
    private Map<String, Object> filterMap;
    
    /**
     * Default constructor for filterless querying. 
     */
    public QueryManager() {}
    
    /**
     * Constructor to initialize the filtermap.
     */
    public QueryManager(Map<String, Object> filterMap) {
        this.filterMap = filterMap; 
    }
    
    /**
     * Adds another filter to the filter map
     * @param	filterParameter	the parameter to filter by
     * @param 	filterValue	the value that the filterParam must be. 
     */
    public void addFilter(String filterParameter, Object filterValue) {
        if (filterMap == null) {
            filterMap = new Map<String, Object>();
        }
        filterMap.put(filterParameter, filterValue);
    }
    
    /**
     * Builds filterless query string for object that is passed in. 
     * @param objName	the name of the object to qury
     * @retutn a string used to dynamically query database
     */
    public String buildFilterlessQuery(String objName) {
        ObjectManager om = new ObjectManager(objName); 
        List<String> allFields = om.getAllFieldNames();
        String queryString = 'SELECT '; 
        for (Integer i = 0, j = allFields.size(); i < j; ++i) {
            // If at the end of the list of fields don't add a comma. 
            if (i == allFields.size() -1) {
                queryString += allFields.get(i) + ' ';
            } else {
                queryString += allFields.get(i) + ' , ';
            }
        }
        // Add ending to string
        queryString += ' FROM ' + objName; 
        return queryString;
    }
    
}