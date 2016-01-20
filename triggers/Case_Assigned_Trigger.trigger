trigger Case_Assigned_Trigger on Case (before insert, before update) {
    
    for (Case iter: trigger.new) {
        if (iter.CRT_Review_DT__c == null && iter.Status != 'Unassigned') {
            iter.CRT_Review_DT__c = DateTime.now(); 
        }
    }
}