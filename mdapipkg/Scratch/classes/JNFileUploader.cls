public class JNFileUploader {
    @AuraEnabled
    public static Object saveFile(Id parentId, String fileName, String base64Data, String contentType) {
        ContentVersion conVer = new ContentVersion();
        try {
            String extension = fileName.substring(fileName.lastIndexOf('.')+1);
            String name = fileName.substring(0, fileName.lastIndexOf('.'));
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = name; // Display name of the files
            conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
            insert conVer;
            
            // First get the content document Id from ContentVersion
            List<ContentVersion> contentVersions = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id];
            if(!contentVersions.isEmpty()){
                Id conDoc = contentVersions.get(0).ContentDocumentId;
                //Create ContentDocumentLink
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = conDoc;
                cDe.LinkedEntityId = parentId; // you can use objectId,GroupId etc
                cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                
                insert cDe;
                return cDe.Id;
            } 
            return null;
            
        } catch(Exception e) {
            System.debug(e);
            
            return e;
        }
    }
    
}