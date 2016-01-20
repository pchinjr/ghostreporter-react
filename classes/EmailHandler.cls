/**
 * This class is used to handle inbound emails to the created EmailService. 
 * Created on: 01/19/2016
 * @author Mike McGee
 */ 
global class EmailHandler implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		  Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          // Implement logic here
          try{
              ErrorDisputeHelper.processDispute(email);
          } catch (Exception e) {
              result.success = false;
          }
          result.success = true;
          
          return result;
      }
  }