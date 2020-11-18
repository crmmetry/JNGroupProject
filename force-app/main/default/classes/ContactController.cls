public class ContactController {
  @AuraEnabled
  public static Contact CreateNewContact(Contact con) {
    upsert con;
    return con;
  }
}
