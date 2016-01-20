/**
 * Helper class for sorting a list of sObjects. 
 * Used to sort a list of any sObject type by a specific stat. 
 *
 * @author Mike McGee
 */
public class Sorter {

	/**
	 * Sorts list in ascending order by the value of the <code> statName </code> 
	 * 
	 * @param	objectList	List of sObjects to be sortes
	 * @param	sortValue	the value to sort by
	 * @return	the sorted list
	 */
	public static List<sObject> sortAsc(List<Object> objectList, String sortValue) {
		//Build list of wrapper objects 
		List<ObjectWrapper> wrapperList = new List<ObjectWrapper>(); 
		for (Object o: objectList) {
			wrapperList.add(new ObjectWrapper((sObject)o, 'ASC', sortValue));
		}
		
		//sort wrapper list
		wrapperList.sort();

		//get object list from wrapper list
		List<sObject> sortedList = new List<sObject>(); 
		for (ObjectWrapper ow: wrapperList) {
			sortedList.add(ow.getWrappedObject());
		}

		//return sorted object list. 
		return sortedList;
	}


	/**
	 * Sorts list in descending order by the value of the <code> statName </code> 
	 * 
	 * @param	objectList	List of sObjects to be sortes
	 * @param	sortValue	the value to sort by
	 * @return	the sorted list
	 */
	public static List<sObject> sortDsc(List<Object> objectList, String sortValue) {
		//Build list of wrapper objects 
		List<ObjectWrapper> wrapperList = new List<ObjectWrapper>(); 
		for (Object o: objectList) {
			wrapperList.add(new ObjectWrapper((sObject)o, 'DESC', sortValue));
		}
		
		//sort wrapper list
		wrapperList.sort();

		//get object list from wrapper list
		List<sObject> sortedList = new List<sObject>(); 
		for (ObjectWrapper ow: wrapperList) {
			sortedList.add(ow.getWrappedObject());
		}

		//return sorted object list. 
		return sortedList;
	}


	/**
	 * Sorts list in alaphabetic order
	 * 
	 * @param	objectList	the list of objects to be sorted. 
	 * @param 	soertValue	the value to sort by
	 * @return 	the sorted list. 
	 */
	 public static List<sObject> sortAlpha(List<Object> objectList, String sortValue) {
	 	//Build list of wrapper objects 
		List<ObjectWrapper> wrapperList = new List<ObjectWrapper>(); 
		for (Object o: objectList) {
			wrapperList.add(new ObjectWrapper((sObject)o, 'ALPHA', sortValue));
		}
		
		//sort wrapper list
		wrapperList.sort();

		//get object list from wrapper list
		List<sObject> sortedList = new List<sObject>(); 
		for (ObjectWrapper ow: wrapperList) {
			sortedList.add(ow.getWrappedObject());
		}

		//return sorted object list. 
		return sortedList;
	 }



	/**
	 * Inner class used to override the compareTo method so that an 
	 * sObject list can be sorted according to the method desired. 
	 * 
	 * @author Mike McGee
	 */
	 public class ObjectWrapper implements Comparable {

	 	/** is true if sorting style is ascending, false otherwise */
	 	String style;
	 	/** Stat to compare aginst */
	 	String statName;
	 	/** sObject associated with wrapper */
	 	sObject wrappedObject; 

	 	/**  
	 	 * Creates new objectWrapper with sort style and stat to sort by
	 	 */
	 	public objectWrapper(sObject wrappedObject, String style, String statName) {
	 		this.wrappedObject = wrappedObject; 
	 		this.style = style; 
	 		this.statName = statName; 
	 	}


	 	/**
	 	 * gets the object that was wrapped
	 	 * @return the wrapped object
	 	 */
	 	 public sObject getWrappedObject() {
	 	 	return this.wrappedObject; 
	 	 }


	 	/**
	 	 * Overrides the <code>compareTo</code> method based off the object criteria
	 	 * <p> Used to force <code>List.sort()</code> functionality
	 	 */
	 	 public Integer compareTo(Object compareTo) {
	 	 	//Cast argument to objectWrapper
	 	 	ObjectWrapper compareToObj = (ObjectWrapper)compareTo;

	 	 	Integer returnValue = 0; 

	 	 	if (this.style.equalsIgnoreCase('ASC')) {
	 	 		//Higher value is ranked higher
	 	 		if ( Double.valueOf(wrappedObject.get(statName)) > Double.valueOf(compareToObj.wrappedObject.get(statName)) ) {
	 	 			return 1; 
	 	 		} else if (Double.valueOf(wrappedObject.get(statName)) < Double.valueOf(compareToObj.wrappedObject.get(statName))) {
	 	 			return -1;
	 	 		} 

	 	 		return returnValue;

	 	 	} else if (this.style.equalsIgnoreCase('DESC')) {
	 	 		//lower value is ranked higher
	 	 		if ( Double.valueOf(wrappedObject.get(statName)) < Double.valueOf(compareToObj.wrappedObject.get(statName)) ) {
	 	 			return 1; 
	 	 		} else if (Double.valueOf(wrappedObject.get(statName)) > Double.valueOf(compareToObj.wrappedObject.get(statName))) {
	 	 			return -1;
	 	 		} 

	 	 		return returnValue;
	 	 	} else if (this.style.equalsIgnoreCase('ALPHA')) {
	 	 		if ( String.valueOf(wrappedObject.get(statName)) > String.valueOf(compareToObj.wrappedObject.get(statName)) ) {
	 	 			return 1; 
	 	 		} else if (String.valueOf(wrappedObject.get(statName)) < String.valueOf(compareToObj.wrappedObject.get(statName))) {
	 	 			return -1;
	 	 		}

	 	 		return returnValue;

	 	 	} else {
	 	 		return 0;
	 	 	}
	 	 }

	 }

}