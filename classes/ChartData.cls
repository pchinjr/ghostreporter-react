/**
 * Class that represents the data that will be used in the Chart components. 
 * Must have a category and a value in order to be rendered by the charts. 
 * 
 * @author Mike McGee
 */
public with sharing class ChartData {

	/** The name of the category that will appear at the bottom of the page */
	String categoryName;

	/** The value that is associated with that category */
	Integer value; 

	/**
	 * Construcotr to set the category name and value associated with it. 
	 * @param categoryName The name of the category that will appear at the bottom
	 * @param value The value associated with the category. 
	 */
	public ChartData(String categoryName, Integer value) {
		if (categoryName == null) {
			categoryName = 'Not Specified';
		}
		this.categoryName = categoryName; 
		this.value = value;
	}

	/**
	 * Gets the value of the category
	 */
	public Integer getValue() {
		return this.value;
	}

	/**
	 * Gets the name of the category. 
	 */
	public String getCategoryName() {
		return this.categoryName;
	}
}