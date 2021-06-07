/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 06-04-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public inherited sharing class RubiconProductDetailsController {
  @AuraEnabled
  public static Object getIDMProductDetails(Id oppId) {
    LoanCalculationProductWrapper loanProductRecord = ProductDetailSelector.getLoanCalculationRecord(
      oppId
    );
    if (loanProductRecord != null) {
      return loanProductRecord;
    }
    return Constants.NONE;
  }

  @AuraEnabled
  public static Object getApplicantsDetails(Id oppId) {
    List<ApplicantWrapper> applicants = ProductDetailSelector.getApplicantDetails(
      oppId
    );
    if (applicants.size() > 0) {
      return applicants;
    }
    return Constants.NONE;
  }

  @AuraEnabled
  public static Object getOpportunityDetails(Id oppId) {
    OpportunityWrapper opportunity = ProductDetailSelector.getOpportunityDetails(
      oppId
    );
    if (opportunity != null) {
      return opportunity;
    }
    return Constants.NONE;
  }

  /**
   * RUB-23
   * return a map of wrapper records belonging to applicant and their assets/liabilities
   * @param {Id} oppId - opportunity Id.
   * @return {List<SupplementaryCardHolderWrapper>} - returns  supplementary card holder details in wrapper format
   */
  @AuraEnabled
  public static List<SupplementaryCardHolderWrapper> getSupplementaryCardHolders(
    Id oppId
  ) {
    try {
      List<SupplementaryCardHolderWrapper> supplementaryWrapperList = ProductDetailSelector.getSupplementaryCardHolder(
        oppId
      );
      return supplementaryWrapperList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getStackTraceString());
    }
  }

  /**
   * Return a Product Selection Object consisting of an opportunity product name and family.
   * @param {Id} - oppId
   * @return Object
   */
  @AuraEnabled
  public static Object getSingleProductFamilySelection(Id oppId) {
    List<OpportunityLineItem> records = Util.getOpportunityProducts(oppId);
    if (records.size() == 1) {
      ProductSelectionWrapper selection = new ProductSelectionWrapper(
        records[0]
      );
      if (
        selection.productFamily == Constants.CREDITCARD_PRODUCT_FAMILY ||
        selection.productFamily == Constants.UNSECURED_PRODUCT_FAMILY
      ) {
        return selection;
      }
    }
    return Constants.NONE;
  }

  /**
   * get a list of pick list values from salesforce
   * @param {String} - objectApiName
   * @param {List<String>} - fieldApiNames
   * @return Object
   */

  @AuraEnabled
  public static Object getPickListValuesList(
    String objectApiName,
    List<String> fieldApiNames
  ) {
    String recordTypeId;
    List<String> pickListValuesList = new List<String>();
    Map<String, List<String>> mapFields = new Map<String, List<String>>();
    List<String> specificValues;
    Map<String, Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
    Schema.sObjectType sObjType = globalDescription.get(objectApiName);
    Schema.DescribeSObjectResult r1 = sObjType.getDescribe();
    Map<String, Schema.SObjectField> mapFieldList = r1.fields.getMap();

    for (String fieldApiName : fieldApiNames) {
      Schema.SObjectField field = mapFieldList.get(fieldApiName);
      Schema.DescribeFieldResult fieldResult = field.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      pickListValuesList = new List<String>();
      for (Schema.PicklistEntry pickListVal : ple) {
        pickListValuesList.add(pickListVal.getLabel());
      }
      mapFields.put(fieldApiName, pickListValuesList);
    }

    return mapFields;
  }

  /**
   * Gets picklist valkues for picklist per record type
   * @author Travis Allen | 06-04-2021
   * @param objectApiName
   * @param fieldApiName
   * @param recordTypeName
   * @param recordTypeId
   * @return List<String>
   **/
  @AuraEnabled
  public static List<String> getPickListValues(
    String objectApiName,
    String fieldApiName,
    String recordTypeName,
    String recordTypeId
  ) {
    List<String> specificValues;
    if (recordTypeId == null && recordTypeName != null) {
      recordTypeId = getRecordTypeId(recordTypeName);
      specificValues = getPicklistValuesUIApi(
        recordTypeId,
        objectApiName,
        fieldApiName
      );
      return specificValues;
    } else if (recordTypeId != null) {
      specificValues = getPicklistValuesUIApi(
        recordTypeId,
        objectApiName,
        fieldApiName
      );
      return specificValues;
    } else {
      List<String> pickListValuesList = new List<String>();
      Map<String, Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
      Schema.sObjectType sObjType = globalDescription.get(objectApiName);
      Schema.DescribeSObjectResult r1 = sObjType.getDescribe();
      Map<String, Schema.SObjectField> mapFieldList = r1.fields.getMap();

      Schema.SObjectField field = mapFieldList.get(fieldApiName);
      Schema.DescribeFieldResult fieldResult = field.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for (Schema.PicklistEntry pickListVal : ple) {
        pickListValuesList.add(pickListVal.getLabel());
      }
      return pickListValuesList;
    }
  }

  /**
   * Making callout to the UI API to get the list of available picklist values based on the selected recordtype
   * @author Travis Allen | 06-04-2021
   * @param recordTypeId
   * @param ObjectApiName
   * @param fieldApiName
   * @return string[]
   **/
  @AuraEnabled
  public static string[] getPicklistValuesUIApi(
    string recordTypeId,
    string ObjectApiName,
    string fieldApiName
  ) {
    string[] piclistValues = new List<string>{};
    string BaseUrl = system.Url.getOrgDomainUrl().toExternalForm();
    String endPoint =
      BaseUrl +
      '/services/data/v47.0/ui-api/object-info/' +
      ObjectApiName +
      '/picklist-values/' +
      recordTypeId +
      '/' +
      fieldApiName;
    httprequest request = new httprequest();
    request.setMethod('GET');
    request.setEndpoint(endPoint);
    request.setHeader('Content-Type', 'application/json; charset=UTF-8');
    request.setHeader('Accept', 'application/json');
    request.setHeader('Authorization', 'Bearer ' + getSessionIdFromVfPage());

    http http = new http();
    httpresponse response = http.send(request);
    System.debug(response.getBody());
    picklistWrapper obj = new picklistWrapper();
    obj = (picklistWrapper) JSON.deserialize(
      response.getBody(),
      picklistWrapper.class
    );

    for (picklistValues pickVal : obj.values) {
      piclistValues.add(pickVal.value);
    }
    return piclistValues;
  }
  //Wrapper class to handle the JSON response

  public class picklistWrapper {
    @AuraEnabled
    public pickListValues[] values;
  }

  public class pickListValues {
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String value;
  }

  /**
   * Get record type Id for a specific recordTypeName
   * @author Travis Allen | 06-04-2021
   * @param recordTypeName
   * @return String
   **/
  @AuraEnabled
  public static String getRecordTypeId(String recordTypeName) {
    return [SELECT id FROM RecordType WHERE DeveloperName = :recordTypeName].Id;
  }

  /**
   * Getting the session Id from the VF page to make the callouts
   * @author Travis Allen | 06-04-2021
   * @return string
   **/
  private static string getSessionIdFromVfPage() {
    PageReference visualforcePage = Page.SessionIdPage;
    String content;
    try {
      content = visualforcePage.getContent().toString();
    } catch (VisualforceException e) {
      content = 'ID' + userinfo.getSessionId() + 'END';
    }
    Integer s = content.indexOf('ID') + 'ID'.length();
    Integer e = content.indexOf('END');
    return content.substring(s, e);
  }

  @AuraEnabled
  public static Object updateFieldsOnOpportunity(
    Id oppId,
    Map<String, Object> fieldValueSets
  ) {
    try {
      Opportunity oppRecord = new Opportunity(Id = oppId);
      for (String key : fieldValueSets.keySet()) {
        oppRecord.put(key, fieldValueSets.get(key));
      }
      update oppRecord;
      System.debug('Update Successful: ' + oppRecord);
    } catch (Exception e) {
      throw new AuraHandledException(e.getStackTraceString());
    }
    return Constants.SUCCESS;
  }
}
