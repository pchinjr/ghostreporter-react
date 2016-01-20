/**
 * Base class for representing a pair data type. 
 * used for any set of two objects that need to be
 * tansfered together to another class or method.
 * Useful for sorting when a given statistic has a certain 
 * ordering style associated with it. 
 *
 * @author Mike McGee 
 */
public virtual class Pair {
	
	/** The first object in the pair */
	private Object first; 
	/** The second object in the pair */
	private Object second; 

	/** 
	 * Creates a pair of objects 
	 */
	public Pair(Object first, Object second) {
		this.first = first;
		this.second = second; 
	}

	/**
	 * Gets the first object in the pair
	 * @return	The first object in the pair
	 */
	 public Object getFirst() {
	 	return this.first; 
	 }

	 /**
	  * Gets the second object in the list
	  * @return	The second object in the list
	  */
	  public object getSeoond() {
	  	return this.second; 
	  }

	  /**
	   * Determines if the two  memebers of the pair
	   * are equal to each other. 
	   * <p> Should be overridden by any child class. 
	   *
	   * @return true if the pair is equal, false otherwise.
	   */
	   public boolean equals() {
	   		return first.equals(second); 
	   }
}