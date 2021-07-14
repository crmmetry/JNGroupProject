/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 07-14-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   07-09-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
public class OneJNOnBoardingDeserialiser {
  @AuraEnabled
  public Account accountRecord;
  @AuraEnabled
  public String Id;
  @AuraEnabled
  public String UserName;
  @AuraEnabled
  public String Firstname;
  @AuraEnabled
  public String MiddleName;
  @AuraEnabled
  public String LastName;
  @AuraEnabled
  public String PhoneNumber;
  @AuraEnabled
  public String Email;
  @AuraEnabled
  public String ProfileState;
  @AuraEnabled
  public String DateString; // Date is reserved keyword: DateString
  @AuraEnabled
  public String Trn;
  @AuraEnabled
  public String Gender;
  @AuraEnabled
  public DateTime DOB;
  @AuraEnabled
  public String Nationality;
  @AuraEnabled
  public IdentificationWrapper Identification;

  @AuraEnabled
  public String PhoenixId;
  @AuraEnabled
  public String JnRewardsAccount;
  @AuraEnabled
  public List<String> MarketingPreferences;
  @AuraEnabled
  public AddressWrapper Address;

  public class IdentificationWrapper {
    @AuraEnabled
    public String IdNumber;
    @AuraEnabled
    public String IdType;
    @AuraEnabled
    public DateTime IdIssueDate;
    @AuraEnabled
    public DateTime IdExpiryDate;
  }

  public class Preferences {
    @AuraEnabled
    public String Id;
    @AuraEnabled
    public String Name;
    @AuraEnabled
    public String Description;
  }
  public class AddressWrapper {
    @AuraEnabled
    public String Street1;
    @AuraEnabled
    public String Street2;
    @AuraEnabled
    public String city;
    @AuraEnabled
    public String Region;
    @AuraEnabled
    public String Country;
    @AuraEnabled
    public String Zip;
  }

  /**
   * @description
   * @author Ishwari Gaikwad(Thinqloud) | 07-12-2021
   * @param deserialiser
   * @return OneJNOnBoardingDeserialiser
   **/
  public static OneJNOnBoardingDeserialiser parse(
    OneJNOnBoardingDeserialiser deserialiser,
    String eventType
  ) {
    List<String> processAllEvents = new List<String>{
      Constants.SUBMIT_PROFILE_EVENT_1,
      Constants.SUBMIT_PROFILE_EVENT_2,
      Constants.SUBMIT_PROFILE_EVENT_3,
      Constants.SUBMIT_PROFILE_EVENT_4,
      Constants.SUBMIT_PROFILE_EVENT_5
    };
    List<String> process_2_3_4_5 = new List<String>{
      Constants.SUBMIT_PROFILE_EVENT_2,
      Constants.SUBMIT_PROFILE_EVENT_3,
      Constants.SUBMIT_PROFILE_EVENT_4,
      Constants.SUBMIT_PROFILE_EVENT_5
    };
    List<String> process_4_5 = new List<String>{
      Constants.SUBMIT_PROFILE_EVENT_4,
      Constants.SUBMIT_PROFILE_EVENT_5
    };
    List<String> process_5 = new List<String>{
      Constants.SUBMIT_PROFILE_EVENT_5
    };

    deserialiser.accountRecord = new Account();
    try {
      if (Util.Some(processAllEvents, eventType)) {
        //Event 1,2,3,4,5
        deserialiser.accountRecord.FirstName = deserialiser.Firstname;
        deserialiser.accountRecord.LastName = deserialiser.LastName;
        deserialiser.accountRecord.MiddleName = deserialiser.MiddleName;
        deserialiser.accountRecord.PersonEmail = deserialiser.Email;
        deserialiser.accountRecord.PersonMobilePhone = deserialiser.PhoneNumber;
        deserialiser.accountRecord.GUID_Text__c = deserialiser.Id;
        deserialiser.accountRecord.ProfileState_List__c = deserialiser.ProfileState;
        deserialiser.accountRecord.UsernameText__c = deserialiser.UserName;
      }
      if (Util.Some(process_2_3_4_5, eventType)) {
        //Event 2,3,4,5
        deserialiser.accountRecord.ProfileCreateDate_Timestamp__c = Date.valueOf(
          deserialiser.DateString
        );
      }
      if (Util.Some(process_4_5, eventType)) {
        //event 4,5
        deserialiser.accountRecord.FinServ__Gender__pc = deserialiser.Gender;
        deserialiser.accountRecord.PersonBirthdate = Date.valueOf(
          deserialiser.DOB
        );
        deserialiser.accountRecord.Country_of_Citizenship__pc = deserialiser.Nationality;
        deserialiser.accountRecord.Identification_Number__c = deserialiser.Identification.IdNumber;
        deserialiser.accountRecord.Identification_Type__c = deserialiser.Identification.IdType;
        deserialiser.accountRecord.IDIssueDate_Date__c = Date.valueOf(
          deserialiser.Identification.IdIssueDate
        );
        deserialiser.accountRecord.ID_Expiration_Date__c = Date.valueOf(
          deserialiser.Identification.IdExpiryDate
        );
        deserialiser.accountRecord.Jamaican_Tax_Registration_Number__pc = deserialiser.TRN;
      }
      if (Util.Some(process_5, eventType)) {
        //Event 5
        deserialiser.accountRecord.RIM_no__c = deserialiser.PhoenixId;
        deserialiser.accountRecord.JNRewardsAcc_Text__c = deserialiser.JnRewardsAccount;
        deserialiser.accountRecord.MarketingPreferences_MList__c = String.join(
          deserialiser.MarketingPreferences,
          ';'
        );

        deserialiser.accountRecord.Street_1__pc = deserialiser.Address.Street1;
        deserialiser.accountRecord.Street_2__pc = deserialiser.Address.Street2;
        deserialiser.accountRecord.Country__c = deserialiser.Address.Country;
        deserialiser.accountRecord.City_Town__pc = deserialiser.Address.city;
        deserialiser.accountRecord.Province_Parish_State__pc = deserialiser.Address.Region;
        deserialiser.accountRecord.Post_Office_Zip_Code__pc = deserialiser.Address.Zip;
      }
    } catch (Exception e) {
      Util.handleOneJNExeption(e, eventType, deserialiser.Id, '');
    }
    return deserialiser;
  }
}
