/**
 * Interface for building select lists for visual force pages. 
 * @author Mike McGee
 */
public interface SelectListBuilder {

    List<SelectOption> buildSelectList(List<sObject> optionList);
    
}