@isTest
public class TestDocumentChecklistController {
    @isTest
    public static void shouldGetLocationValues(){
        List<string> optionlist = DocumentChecklistController.getLocationValues();
        System.assert(optionlist.size() >= 1, 'optionlist is empty');
    }
}
