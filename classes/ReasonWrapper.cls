public class ReasonWrapper {
	
	public String createdMonth{get;set;}
	public List<String> reasonText{get;set;}
	public List<Integer> reasonCount{get;set;}

	private Map<String, Integer> reasonMap;

	private static Map<Integer, ReasonWrapper> wrapperMap = 
		new Map<Integer, ReasonWrapper>();
	private static Set<Integer> monthSet =
		new Set<Integer>();
		
	public static ReasonWrapper getInstance(AggregateResult agg) {
		if (monthSet == null) {
			return new ReasonWrapper(agg);
		} else if (!monthSet.contains((Integer)agg.get('createdMonth'))) {
			return new ReasonWrapper(agg);
		} else { 
			// This means there is already data for this month.
			// Just add to month and return the reference that 
			// already exists. 
			ReasonWrapper wrapper = 
				wrapperMap.get((Integer)agg.get('createdMonth'));
			wrapper.addToReason(String.valueOf(agg.get('reason')),
								Integer.valueOf(agg.get('reasonCount')));
			return wrapper;
		}
	}

	private ReasonWrapper(AggregateResult agg) {
		this.reasonMap = new Map<String, Integer>();
		this.addToReason(String.valueOf(agg.get('reason')),
						 Integer.valueOf(agg.get('reasonCount')));
		this.createdMonth =
			DateHelper.getMonthText(Integer.valueOf(agg.get('createdMonth')));
		// Add to set and map
		wrapperMap.put(Integer.valueOf(agg.get('createdMonth')), this);
		monthSet.add(Integer.valueOf(agg.get('createdMonth')));
	}

	public void addToReason(String reasonName, Integer reasonCount) {
		Integer curCount = this.reasonMap.get(reasonName);
		if (curCount == null) {
			// reason not yet in map
			this.reasonMap.put(reasonName, reasonCount);
		} else {
			// reason is already in map
			this.reasonMap.put(reasonName, reasonCount + curCount);
		}

		this.reasonCount = this.reasonMap.values();
		this.reasonText = new List<String>(this.reasonMap.keySet());
	}
}