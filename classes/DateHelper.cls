public with sharing class DateHelper {

	/**
	 * Returns the string representation of the month passed in.
	 * @param month The integer value of the month with janary = 1
	 */
	public static String getMonthText(Integer month) {
		month++;
		return Datetime.newInstanceGmt(
			Date.newInstance(Date.today().year(), month, 1),
			Time.newInstance(0, 0, 0, 0))
			.format('MMM');
	}

}