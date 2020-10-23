public with sharing class Wrappers {
  /**
   * throws a null pointer exception with custom message
   * @param {String} - msg exception text
   * @return Void
   */
  public static void throwNullException(String msg) {
    NullPointerException error = new NullPointerException();
    error.setMessage(msg);
    throw error;
  }

  /**
   * Used for serializing a Lead
   * @constructor LeadWrapper
   */
  public class LeadWrapper {
    @AuraEnabled
    public String leadId;
    @AuraEnabled
    public String leadSource;
    @AuraEnabled
    public String firstName;
    @AuraEnabled
    public String lastName;
    @AuraEnabled
    public Decimal estimatedAmount;
    @AuraEnabled
    public String serviceOfInterest;
    @AuraEnabled
    public String salutation;
    @AuraEnabled
    public String middleName;
    @AuraEnabled
    public String suffix;
    @AuraEnabled
    public String gender;
    @AuraEnabled
    public String maritalStatus;
    @AuraEnabled
    public Date dob;
    @AuraEnabled
    public String birthPlace;
    @AuraEnabled
    public String maidenName;
    @AuraEnabled
    public Decimal dependentAdultNum;
    @AuraEnabled
    public Decimal dependentChildNum;
    @AuraEnabled
    public String citizenCountry;
    @AuraEnabled
    public String residentCountry;
    @AuraEnabled
    public String educationLevel;
    @AuraEnabled
    public String trn;
    @AuraEnabled
    public Date preferredContactDate;
    @AuraEnabled
    public Time preferredContactTime;
    @AuraEnabled
    public String preferredLocation;
    @AuraEnabled
    public String loanPurposeUL;
    @AuraEnabled
    public Decimal grossMonthlyIncome;
    @AuraEnabled
    public Decimal grossMonthlyExpenses;
    @AuraEnabled
    public Id recordTypeId;

    public LeadWrapper(Lead record) {
      if (record == null) {
        Wrappers.throwNullException('Lead record cannot be null');
      }
      this.leadId = record.Id;
      this.leadSource = record.LeadSource;
      this.firstName = record.FirstName;
      this.lastName = record.LastName;
      this.estimatedAmount = record.Estimated_Amount__c;
      this.serviceOfInterest = record.Service_of_Interest__c;
      this.salutation = record.Salutation;
      this.middleName = record.MiddleName;
      this.suffix = record.Suffix;
      this.gender = record.Gender__c;
      this.maritalStatus = record.Marital_Status__c;
      this.dob = record.Date_of_Birth__c;
      this.birthPlace = record.Place_of_Birth__c;
      this.maidenName = record.Mother_s_Maiden_Name__c;
      this.dependentAdultNum = record.Number_of_Dependent_Adults__c;
      this.dependentChildNum = record.Number_of_Dependent_Children__c;
      this.citizenCountry = record.Country_of_Citizenship__c;
      this.residentCountry = record.Country_of_Residence__c;
      this.educationLevel = record.Highest_Level_of_Education_Attained__c;
      this.trn = record.Jamaican_Tax_Registration_Number__c;
      this.preferredContactDate = record.Preferred_Date_of_Contact__c;
      this.preferredContactTime = record.Preferred_Time_of_Contact__c;
      this.preferredLocation = record.Preferred_Location__c;
      this.loanPurposeUL = record.Loan_Purpose_UL__c;
      this.grossMonthlyIncome = record.Gross_Monthly_Income__c;
      this.grossMonthlyExpenses = record.Gross_Monthly_Expenses__c;
      this.recordTypeId = record.RecordTypeId;
    }
  }
  /**
   * Used for deserializing a Lead
   * @constructor LeadUnwrapper
   */
  public class LeadUnwrapper {
    @AuraEnabled
    public String leadId;
    @AuraEnabled
    public String leadSource;
    @AuraEnabled
    public String firstName;
    @AuraEnabled
    public String lastName;
    @AuraEnabled
    public Decimal estimatedAmount;
    @AuraEnabled
    public String serviceOfInterest;
    @AuraEnabled
    public String salutation;
    @AuraEnabled
    public String middleName;
    @AuraEnabled
    public String suffix;
    @AuraEnabled
    public String gender;
    @AuraEnabled
    public String maritalStatus;
    @AuraEnabled
    public Date dob;
    @AuraEnabled
    public String birthPlace;
    @AuraEnabled
    public String maidenName;
    @AuraEnabled
    public Decimal dependentAdultNum;
    @AuraEnabled
    public Decimal dependentChildNum;
    @AuraEnabled
    public String citizenCountry;
    @AuraEnabled
    public String residentCountry;
    @AuraEnabled
    public String educationLevel;
    @AuraEnabled
    public String trn;
    @AuraEnabled
    public Date preferredContactDate;
    @AuraEnabled
    public Time preferredContactTime;
    @AuraEnabled
    public String preferredLocation;
    @AuraEnabled
    public String loanPurposeUL;
    @AuraEnabled
    public Decimal grossMonthlyIncome;
    @AuraEnabled
    public Decimal grossMonthlyExpenses;
    @AuraEnabled
    public Id recordTypeId;
    @AuraEnabled
    public Lead lead;

    public LeadUnwrapper(LeadWrapper leadWrapper) {
      if (leadWrapper == null) {
        Wrappers.throwNullException('LeadWrapper record cannot be null');
      }
      this.lead = new Lead();
      this.lead.Id = leadWrapper.leadId;
      this.lead.LeadSource = leadWrapper.leadSource;
      this.lead.FirstName = leadWrapper.firstName;
      this.lead.LastName = leadWrapper.lastName;
      this.lead.Estimated_Amount__c = leadWrapper.estimatedAmount;
      this.lead.Service_of_Interest__c = leadWrapper.serviceOfInterest;
      this.lead.Salutation = leadWrapper.salutation;
      this.lead.MiddleName = leadWrapper.middleName;
      this.lead.Suffix = leadWrapper.suffix;
      this.lead.Gender__c = leadWrapper.gender;
      this.lead.Marital_Status__c = leadWrapper.maritalStatus;
      this.lead.Date_of_Birth__c = leadWrapper.dob;
      this.lead.Place_of_Birth__c = leadWrapper.birthPlace;
      this.lead.Mother_s_Maiden_Name__c = leadWrapper.maidenName;
      this.lead.Number_of_Dependent_Adults__c = leadWrapper.dependentAdultNum;
      this.lead.Number_of_Dependent_Children__c = leadWrapper.dependentChildNum;
      this.lead.Country_of_Citizenship__c = leadWrapper.citizenCountry;
      this.lead.Country_of_Residence__c = leadWrapper.residentCountry;
      this.lead.Highest_Level_of_Education_Attained__c = leadWrapper.educationLevel;
      this.lead.Jamaican_Tax_Registration_Number__c = leadWrapper.trn;
      this.lead.Preferred_Date_of_Contact__c = leadWrapper.preferredContactDate;
      this.lead.Preferred_Time_of_Contact__c = leadWrapper.preferredContactTime;
      this.lead.Preferred_Location__c = leadWrapper.preferredLocation;
      this.lead.Loan_Purpose_UL__c = leadWrapper.loanPurposeUL;
      this.lead.Gross_Monthly_Income__c = leadWrapper.grossMonthlyIncome;
      this.lead.Gross_Monthly_Expenses__c = leadWrapper.grossMonthlyExpenses;
      this.lead.RecordTypeId = leadWrapper.recordTypeId;
    }
  }

  /**
   * Used for serializing a LeadRelatedPerson
   * @constructor LeadRelatedPersonWrapper
   */
  public class LeadRelatedPersonWrapper {
    @AuraEnabled
    public String leadRelatedPersonId;
    @AuraEnabled
    public String title;
    @AuraEnabled
    public String firstName;
    @AuraEnabled
    public String middleName;
    @AuraEnabled
    public String lastName;
    @AuraEnabled
    public String trn;
    @AuraEnabled
    public String role;
    @AuraEnabled
    public String relationship;
    @AuraEnabled
    public String affiliateType;
    @AuraEnabled
    public String leadId;
    @AuraEnabled
    public String mobileNumber;

    public LeadRelatedPersonWrapper(Lead_Related_Person__c record) {
      if (record == null) {
        Wrappers.throwNullException(
          'Lead Related Person record cannot be null'
        );
      }
      this.leadRelatedPersonId = record.Id;
      this.firstName = record.First_Name__c;
      this.lastName = record.Last_Name__c;
      this.trn = record.TRN__c;
      this.role = record.Role__c;
      this.relationship = record.Relationship__c;
      this.affiliateType = record.Afilliate_Type__c;
      this.leadId = record.Lead_and_Referral__c;
      this.title = record.Title__c;
      this.middleName = record.Middle_Name__c;
      this.mobileNumber = record.Mobile_Number__c;
    }
  }
  /**
   * Used for wrapping a Opportunity Product
   * @constructor ProductSelectionWrapper
   */
  public class ProductSelectionWrapper {
    @AuraEnabled
    public String productFamily;
    @AuraEnabled
    public String productName;
    @AuraEnabled
    public Decimal productPrice;

    public ProductSelectionWrapper(OpportunityLineItem record) {
      if (record == null) {
        Wrappers.throwNullException(
          'OpportunityLineItem record cannot be null'
        );
      }
      this.productFamily = record.Product_Family__c;
      this.productName = record.Name;
      this.productPrice = record.UnitPrice;
    }
  }
}
