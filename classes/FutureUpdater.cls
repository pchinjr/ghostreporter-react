/**
 * FutureUpdater is used to update sObjects that could potentially 
 * be in a race condition with other objects, and is an attempt to 
 * abstract out the update process. 
 * <p>
 * When using FutureUpdater there are two steps. 
 * <ul>
 * <li> Step 1: set the sObject to be updated
 * <li> Step 2: call to updateObject method
 * </ul>
 * 
 * @author Mike McGee
 */
public class FutureUpdater {
	
    //sObject that needs to be updated
    private static sObject toUpdate; 

    /** List of objects to update */
    private static List<sObject> listToUpdate;
    
    /**
     * Performs update on the toUpdate, uses future tag so that 
     * update will occur even if the sObject is currently being modified 
     * somewhere else. 
     * <p> 
     * The tag should make the update pause until all resources are available
     * to the method. 
     * 
     * @author Mike McGee 
     */
    @future 
    public static void updateObject() {
        if (toUpdate == null) {
            system.debug(LoggingLevel.ERROR, 'toUpdate must be set using FutureUpdater.setToUpdate(objectToBeUpdated) before update can be called');
            return; 
        }
        update toUpdate; 
        clearToUpdate(); 
    }


    /**
     * Performs update on the listToUpdate, uses future tag so that 
     * update will occur even if the sObject is currently being modified 
     * somewhere else. 
     * <p> 
     * The tag should make the update pause until all resources are available
     * to the method. 
     * 
     * @author Mike McGee 
     */
    @future 
    public static void updateList() {
        if (listToUpdate == null) {
            system.debug(LoggingLevel.ERROR, 'listToUpdate must be set using FutureUpdater.setListToUpdate(listToBeUpdated) before update can be called');
            return; 
        }
        update listToUpdate; 
        clearListToUpdate(); 
    }



    /**
     * Clears the toUpdate field so that it is
     * no longer a part of the running context. 
     * <p>
     * Using this method after an update will ensure that anytime 
     * an update is requested, a previous set for toUpdate
     * will have been required for update to take place. 
     * Attempts to ensure that client is updating desired sObject. 
     */
    public static void clearListToUpdate() {
        listToUpdate = null; 
    }


    
    /**
     * Clears the toUpdate field so that it is
     * no longer a part of the running context. 
     * <p>
     * Using this method after an update will ensure that anytime 
     * an update is requested, a previous set for toUpdate
     * will have been required for update to take place. 
     * Attempts to ensure that client is updating desired sObject. 
     */
    public static void clearToUpdate() {
        toUpdate = null; 
    }
    
    /**
     * Sets the toUpdate field so that no instance of the class is necessary. 
     * <p>
     * allows this class to act as purely a utility with no state. 
     * 
     * @author 	Mike McGee. 
     * @param 	objectToBeUpdated	the sObject that needs to be updated
     */
    public static void setToUpdate(sObject objectToBeUpdated) {
        toUpdate = objectToBeUpdated; 
    }



    /**
     * Sets the listToUpdate field so that no instance of the class is necessary. 
     * <p>
     * allows this class to act as purely a utility with no state. 
     * 
     * @author  Mike McGee. 
     * @param   listToBeUpdated   the sObject that needs to be updated
     */
    public static void setListToUpdate(List<sObject> listToBeUpdated) {
        listToUpdate = listToBeUpdated; 
    }
    
}