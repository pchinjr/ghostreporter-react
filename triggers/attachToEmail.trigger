trigger attachToEmail on Attachment (after insert) {
    String parentid;
    String casenumber;
    for( Attachment a : trigger.new ) {  
        // Check the parent ID - if it's 02s, this is for an email message   
       if( a.parentid == null )     
            continue;       
        String s = string.valueof( a.parentid );     
         //System.debug('parentid=' + s);
        //    parentid = [select parentID from EmailMessage where parentid = :s].parentID; 
           // casenumber = [select casenumber from case where id =:parentid].casenumber;
        //    System.debug('parentid=' + s + ', casenumber = ' + casenumber);
       // System.debug('parentid after assign=' + parentid);
       
    }
    
     if(parentid != null){
             // List<Case> emailCase = [select id,SuppliedEmail, origin, casenumber from case where id =: parentid];
             // new SevereEmail(emailCase);
        }
      //  System.debug('after attachment');
   // List<Case> emailCase = [select id,SuppliedEmail, origin, casenumber from case where id =: parentid];
   // new SevereEmail(emailCase);
    
}