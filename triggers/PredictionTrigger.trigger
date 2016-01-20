/**
 * PredicitonTrigger: sends all cases that have not yet been analyzed to 
 * PredictionCaller to be analyed by the google prediction api
 *
 */
trigger PredictionTrigger on Case (before insert) {
    
    if(!Test.isRunningTest()){
        PredictionCaller.predictionCall();
    }
    
    
}