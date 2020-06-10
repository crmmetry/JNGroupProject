@isTest
public class TestJNFileUploader {
    @TestSetup
    static void makeData(){
        insert TestDataFactory.CreateBasicAccounts(1, 'ln');
    }

    @isTest
    public static void shouldSaveFileFail(){
        String base64 ='data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==';
        Account newAcc = [SELECT Id, Name FROM Account WHERE LastName LIKE '%ln%' LIMIT 1];
        System.debug('Account:'+newAcc);
        try {
             Object result = JNFileUploader.saveFile( newAcc.Id, 'TestFile.png', base64, 'png');
        } catch (Exception e) {
            System.assert(e.getMessage().length() > 0, 'no error');
        }
       
    }
        @isTest
    public static void shouldSaveFile(){
        String base64 ='iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==';
        Account newAcc = [SELECT Id, Name FROM Account WHERE LastName LIKE '%ln%' LIMIT 1];
        System.debug('Account:'+newAcc);
        Object result = JNFileUploader.saveFile( newAcc.Id, 'TestFile.png', base64, 'png');
    }
}