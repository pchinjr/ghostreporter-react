trigger emailAttachmentVisibleOnParent on Attachment (before insert) {
 String caseid1 ;
 
 for( Attachment a : trigger.new ) {  
       if( a.parentid != null )
       {     
          String s = a.parentid;     
          caseid1 = s;
          if( s.substring( 0, 3 ) == '02s' ) // 02s is for emailmessage
          {  
              a.parentid = [select parentID from EmailMessage where id = :a.parentid].parentID;  // bulkify this line !!! 
               System.debug('inserting attachment');
          }
       } 
    }
    
     
        
    
    
    
}