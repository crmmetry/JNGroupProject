/*
    Sr#     Ticket#      Modified By                Modified Date       Description
 *    1     JN1-2780      Ishwari Gaikwad.(TQ)      02/11/2020        1.General Info Field Mapping  
 *    2     JN1-2781      Ishwari Gaikwad.(TQ)      02/11/2020        1.Contact Details Field Mapping
 *    3     JN1-2791      Ishwari Gaikwad.(TQ)      02/11/2020        Line Of Credit Request Field Mapping
 *    4     JN1-2788      Ishwari Gaikwad.(TQ)      02/11/2020        Auto Loan Request Field Mapping
 *    5     JN1-2782      Ishwari Gaikwad.(TQ)      02/12/2020        Emergency Contact Field Mapping
*/

public class ApplicationForm {
  public static integer isFirst = 1;
  public List<WrapperApplicationForm> lst { get; set; }
  public List<Loan_Calculator__c> ProductDetails { get; set; }
  Integer Appcount = 1;
  public Date currentDate { get; set; }
  public Boolean isAutoFound { get; set; }
  public Boolean isUnFound { get; set; }
  public Boolean isCcFound { get; set; }
  public Boolean isLocFound { get; set; }
  public List<Account> emergencyContacts { get; set; }
  public Integer totalNumberOfAppli { get; set; }
  public string mypdf = '';
  public List<Applicant__c> lstapp { get; set; }
  public ApplicationForm() {
    lst = new List<WrapperApplicationForm>();
    ProductDetails = new List<Loan_Calculator__c>();
    currentDate = system.today();
    isAutoFound = false;
    isUnFound = false;
    isCcFound = false;
    isLocFound = false;
    totalNumberOfAppli = 0;

    if (ApexPages.currentPage().getParameters().containsKey('oppid')) {
      string oppid = ApexPages.currentPage().getParameters().get('oppid');
      system.debug('oppid ====>' + oppid);
      if (string.isNotBlank(oppid)) {
        ApplicationForm(oppid);
        fillProductDetails(oppid);
        // if(!CreditScoreHelper.FirstRun){
        // CreditScoreHelper.FirstRun=true;
        //saveAttachement(oppid);

        //}
      }
    }
  }
  public void ApplicationForm1() {
    lst = new List<WrapperApplicationForm>();
    ProductDetails = new List<Loan_Calculator__c>();
    currentDate = system.today();
    isAutoFound = false;
    isUnFound = false;
    isCcFound = false;
    isLocFound = false;
    totalNumberOfAppli = 0;

    if (ApexPages.currentPage().getParameters().containsKey('oppid')) {
      string oppid = ApexPages.currentPage().getParameters().get('oppid');
      system.debug('oppid ====>' + oppid);
      if (string.isNotBlank(oppid)) {
        ApplicationForm(oppid);
        fillProductDetails(oppid);
      }
    }
  }

  public void ApplicationForm(string oppid) {
    Map<id, List<FinServ__ContactContactRelation__c>> AccidVsEmrConLst = new Map<id, List<FinServ__ContactContactRelation__c>>();
    Map<id, List<FinServ__Employment__c>> AccidVsEmpLst = new Map<id, List<FinServ__Employment__c>>();
    Map<id, List<FinServ__ContactContactRelation__c>> MapPoliExpo = new Map<id, List<FinServ__ContactContactRelation__c>>();
    Map<id, List<FinServ__ContactContactRelation__c>> MapBankAff = new Map<id, List<FinServ__ContactContactRelation__c>>();
    Map<id, Applicant__c> applicantMap = new Map<id, Applicant__c>();
    set<id> accid = new Set<id>();
    set<id> conid = new Set<id>();
    lstapp = [
      SELECT
        Account__c,
        Account__r.FinServ__PrimaryContact__c,
        Account__r.PersonContactId,
        Gross_Monthly_Income__c,
        Other_Income__c,
        Personal_Expenses_Monthly_Prior_Loan__c,
        Rent_Strata_Maintenance__c,
        Savings_Pension_Insurance_Number__c,
        Overdraft_Limit__c,
        Life_Insurance_Cash_Value__c,
        Pension_IRS_Total_Contribution__c,
        Savings_Deposit_Investments__c,
        Other_Loan_Loan_Balance_Number__c,
        Real_Estate_Market_Value_Number__c,
        Real_Estate_Loan_Balance_Number__c,
        Real_Estate_Monthly_Payment_Number__c,
        Motor_Vehicle_Market_Value_Number__c,
        Motor_Vehicle_Loan_Balance_Number__c,
        Motor_Vehicle_Monthly_Payment_Number__c,
        Other_Asset_Market_Value_Number__c,
        Other_Asset_Loan_Balance_Number__c,
        Other_Asset_Monthly_Payment_Number__c,
        (
          SELECT
            Id,
            Assets_and_Liabilities__c,
            Name,
            Minimum_Payment_Calc__c,
            Minimum_Payment_After_Calc__c,
            Assets_and_Liabilities__r.RecordType.DeveloperName,
            Assets_and_Liabilities__r.Lender__c,
            Assets_and_Liabilities__r.Asset_Credit_Limit__c,
            Assets_and_Liabilities__r.Asset_Credit_Balance__c,
            Assets_and_Liabilities__r.Asset_Credit_Balance_After__c
          FROM Application_Assets_Liabilities__r
        )
      FROM Applicant__c
      WHERE Opportunity__c = :oppid
    ];
    if (lstapp.size() > 0) {
      totalNumberOfAppli = lstapp.size();

      for (Applicant__c a : lstapp) {
        accid.add(a.Account__c);
        conid.add(a.Account__r.PersonContactId);
        applicantMap.put(a.Account__c, a);
      }
    }
    system.debug('accid======' + accid);
    system.debug('conid=============' + conid);
    if (conid.size() > 0) {
      Set<id> accountIds = new Set<Id>();
      List<FinServ__ContactContactRelation__c> EmergencyContactlst = [
        SELECT
          FinServ__RelatedContact__c,
          FinServ__Contact__r.FirstName,
          FinServ__RelatedContact__r.Account.Id,
          FinServ__RelatedContact__r.LastName,
          FinServ__RelatedContact__r.MiddleName,
          FinServ__RelatedContact__r.Account.Emergency_Contact_Relationship__pc,
          FinServ__RelatedContact__r.Account.Street_1__pc,
          FinServ__RelatedContact__r.Account.Street_2__pc,
          FinServ__RelatedContact__r.Account.Street_3__pc,
          FinServ__RelatedContact__r.Account.City_Town__pc,
          FinServ__RelatedContact__r.Account.Residential_Area_District__pc,
          FinServ__RelatedContact__r.Account.Post_Office_Zip_Code__pc,
          FinServ__RelatedContact__r.Account.Province_Parish_State__pc,
          FinServ__RelatedContact__r.Account.PersonMobilePhone,
          FinServ__RelatedContact__r.Account.Business_Phone__pc,
          FinServ__RelatedContact__r.Account.PersonHomePhone,
          FinServ__RelatedContact__r.Account.Personal_Email__c,
          FinServ__RelatedContact__r.Account.PersonOtherPhone,
          FinServ__RelatedContact__r.Account.FinServ__CountryOfBirth__pc
        FROM FinServ__ContactContactRelation__c
        WHERE
          FinServ__RelatedContact__c IN :conid
          AND FinServ__Role__r.Name = 'Emergency Contact'
      ];
      system.debug('EmergencyContactlst===>' + EmergencyContactlst);
      Set<id> emergencyAccountIds = new Set<Id>();
      if (EmergencyContactlst.size() > 0) {
        for (FinServ__ContactContactRelation__c c : EmergencyContactlst) {
          emergencyAccountIds.add(c.FinServ__RelatedContact__r.Account.Id);
          if (AccidVsEmrConLst.containsKey(c.FinServ__RelatedContact__c)) {
            List<FinServ__ContactContactRelation__c> aclst = AccidVsEmrConLst.get(
              c.FinServ__RelatedContact__c
            );
            if (aclst.size() < 2) {
              aclst.add(c);
              AccidVsEmrConLst.put(c.FinServ__RelatedContact__c, aclst);
            }
          } else {
            List<FinServ__ContactContactRelation__c> aclst = new List<FinServ__ContactContactRelation__c>();
            aclst.add(c);
            AccidVsEmrConLst.put(c.FinServ__RelatedContact__c, aclst);
          }
        }
      }
      // JN1-2782 : field added to the query
      this.emergencyContacts = [
        SELECT
          Id,
          FirstName,
          LastName,
          MiddleName,
          Emergency_Contact_Relationship__pc,
          Street_1__pc,
          Street_2__pc,
          FinServ__CountryOfBirth__pc,
          Street_3__pc,
          City_Town__pc,
          Residential_Area_District__pc,
          Post_Office_Zip_Code__pc,
          Province_Parish_State__pc,
          PersonMobilePhone,
          Business_Phone__pc,
          PersonHomePhone,
          Personal_Email__c,
          PersonOtherPhone,
          Emergency_Contact_Middle_Initial__pc, // JN1-2782
          Emergency_Contact_Last_Name__pc,
          Emergency_Contact_First_Name__pc,
          Country__c,
          Emergency_Contact_Mobile__pc,
          Emergency_Contact_Home_Phone__pc,
          Emergency_Contact_Business_Phone__pc,
          Emergency_Contact_Email__pc,
          Political_Exposure__pc
        FROM Account
        WHERE id IN :emergencyAccountIds
      ];

      List<FinServ__ContactContactRelation__c> PoliExpolst = [
        SELECT
          FinServ__RelatedContact__c,
          FinServ__Contact__r.FirstName,
          FinServ__Contact__r.LastName,
          FinServ__Contact__r.MiddleName,
          FinServ__Contact__r.Political_Exposure__c,
          FinServ__Contact__r.Account.Political_Affiliation_Role__pc,
          FinServ__Contact__r.Account.Political_Affiliation_Relationship__pc
        FROM FinServ__ContactContactRelation__c
        WHERE
          FinServ__RelatedContact__c IN :conid
          AND FinServ__Role__r.Name = 'Political Affiliation'
      ];

      if (PoliExpolst.size() > 0) {
        for (FinServ__ContactContactRelation__c pa : PoliExpolst) {
          List<FinServ__ContactContactRelation__c> lst = new List<FinServ__ContactContactRelation__c>();
          lst.add(pa);
          MapPoliExpo.put(pa.FinServ__RelatedContact__c, lst);
        }
      }

      List<FinServ__ContactContactRelation__c> BankAffilst = [
        SELECT
          FinServ__RelatedContact__c,
          FinServ__Contact__r.FirstName,
          FinServ__Contact__r.LastName,
          FinServ__Contact__r.MiddleName,
          FinServ__Contact__r.JN_Bank_Affiliation__c,
          FinServ__Contact__r.Account.JN_Bank_Affiliated_Location__pc,
          FinServ__Contact__r.Account.JN_Bank_Affiliation_Relationship__pc
        FROM FinServ__ContactContactRelation__c
        WHERE
          FinServ__RelatedContact__c IN :conid
          AND FinServ__Role__r.Name = 'JN Affiliation'
      ];

      if (BankAffilst.size() > 0) {
        for (FinServ__ContactContactRelation__c pa : BankAffilst) {
          List<FinServ__ContactContactRelation__c> lst = new List<FinServ__ContactContactRelation__c>();
          lst.add(pa);
          MapBankAff.put(pa.FinServ__RelatedContact__c, lst);
        }
      }
    }

    if (accid.size() > 0) {
      List<FinServ__Employment__c> Employmentlst = [
        SELECT
          id,
          RecordType.Name,
          Income_Type__c,
          Account__c,
          Current_Employment__c,
          Name,
          FinServ__Position__c,
          FinServ__EmploymentStatus__c,
          Professional_Category__c,
          FinServ__StartDate__c,
          FinServ__EndDate__c,
          Industry__c,
          Time_in_Industry__c,
          Time_Employed_in_Present_Industry_Months__c,
          FinServ__Occupation__c,
          Business_Number_1__c,
          Business_Number_2__c,
          Street_1__c,
          Street_2__c,
          Street_3__c,
          City_Town__c,
          Residential_Area_District__c,
          Post_Office_Zip_Code__c,
          Province_Parish_State__c,
          Country__c,
          Length_of_Trade__c,
          Nature_of_Engagement__c,
          Type_of_Business__c,
          Time_Employed_with_Current_Employer__c,
          Date_of_Incorporation__c,
          Time_Employed_in_Present_Employer_M__c,
          Time_Employed_with_Previous_Employer_M__c,
          Street_1_prev__c,
          Street_2_prev__c,
          Street_3_prev__c,
          City_Town_prev__c,
          Residential_Area_District_prev__c,
          Post_Office_Zip_Code_prev__c,
          Province_Parish_State_prev__c,
          Country_prev__c,
          Business_Number_1_prev__c,
          Business_Number_2_prev__c,
          Were_you_previously_employed__c,
          Name_of_Previous_Employer__c
        FROM FinServ__Employment__c
        WHERE Account__c IN :accid
      ];

      if (Employmentlst.size() > 0) {
        SetCalendarValues(Employmentlst);
        for (FinServ__Employment__c c : Employmentlst) {
          if (AccidVsEmpLst.containsKey(c.Account__c)) {
            List<FinServ__Employment__c> aclst = AccidVsEmpLst.get(
              c.Account__c
            );
            aclst.add(c);
            AccidVsEmpLst.put(c.Account__c, aclst);
          } else {
            List<FinServ__Employment__c> aclst = new List<FinServ__Employment__c>();
            aclst.add(c);
            AccidVsEmpLst.put(c.Account__c, aclst);
          }
        }
      }
      // JN1-2780,JN1-2781 : New Fields are added to query
      List<Account> ApplicantPersonAccount = [
        SELECT
          id,
          FinServ__PrimaryContact__c,
          Salutation,
          FirstName,
          LastName,
          MiddleName,
          Middle_Name__pc,
          FinServ__Gender__pc,
          Suffix__pc,
          FinServ__MaritalStatus__pc,
          //   Date_of_Birth__pc,
          Date_of_Birth__c, //new added
          Place_of_Birth__pc,
          //   FinServ__MotherMaidenName__pc,
          FinServ__NumberOfDependents__pc,
          Number_of_Dependent_Children__c,
          Country_of_Citizenship__pc,
          Country_of_Residency__pc,
          Highest_Level_of_Education_attained__pc,
          Primary_Employment_Type__pc,
          Identification_Type__pc,
          Identification_Number__pc,
          Identification_Type_Expiration__pc,
          Identification_Type_Country_of_issue__pc,
          Jamaican_Tax_Registration_Number__pc,
          Street_1__pc,
          Street_2__pc,
          Street_3__pc,
          City_Town__pc,
          Residential_Area_District__pc,
          Post_Office_Zip_Code__pc,
          Province_Parish_State__pc,
          FinServ__CountryOfBirth__pc,
          Years_at_Residence__pc,
          Status_of_Address__c,
          PersonMobilePhone,
          PersonHomePhone,
          Business_Phone__pc,
          // Personal_Email__c,
          //PersonOtherPhone,
          // JN1-2780
          PersonBirthdate,
          Mother_s_Maiden_Name__pc,
          ID_Expiration_Date__c,
          Identification_Number__c,
          Marital_Status__c,
          Number_of_Dependent_Adults__pc,
          Number_of_Dependent_Children__pc,
          //JN1-2781
          Status_of_Address__pc,
          Other_Number__c,
          PersonEmail,
          Country__c,
          Street_1_Prev__c,
          Street_2_Prev__c,
          Street_3_Prev__c,
          City_Town_Prev__c,
          Residential_Area_District_Prev__c,
          Post_Office_Zip_Code_Prev__c,
          Province_Parish_State_Prev__c,
          Country_Prev__c,
          Mailing_Street_1__pc,
          Mailing_Street_2__pc,
          Mailing_Street_3__pc,
          Mailing_City_Town__pc,
          Mailing_Residential_Area_District__pc,
          Mailing_Post_Office_Zip_Code__pc,
          Mailing_Province_Parish_State__pc,
          Mailing_Country__pc,
          Home_Number__c,
          Political_Exposure__pc
        FROM Account
        WHERE id IN :accid
      ];
      if (ApplicantPersonAccount.size() > 0) {
        for (Account a : ApplicantPersonAccount) {
          Account pa = new Account();
          Applicant__c applicant = new Applicant__c();
          List<FinServ__ContactContactRelation__c> EmerConlst = new List<FinServ__ContactContactRelation__c>();
          List<FinServ__Employment__c> emplst = new List<FinServ__Employment__c>();
          List<FinServ__ContactContactRelation__c> PoliEx = new List<FinServ__ContactContactRelation__c>();
          List<FinServ__ContactContactRelation__c> BankAff = new List<FinServ__ContactContactRelation__c>();
          pa = a;
          applicant = applicantMap.get(a.id);
          system.debug('Account id ==>' + a.id);
          if (AccidVsEmrConLst.containsKey(a.FinServ__PrimaryContact__c)) {
            EmerConlst = AccidVsEmrConLst.get(a.FinServ__PrimaryContact__c);
          }
          if (AccidVsEmpLst.containsKey(a.id)) {
            emplst = AccidVsEmpLst.get(a.id);
          }
          if (MapPoliExpo.containsKey(a.FinServ__PrimaryContact__c)) {
            PoliEx = MapPoliExpo.get(a.FinServ__PrimaryContact__c);
          }
          if (MapBankAff.containsKey(a.FinServ__PrimaryContact__c)) {
            BankAff = MapBankAff.get(a.FinServ__PrimaryContact__c);
          }

          system.debug('Person Account ==>' + pa);
          system.debug('EmerConlst ==>' + EmerConlst);
          system.debug('emplst ==>' + emplst);
          system.debug('PoliticalExp ==>' + PoliEx);
          system.debug('BankAff ==>' + BankAff);

          lst.add(
            new WrapperApplicationForm(
              Appcount,
              pa,
              applicant,
              EmerConlst,
              emplst,
              PoliEx,
              BankAff
            )
          );
          Appcount = Appcount + 1;
        }
      }
    }
    system.debug('Final Wrapper =======>' + lst);
  }
  private static void SetCalendarValues(List<FinServ__Employment__c> records) {
    Map<String, Integer> values;
    for (FinServ__Employment__c record : records) {
      if (record.Current_Employment__c) {
        values = Util.GetYearValues(record.FinServ__StartDate__c, Date.today());
        record.Time_Employed_with_Current_Employer__c = values.get('years');
        record.Time_Employed_in_Present_Employer_M__c = values.get('months');
      } else {
        record.Time_Employed_with_Current_Employer__c = 0;
        record.Time_Employed_in_Present_Employer_M__c = 0;
      }
    }
  }

  public void fillProductDetails(string oppid) {
    List<opportunity> opplst = [
      SELECT Product_Details__c
      FROM opportunity
      WHERE id = :oppid
    ];
    if (opplst.size() > 0) {
      if (string.isNotBlank(opplst[0].Product_Details__c)) {
        string loanid = opplst[0].Product_Details__c;
        system.debug('loanid=====' + loanid);
        ProductDetails = [
          SELECT
            id,
            Opportunity__r.Campaign.Name,
            Opportunity__r.Credit_Card_Phoenix_Account_Number__c,
            Opportunity__r.Line_of_Credit_Phoenix_Account_Number__c,
            Opportunity__r.Auto_Loan_Phoenix_Account_Number__c,
            Opportunity__r.Unsecured_Loan_Phoenix_Account_Number__c,
            Nick_Name_Of_Calculation__c,
            Will_card_used_by_authorized_cardholders__c,
            Lead_and_Referral__c,
            Opportunity__c,
            Monthly_Gross_Income__c,
            Existing_Monthly_Credit_Payment__c,
            Auto_Loan_Purpose__c,
            Market_Value_of_Vehicle__c,
            Motor_Vehicle_Deposit__c,
            Motor_Vehicle_Deposit_Percentage__c,
            Interested_in_programme__c,
            Include_first_year_premium_in_loan_amt__c,
            Monthly_Premium__c,
            Interested_in_Creditor_Life__c,
            Coverage_Type__c,
            Include_in_Loan_Amount_jnlife__c,
            Waive_Process_Fee__c,
            Include_in_Loan_Amount_Processing_Fee__c,
            Indicate_applicable_process_fee_percent__c,
            Include_a_moratorium_of_Loan_Payment__c,
            Moratorium_Indicate_Term__c,
            Proposed_Savings__c,
            Proposed_SavingsPercentage__c,
            Interest_Rate__c,
            Years__c,
            Months__c,
            Loan_Amount__c,
            Deduct_1st_moth_Payment_from_Loan__c,
            unsecure_Loan_Purpose__c,
            unsecure_Jn_Life_Creditor_Life_Insurance__c,
            Unsecure_Coverage_Type__c,
            Unsecure_Include_in_Loan_Amount__c,
            Unsecure_Waive_Processing_Fee__c,
            Unsecure_Indcate_applicable_process_fee__c,
            Unsecure_Loan_Savings_currency__c,
            Unsecure_Proposed_Savings__c,
            Unsecure_Proposed_Savings_percentage__c,
            Unsecure_Market_Per_Annum__c,
            Unsecure_Years__c,
            Unsecure_Months__c,
            PC_Credit_Limit__c,
            PC_Credit_Limit_Amount__c,
            Reqeusted_Limit__c,
            PC_Interest_Rate__c,
            Number_of_Supplementary_Applicant__c,
            PC_Collateral_Type__c,
            PC_Type_of_Cash_Secured_Collateral__c,
            PC_Deposit_Account_Balance__c,
            PC_Account_Hypothecated_for_another_Loan__c,
            PC_Total_existing_Loan_Balance__c,
            Proposed_Starting_Limit__c,
            PCL_Requested_Credit_Limit__c,
            PLC_Credit_Limit_Currency__c,
            PCL_Interest_Rate__c,
            PCL_Collateral_Type__c,
            PCL_Type_of_Cash_Secured_Collateral__c,
            PCL_Deposit_Account_Balance__c,
            PCL_Account_Hypothecated_another_Loan__c,
            PCL_Total_Existing_Loan_Balance__c,
            Purchase_Price_of_Vehicle__c,
            Processing_Fees_including_GCT__c,
            Total_Loan_Amount__c,
            Monthly_Loan_Savings__c,
            Monthly_loan_Payment_Monthly_Savings__c,
            Total_Loan_Savings_Balance__c,
            Total_Interest_Payment__c,
            Legal_Fees_Including_GCT__c,
            Stamp_Duty__c,
            Total_Auto_Loan_Fees_Charges__c,
            Indicate_Type__c,
            JN_Staff1_intereste_rate__c,
            JN_Staff1_loan_term__c,
            JN_Life_Creditor_Life_Premium__c,
            JN_life_Creditor_Life_Premium_moratorium__c,
            Monthly_JNGI_Motor_Premium_moratorium__c,
            Monthly_JNGI_Motor_Premium_1_12_Pay__c,
            Monthly_JN_Life_Creditor_Life_Premium__c,
            Monthly_Processing_Fees_moratorium__c,
            Monthly_Loan_Payment__c,
            Unsecured_Loan_Amount__c,
            Unsecure_Fee_Include_in_Loan_Amount__c,
            unsecure_Total_Loan_Amount__c,
            Unsecure_Monthly_Loan_Payment__c,
            unsecure_Monthly_Loan_Savings__c,
            unsecure_Total_Loan_Savings_Balance__c,
            unsecure_Total_Interest_Payment__c,
            unsecure_Legal_Fees_Including_GCT__c,
            Stamp_Duty_Security_Documents__c,
            Total_unsecured_Loan_Fee_Charges__c,
            JNGI_Motor_Premium_1st_Year__c,
            Staff1_Mthly_Loan_Payment_D_Moratorium__c,
            Staff1_Mthly_Loan_Payment_A_Moratorium__c,
            Staff2_Mthly_Loan_Payment_D_Moratorium__c,
            Staff2_Mthly_Loan_Payment_A_Moratorium__c,
            Staff3_Mthly_Loan_Payment_D_Moratorium__c,
            Staff3_Mthly_Loan_Payment_A_Moratorium__c,
            Desired_Monthly_Repayment_Date__c,
            Make_and_Model_of_Motor_Vehicle__c,
            Repayment_Method_Auto__c,
            Vehicle_Classification__c,
            Year_of_Motor_Vehicle__c,
            Desired_Monthly_Repayment_Date_UL__c,
            Repayment_Method_UL__c,
            interest_in_JN_Life_CC_Creditor_Life_iIn__c,
            Account_Number__c,
            Account_Holders__c,
            Account_Type__c,
            Annual_Interest_Rate_on_Deposit_Account__c,
            Financial_Institution__c,
            Financial_Institution_LOC__c,
            Account_Holders_LOC__c,
            Annual_Interest_Rate_on_Deposit_Acc_LOC__c,
            Desired_Monthly_Repayment_Date_LOC__c,
            Name_of_Valuer__c,
            Occupancy_Type__c,
            Property_Classification__c,
            Property_Title_Information_Folio__c,
            Property_Title_information_Vol__c,
            Forced_Sale_Value__c,
            Insurer__c,
            Is_a_Lien_on_Property__c,
            Is_Property_a_Strata__c,
            Replacement_Value__c,
            Security_Address__c,
            Market_Value_of_Property__c,
            unsecure_JN_Life_Creditor_Life_Premium__c,
            JN_Promotion_Auto__c,
            JN_Promotion_UL__c,
            JN_Promotion_CC__c,
            JN_Promotion_LOC__c,
            Desired_Statement_Date__c,
            Legal_Related_Activities__c,
            Date_of_Last_Valuation__c,
            JN_Promotion_Auto__r.name,
            JN_Promotion_UL__r.name,
            JN_Promotion_CC__r.name,
            JN_Promotion_LOC__r.name,
            //JN1-2788
            Interested_in_JNGI_SureCover_Programme__c,
            Deposit_Account_Number_LOC__c, //JN1-2791
            (
              SELECT
                Id,
                Loan_Amount_Number__c,
                Years_Number__c,
                Loan_Purpose_List__c,
                Interest_Rate_Number__c,
                Total_Monthly_Saving_Loan_Payment_Number__c,
                Monthly_Compulsory_Savings_Number__c,
                Applicable_Processing_Fee_Number__c,
                Processing_Fees_including_GCT_Number__c,
                Include_in_Loan_Amount_Processing_Flag__c,
                Interested_in_Creditor_Life_Flag__c,
                Include_in_Loan_Amount_Flag__c,
                JN_Life_Creditor_Life_Premium_Number__c,
                Coverage_Type_List__c,
                Total_Closing_Costs_Number__c,
                Repayment_Method_List__c,
                Desired_Monthly_Repayment_Date__c,
                Year_of_Motor_Vehicle_Number__c,
                Make_and_Model_of_Motor_Vehicle_text__c,
                Market_Value_of_Vehicle_Number__c,
                Purchase_Price_of_Vehicle_Number__c,
                Interested_in_JNGI_SureCover_flag__c,
                JNGI_Motor_Premium_1st_Year_during_Numbe__c,
                Include_in_Loan_Amount_JNGI_list__c,
                Vehicle_Classification_list__c,
                Months_Number__c,
                Collateral_Type_List__c,
                Desired_Statement_Date__c,
                Financial_Institution_List__c,
                Annual_Interest_Rate_Deposit_Acct_Number__c,
                Account_Holder_s_text__c,
                Deposit_Account_Balance_Number__c,
                Account_Hypothecated_list__c,
                Existing_Loan_Balance_Number__c,
                Requested_Credit_Limit_Number__c,
                Annual_Creditor_Life_Fee_Number__c,
                Annual_Membership_Primary_Number__c,
                Annual_Membership_Supplementary_Number__c
              FROM Loan_Calculation_Products__r
              ORDER BY CreatedDate DESC
            )
          FROM Loan_Calculator__c
          WHERE id = :loanid AND RecordType.Name = 'Product Details'
          ORDER BY createddate DESC
        ];
        if (ProductDetails.size() > 0) {
          isAutoFound = (ProductDetails[0].Auto_Loan_Purpose__c != null)
            ? true
            : false;
          isUnFound = (ProductDetails[0].unsecure_Loan_Purpose__c != null)
            ? true
            : false;
          isCcFound = (ProductDetails[0].PC_Credit_Limit_Amount__c != null)
            ? true
            : false;
          isLocFound = (ProductDetails[0].PCL_Requested_Credit_Limit__c != null)
            ? true
            : false;
        }
        system.debug('ProductDetails=====' + ProductDetails);
      }
    }
  }

  /* public void callfuturemethod(){
        string OppId;
        if(ApexPages.currentPAge().getParameters().get('oppid')!=null){
            OppId = ApexPages.currentPAge().getParameters().get('oppid');
            // ApplicationForm1();
            
            creatingPdfBlob();
            //PageReference mypage = Page.ApplicationForm;
              //mypage.getParameters().put('oppid', OppId);
            
            //blob body = blob.toPDF(str);// mypage.getContentAsPDF(); //
            //system.debug('Myblob 1====>'+body); 
            saveAttachement(oppid);
            
        } 
    }*/
  //@Future(callout=true)
  public static void saveAttachement(string oppid) {
    PageReference mypage = Page.ApplicationForm;
    mypage.getParameters().put('oppid', oppid);
    blob body = mypage.getContentAsPDF();
    //id PageOppId;
    //  if(ApexPages.currentPAge().getParameters().get('oppid')!=null){
    // PageOppId = ApexPages.currentPAge().getParameters().get('oppid');
    //ApplicationForm1();
    system.debug('attach====' + OppId);
    //PageReference pdf = Page.ApplicationForm;
    Attachment attach = new Attachment();
    //Blob body;
    //body = pdf.getContentAsPDF();
    attach.Body = body;
    attach.ContentType = 'application/pdf';

    attach.Name = 'ApplicationForm.pdf';
    attach.IsPrivate = false;
    attach.ParentId = oppid;
    insert attach;
    system.debug('attach====' + attach);
    //}
  }

  public string str = '';
  public void creatingPdfBlob() {
    str += '<div class="footer">';
    str +=
      '<div style="text-align:left;font-size:15px;">' +
      Label.ApplicationFormText +
      '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
    str += '<span class="pagenumber"/> of <span class="pagecount"/>   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Applicant Initial:';
    str += ' </div>';
    str += '<div style="text-align:right;">_____________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>';
    str += ' </div>';
    str += '';
  }
}
