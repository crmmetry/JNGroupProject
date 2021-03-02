@isTest
public class ApplicationForm_Test {
  @isTest
  public static void testPdf() {
    List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
    List<Account> accList = TestDataFactory.CreateBasicAccounts(1, 'Test');
    accList[0].Years_at_Residence__pc = 4;
    accList[0]
      .Highest_Level_of_Education_attained__pc = 'University: Post Graduate';
    accList[0].PersonBirthdate = date.newInstance(
      System.Today().year() - 36,
      2,
      11
    );
    insert accList;

    Util.ExecutionCount = 2;
    Map<String, Id> recordTypeMap2 = Util.getRecordTypeids(
      'Loan_Calculator__c'
    );
    List<Loan_Calculator__c> loanCalcList = TestDataFactory.CreateLoanCalculation(
      1
    );
    loanCalcList[0].RecordTypeId = recordTypeMap2.get('Product_Details');
    loanCalcList[0].Auto_Loan_Purpose__c = 'Purchase a Motor Vehicle';
    loanCalcList[0].unsecure_Loan_Purpose__c = 'Asset Acquisition';
    loanCalcList[0].PC_Credit_Limit_Amount__c = 2000.00;
    loanCalcList[0].PCL_Requested_Credit_Limit__c = 300.00;
    insert loanCalcList;

    List<Loan_Calculation_Product__c> loanCalcProductList = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalcProductList[0].Loan_Calculation_Id__c = loanCalcList[0].Id;
    loanCalcProductList[0].Loan_Amount_Number__c = 20000.00;
    loanCalcProductList[0].Years_Number__c = 2;
    loanCalcProductList[0].Loan_Purpose_List__c = 'Purchase a Motor Vehicle';
    loanCalcProductList[0].Interest_Rate_Number__c = 3;
    loanCalcProductList[0]
      .Total_Monthly_Saving_Loan_Payment_Number__c = 20000.00;
    loanCalcProductList[0].Monthly_Compulsory_Savings_Number__c = 2000.00;
    loanCalcProductList[0].Applicable_Processing_Fee_Number__c = 3000.00;
    loanCalcProductList[0].Processing_Fees_including_GCT_Number__c = 3000.00;
    loanCalcProductList[0]
      .Include_in_Loan_Amount_Processing_Flag__c = 'No, Paid by Applicant';
    loanCalcProductList[0].Interested_in_Creditor_Life_Flag__c = 'Yes';
    loanCalcProductList[0]
      .Include_in_Loan_Amount_Flag__c = 'No, Paid by Applicant';
    loanCalcProductList[0].JN_Life_Creditor_Life_Premium_Number__c = 3000.00;
    loanCalcProductList[0].Coverage_Type_List__c = 'Applicant 1 Only';
    loanCalcProductList[0].Total_Closing_Costs_Number__c = 3000.00;
    loanCalcProductList[0].Repayment_Method_List__c = 'Salary Deduction';
    loanCalcProductList[0].Desired_Monthly_Repayment_Date__c = '12';
    loanCalcProductList[0].Year_of_Motor_Vehicle_Number__c = 2019;
    loanCalcProductList[0].Make_and_Model_of_Motor_Vehicle_text__c = 'test 222';
    loanCalcProductList[0].Market_Value_of_Vehicle_Number__c = 20000.00;
    loanCalcProductList[0].Purchase_Price_of_Vehicle_Number__c = 20000.00;
    loanCalcProductList[0].Interested_in_JNGI_SureCover_flag__c = 'Yes';
    loanCalcProductList[0].JNGI_Motor_Premium_1st_Year_during_Numbe__c = 2000;
    loanCalcProductList[0]
      .Include_in_Loan_Amount_JNGI_list__c = 'No, Paid by Applicant';
    loanCalcProductList[0].Vehicle_Classification_list__c = 'New';
    loanCalcProductList[0].Months_Number__c = 7;
    loanCalcProductList[0].Collateral_Type_List__c = 'Cash/Investments';
    loanCalcProductList[0].Desired_Statement_Date__c = date.newInstance(
      System.Today().year(),
      2,
      11
    );
    loanCalcProductList[0].Financial_Institution_List__c = 'JN Bank Ltd.';
    loanCalcProductList[0].Annual_Interest_Rate_Deposit_Acct_Number__c = 2;
    loanCalcProductList[0].Account_Holder_s_text__c = 'test';
    loanCalcProductList[0].Deposit_Account_Balance_Number__c = 2000.00;
    loanCalcProductList[0].Account_Hypothecated_list__c = 'Yes';
    loanCalcProductList[0].Existing_Loan_Balance_Number__c = 2000.00;
    loanCalcProductList[0].Requested_Credit_Limit_Number__c = 2000.00;
    loanCalcProductList[0].Annual_Creditor_Life_Fee_Number__c = 2000.00;
    loanCalcProductList[0].Annual_Membership_Primary_Number__c = 2000.00;
    loanCalcProductList[0].Annual_Membership_Supplementary_Number__c = 2000.00;
    insert loanCalcProductList;

    opList[0].accountId = accList[0].id;
    opList[0].Collateral_CC__c = 'Cash';
    opList[0].Collateral_LOC__c = 'Cash';
    opList[0].Loan_to_ValueCC__c = 1;
    opList[0].StageName = 'Customer Interview';
    opList[0].CloseDate = Date.today().addDays(6);
    opList[0].Product_Details__c = loanCalcList[0].Id;
    insert opList[0];

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Auto Loan' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'iPhone X - ' + family)
      );
    }
    //Insert products with families
    insert products;

    //Instantiate the Pricebook2 record with StandardPricebookId
    Pricebook2 standardPricebook = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );

    //Execute an update DML on the Pricebook2 recordapplicant.to make IsStandard to true
    update standardPricebook;

    //Query for the Pricebook2 recordapplicant.to check IsStandard field
    standardPricebook = [
      SELECT Id, IsStandard
      FROM Pricebook2
      WHERE Id = :standardPricebook.Id
    ];
    //It should return true
    System.assertEquals(true, standardPricebook.IsStandard);

    List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
    for (Product2 record : products) {
      priceBookEntries.add(
        TestDataFactory.CreatePriceBookEntry(standardPricebook.Id, record.Id)
      );
    }
    //Insert Price Book Entries
    insert priceBookEntries;

    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    for (PricebookEntry record : priceBookEntries) {
      lineItems.add(
        TestDataFactory.CreateOpportunityLineItem(opList[0].id, record.Id)
      );
    }
    // Insert Opportunity Line Items
    insert lineItems;

    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accList[0].id,
      'Employeement Test'
    );
    employee.Current_Employment__c = true;
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Employment_Status__c = 'Contractual';
    employee.Industry__c = 'Financial Services';
    employee.Professional_Category__c = 'Professional';
    employee.Assessment_of_Business_Working_Capita__c = 'Good';
    employee.Nature_of_Engagement__c = 'Professional service provider';
    employee.Assessment_of_Business__c = Constants.THREE_TO_FOUR_YEARS_AND_OR;
    employee.Assessment_of_Statement__c = '	Strongly Supported';
    employee.Length_of_Trade__c = 'More than 5 years';
    Map<String, Id> recordTypeMap = Util.getRecordTypeids(
      'FinServ__Employment__c'
    );
    employee.RecordTypeId = recordTypeMap.get('Employed');
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accList[0].id,
      opList[0].id
    );
    applicant.Salary_and_Allowances_as_per_pay_slips__c = 2000.00;
    applicant.Gratuity_in_lieu_of_Pension__c = 2000.00;
    applicant.Net_Profit_Sole_Trader__c = 2000.00;
    applicant.Director_s_Emoluments_Director__c = 2000.00;
    applicant.Share_of_Profit_Partnership__c = 2000.00;
    applicant.Share_of_Profit_Shareholder__c = 2000.00;
    applicant.Pension__c = 2000.00;
    applicant.Existing_Real_Estate_Rental_I__c = 2000.00;
    applicant.Existing_Real_estate_Rental_II__c = 2000.00;
    applicant.Other_Income__c = 2000.00;
    applicant.Income_Tax_Monthly_Payment_Prior_Loan__c = 2000.00;
    applicant.NIS_Contribution_Monthly_Prior_Loan__c = 2000.00;
    applicant.NHT_Contributions_Monthly_Prior_Loan__c = 2000.00;
    applicant.Education_Tax_Monthly_Prior_Loan__c = 2000.00;
    applicant.Rent_Board_Monthly_Prior_Loan__c = 2000.00;
    applicant.Strata_Maintenance_Monthly_Prior_Loan__c = 2000.00;
    applicant.Property_Tax_Monthly_Prior_Loan__c = 2000.00;
    applicant.Property_Insurance_Monthly_Prior_Loan__c = 2000.00;
    applicant.Property_Maintenance_Monthly_Prior_loan__c = 2000.00;
    applicant.Personal_Expenses_Monthly_Prior_Loan__c = 2000.00;
    applicant.Food_Cost_Monthly_Prior_Loan__c = 2000.00;
    applicant.Child_Care_Costs_Monthly_Prior_Loan__c = 2000.00;
    applicant.School_Costs_Monthly_Prior_Loan__c = 2000.00;
    applicant.Health_Costs_Monthly_Prior_Loan__c = 2000.00;
    applicant.Electricity_Monthly_Prior_Loan__c = 2000.00;
    applicant.Cell_Phone_Landline_Monthly_Prior_Loan__c = 2000.00;
    applicant.Water_Monthly_Prior_Loan__c = 2000.00;
    applicant.Internet_Cable_Monthly_Prior_Loan__c = 2000.00;
    applicant.Cooking_Gas_Monthly_Prior_Loan__c = 2000.00;
    applicant.House_Keeping_Monthly_Prior_Loan__c = 2000.00;
    applicant.Other_Utilities_Monthly_Prior_Loan__c = 2000.00;
    applicant.Fares_Monthly_Prior_Loan__c = 2000.00;
    applicant.Petrol_Fuel_Monthly_Prior_Loan__c = 2000.00;
    applicant.Toll_Fees_Monthly_Prior_Loan__c = 2000.00;
    applicant.Motor_V_Insurance_Monthly_Prior_Loan__c = 2000.00;
    applicant.Motor_Vehicle_Reg_Monthly_Prior_Loan__c = 2000.00;
    applicant.Motor_V_Maintenance_Monthly_Before_Loan__c = 2000.00;
    applicant.Other_Transport_Costs_Monthly_Prior_Loan__c = 2000.00;
    applicant.Ownership_Real_Estate_Rental__c = 2;
    applicant.Ownership_Real_Estate_Rental_II__c = 2;
    applicant.Rent_Board_Monthly_After_Loan__c = 2000.00;
    applicant.Strata_Maintenance_Monthly_After_Loan__c = 2000.00;
    applicant.Property_Tax_Monthly_After_Loan__c = 2000.00;
    applicant.Property_Insurance_Monthly_After_Loan__c = 2000.00;
    applicant.Property_Maintenance_Monthly_After_Loan__c = 2000.00;
    applicant.Food_Costs_Monthly_After_Loan__c = 2000.00;
    applicant.Personal_Expenses_Monthly_After_Loan__c = 2000.00;
    applicant.Child_Care_Costs_Monthly_After_Loan__c = 2000.00;
    applicant.School_Costs_Monthly_After_Loan__c = 2000.00;
    applicant.Health_Costs_Monthly_After_Loan__c = 2000.00;
    applicant.Other_Personal_Family_Costs_Prior_After__c = 2000.00;
    applicant.Electricity_Monthly_After_Loan__c = 2000.00;
    applicant.Cell_Phone_Landline_Monthly_After_Loan__c = 2000.00;
    applicant.Water_Monthly_After_Loan__c = 2000.00;
    applicant.Internet_Cable_Monthly_After_Loan__c = 2000.00;
    applicant.Cooking_Gas_Monthly_After_Loan__c = 2000.00;
    applicant.House_Keeping_Costs_Monthly_After_Loan__c = 2000.00;
    applicant.Other_Utilities_Monthly_After_Loan__c = 2000.00;
    applicant.Fares_Monthly_After_Loan__c = 2000.00;
    applicant.Petrol_Fuel_Monthly_After_Loan__c = 2000.00;
    applicant.Toll_Fees_Monthly_After_Loan__c = 2000.00;
    applicant.Motor_V_Insurance_Monthly_After_Loan__c = 2000.00;
    applicant.Motor_Vehicle_Reg_Monthly_After_Loan__c = 2000.00;
    applicant.Motor_V_Maintenance_Monthly_After_Loan__c = 2000.00;
    applicant.Other_Transport_Monthly_After_Loan__c = 2000.00;
    insert applicant;

    Map<String, Id> recordTypeMap1 = Util.getRecordTypeids(
      'FinServ__AssetsAndLiabilities__c'
    );
    List<FinServ__AssetsAndLiabilities__c> assetsList = new List<FinServ__AssetsAndLiabilities__c>();
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Real_Estate'),
      'Real Estate'
    );
    assetsAndLiabilities.Address__c = 'Test address';
    assetsAndLiabilities.Percent_Ownership__c = 1;
    assetsAndLiabilities.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities.Property_Type__c = 'Residential';
    assetsAndLiabilities.Lien_on_Asset__c = true;
    assetsAndLiabilities.Lender__c = 'Sample Lender';
    assetsAndLiabilities.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities.Monthly_Payment__c = 200.00;
    assetsAndLiabilities.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities.Type_of_Account__c = 'Savings';
    assetsAndLiabilities.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities.Policy_Number__c = 1234567890;
    assetsAndLiabilities.Cash_Value__c = 2000.00;
    assetsAndLiabilities.Sum_Insured__c = 2000.00;
    assetsAndLiabilities.Annual_Premium__c = 2000.00;
    assetsAndLiabilities.Pension_Scheme__c = 'test';
    assetsAndLiabilities.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities.Treatment_of_Credit__c = 'Will Remain';
    assetsList.add(assetsAndLiabilities);

    FinServ__AssetsAndLiabilities__c assetsAndLiabilities1 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Motor_Vehicle'),
      'Motor_Vehicle'
    );
    assetsAndLiabilities1.Address__c = 'Test address';
    assetsAndLiabilities1.Percent_Ownership__c = 1;
    assetsAndLiabilities1.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities1.Property_Type__c = 'Residential';
    assetsAndLiabilities1.Lien_on_Asset__c = true;
    assetsAndLiabilities1.Lender__c = 'Sample Lender';
    assetsAndLiabilities1.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities1.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities1.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities1.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities1.Monthly_Payment__c = 200.00;
    assetsAndLiabilities1.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities1.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities1.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities1.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities1.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities1.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities1.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities1.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities1.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities1.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities1.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities1.Type_of_Account__c = 'Savings';
    assetsAndLiabilities1.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities1.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities1.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities1.Policy_Number__c = 1234567890;
    assetsAndLiabilities1.Cash_Value__c = 2000.00;
    assetsAndLiabilities1.Sum_Insured__c = 2000.00;
    assetsAndLiabilities1.Annual_Premium__c = 2000.00;
    assetsAndLiabilities1.Pension_Scheme__c = 'test';
    assetsAndLiabilities1.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities1.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities1.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities1.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities1.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities1);

    FinServ__AssetsAndLiabilities__c assetsAndLiabilities2 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Other_Assets'),
      'Other_Assets'
    );
    assetsAndLiabilities2.Address__c = 'Test address';
    assetsAndLiabilities2.Percent_Ownership__c = 1;
    assetsAndLiabilities2.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities2.Property_Type__c = 'Residential';
    assetsAndLiabilities2.Lien_on_Asset__c = true;
    assetsAndLiabilities2.Lender__c = 'Sample Lender';
    assetsAndLiabilities2.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities2.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities2.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities2.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities2.Monthly_Payment__c = 200.00;
    assetsAndLiabilities2.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities2.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities2.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities2.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities2.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities2.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities2.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities2.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities2.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities2.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities2.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities2.Type_of_Account__c = 'Savings';
    assetsAndLiabilities2.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities2.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities2.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities2.Policy_Number__c = 1234567890;
    assetsAndLiabilities2.Cash_Value__c = 2000.00;
    assetsAndLiabilities2.Sum_Insured__c = 2000.00;
    assetsAndLiabilities2.Annual_Premium__c = 2000.00;
    assetsAndLiabilities2.Pension_Scheme__c = 'test';
    assetsAndLiabilities2.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities2.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities2.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities2.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities2.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities2);
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities3 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Other_Loans'),
      'Other_Loans'
    );
    assetsAndLiabilities3.Address__c = 'Test address';
    assetsAndLiabilities3.Percent_Ownership__c = 1;
    assetsAndLiabilities3.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities3.Property_Type__c = 'Residential';
    assetsAndLiabilities3.Lien_on_Asset__c = true;
    assetsAndLiabilities3.Lender__c = 'Sample Lender';
    assetsAndLiabilities3.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities3.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities3.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities3.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities3.Monthly_Payment__c = 200.00;
    assetsAndLiabilities3.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities3.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities3.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities3.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities3.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities3.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities3.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities3.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities3.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities3.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities3.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities3.Type_of_Account__c = 'Savings';
    assetsAndLiabilities3.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities3.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities3.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities3.Policy_Number__c = 1234567890;
    assetsAndLiabilities3.Cash_Value__c = 2000.00;
    assetsAndLiabilities3.Sum_Insured__c = 2000.00;
    assetsAndLiabilities3.Annual_Premium__c = 2000.00;
    assetsAndLiabilities3.Pension_Scheme__c = 'test';
    assetsAndLiabilities3.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities3.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities3.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities3.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities3.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities3);
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities4 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Credit_Cards'),
      'Credit_Cards'
    );
    assetsAndLiabilities4.Address__c = 'Test address';
    assetsAndLiabilities4.Percent_Ownership__c = 1;
    assetsAndLiabilities4.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities4.Property_Type__c = 'Residential';
    assetsAndLiabilities4.Lien_on_Asset__c = true;
    assetsAndLiabilities4.Lender__c = 'Sample Lender';
    assetsAndLiabilities4.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities4.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities4.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities4.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities4.Monthly_Payment__c = 200.00;
    assetsAndLiabilities4.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities4.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities4.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities4.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities4.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities4.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities4.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities4.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities4.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities4.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities4.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities4.Type_of_Account__c = 'Savings';
    assetsAndLiabilities4.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities4.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities4.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities4.Policy_Number__c = 1234567890;
    assetsAndLiabilities4.Cash_Value__c = 2000.00;
    assetsAndLiabilities4.Sum_Insured__c = 2000.00;
    assetsAndLiabilities4.Annual_Premium__c = 2000.00;
    assetsAndLiabilities4.Pension_Scheme__c = 'test';
    assetsAndLiabilities4.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities4.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities4.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities4.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities4.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities4);
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities5 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Lines_of_Credit'),
      'Lines_of_Credit'
    );
    assetsAndLiabilities5.Address__c = 'Test address';
    assetsAndLiabilities5.Percent_Ownership__c = 1;
    assetsAndLiabilities5.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities5.Property_Type__c = 'Residential';
    assetsAndLiabilities5.Lien_on_Asset__c = true;
    assetsAndLiabilities5.Lender__c = 'Sample Lender';
    assetsAndLiabilities5.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities5.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities5.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities5.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities5.Monthly_Payment__c = 200.00;
    assetsAndLiabilities5.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities5.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities5.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities5.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities5.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities5.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities5.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities5.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities5.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities5.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities5.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities5.Type_of_Account__c = 'Savings';
    assetsAndLiabilities5.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities5.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities5.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities5.Policy_Number__c = 1234567890;
    assetsAndLiabilities5.Cash_Value__c = 2000.00;
    assetsAndLiabilities5.Sum_Insured__c = 2000.00;
    assetsAndLiabilities5.Annual_Premium__c = 2000.00;
    assetsAndLiabilities5.Pension_Scheme__c = 'test';
    assetsAndLiabilities5.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities5.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities5.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities5.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities5.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities5);
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities6 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Savings_Current_Accounts_Investments'),
      'Savings_Current_Accounts_Investments'
    );
    assetsAndLiabilities6.Address__c = 'Test address';
    assetsAndLiabilities6.Percent_Ownership__c = 1;
    assetsAndLiabilities6.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities6.Property_Type__c = 'Residential';
    assetsAndLiabilities6.Lien_on_Asset__c = true;
    assetsAndLiabilities6.Lender__c = 'Sample Lender';
    assetsAndLiabilities6.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities6.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities6.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities6.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities6.Monthly_Payment__c = 200.00;
    assetsAndLiabilities6.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities6.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities6.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities6.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities6.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities6.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities6.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities6.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities6.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities6.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities6.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities6.Type_of_Account__c = 'Savings';
    assetsAndLiabilities6.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities6.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities6.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities6.Policy_Number__c = 1234567890;
    assetsAndLiabilities6.Cash_Value__c = 2000.00;
    assetsAndLiabilities6.Sum_Insured__c = 2000.00;
    assetsAndLiabilities6.Annual_Premium__c = 2000.00;
    assetsAndLiabilities6.Pension_Scheme__c = 'test';
    assetsAndLiabilities6.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities6.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities6.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities6.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities6.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities6);
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities7 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Life_Insurance_Policies'),
      'Life_Insurance_Policies'
    );
    assetsAndLiabilities7.Address__c = 'Test address';
    assetsAndLiabilities7.Percent_Ownership__c = 1;
    assetsAndLiabilities7.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities7.Property_Type__c = 'Residential';
    assetsAndLiabilities7.Lien_on_Asset__c = true;
    assetsAndLiabilities7.Lender__c = 'Sample Lender';
    assetsAndLiabilities7.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities7.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities7.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities7.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities7.Monthly_Payment__c = 200.00;
    assetsAndLiabilities7.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities7.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities7.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities7.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities7.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities7.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities7.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities7.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities7.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities7.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities7.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities7.Type_of_Account__c = 'Savings';
    assetsAndLiabilities7.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities7.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities7.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities7.Policy_Number__c = 1234567890;
    assetsAndLiabilities7.Cash_Value__c = 2000.00;
    assetsAndLiabilities7.Sum_Insured__c = 2000.00;
    assetsAndLiabilities7.Annual_Premium__c = 2000.00;
    assetsAndLiabilities7.Pension_Scheme__c = 'test';
    assetsAndLiabilities7.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities7.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities7.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities7.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities7.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities7);
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities8 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Pension_Contributions_or_Individual'),
      'Pension_Contributions_or_Individual'
    );
    assetsAndLiabilities8.Address__c = 'Test address';
    assetsAndLiabilities8.Percent_Ownership__c = 1;
    assetsAndLiabilities8.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities8.Property_Type__c = 'Residential';
    assetsAndLiabilities8.Lien_on_Asset__c = true;
    assetsAndLiabilities8.Lender__c = 'Sample Lender';
    assetsAndLiabilities8.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities8.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities8.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities8.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities8.Monthly_Payment__c = 200.00;
    assetsAndLiabilities8.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities8.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities8.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities8.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities8.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities8.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities8.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities8.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities8.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities8.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities8.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities8.Type_of_Account__c = 'Savings';
    assetsAndLiabilities8.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities8.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities8.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities8.Policy_Number__c = 1234567890;
    assetsAndLiabilities8.Cash_Value__c = 2000.00;
    assetsAndLiabilities8.Sum_Insured__c = 2000.00;
    assetsAndLiabilities8.Annual_Premium__c = 2000.00;
    assetsAndLiabilities8.Pension_Scheme__c = 'test';
    assetsAndLiabilities8.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities8.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities8.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities8.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities8.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities8);
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities9 = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('Other_Loans_Guaranteed'),
      'Other_Loans_Guaranteed'
    );
    assetsAndLiabilities9.Address__c = 'Test address';
    assetsAndLiabilities9.Percent_Ownership__c = 1;
    assetsAndLiabilities9.Total_Market_Value__c = 10000.00;
    assetsAndLiabilities9.Property_Type__c = 'Residential';
    assetsAndLiabilities9.Lien_on_Asset__c = true;
    assetsAndLiabilities9.Lender__c = 'Sample Lender';
    assetsAndLiabilities9.Loan_Balance_Prior__c = 200.00;
    assetsAndLiabilities9.Percent_Applicant_Portion__c = 2;
    assetsAndLiabilities9.Monthly_Payment_Prior__c = 200.00;
    assetsAndLiabilities9.Loan_Repaid_from_Facility__c = false;
    assetsAndLiabilities9.Monthly_Payment__c = 200.00;
    assetsAndLiabilities9.Loan_Balance_After__c = 200.00;
    assetsAndLiabilities9.Vehicle_Details__c = 'Vehical details';
    assetsAndLiabilities9.Description_of_Asset__c = 'Sample Descrition';
    assetsAndLiabilities9.Financial_Institution__c = 'Sample Finance';
    assetsAndLiabilities9.Type_of_Card__c = 'Unsecured';
    assetsAndLiabilities9.Asset_Credit_Limit__c = 2000.00;
    assetsAndLiabilities9.Average_Monthly_Usage__c = 2000.00;
    assetsAndLiabilities9.Asset_Credit_Balance__c = 2000.00;
    assetsAndLiabilities9.Minimum_Payment__c = 2000.00;
    assetsAndLiabilities9.Asset_Credit_Balance_After__c = 2000.00;
    assetsAndLiabilities9.Minimum_Payment_After__c = 2000.00;
    assetsAndLiabilities9.Type_of_Account__c = 'Savings';
    assetsAndLiabilities9.Overdraft_Limit__c = 2000.00;
    assetsAndLiabilities9.Monthly_Savings_Investment__c = 2000.00;
    assetsAndLiabilities9.Monthly_Saving_Investment_after_Loan__c = 2000.00;
    assetsAndLiabilities9.Policy_Number__c = 1234567890;
    assetsAndLiabilities9.Cash_Value__c = 2000.00;
    assetsAndLiabilities9.Sum_Insured__c = 2000.00;
    assetsAndLiabilities9.Annual_Premium__c = 2000.00;
    assetsAndLiabilities9.Pension_Scheme__c = 'test';
    assetsAndLiabilities9.Total_Contributions_to_Date__c = 2000.00;
    assetsAndLiabilities9.Monthly_Contribution_Before_Loan__c = 2000.00;
    assetsAndLiabilities9.Monthly_Contribution_After_Loan__c = 2000.00;
    assetsAndLiabilities9.Type_of_Loan__c = 'Unsecured';
    assetsAndLiabilities9.Treatment_of_Credit__c = 'Close facility';
    assetsList.add(assetsAndLiabilities9);

    if (assetsList.size() > 0) {
      insert assetsList;
    }

    List<Application_Asset_Liability__c> appliAssetList = new List<Application_Asset_Liability__c>();
    for (FinServ__AssetsAndLiabilities__c asset : assetsList) {
      Application_Asset_Liability__c applicantAssetsAndLiabilities = TestDataFactory.CreateApplicantAssetsAndLiabilities(
        applicant.Id,
        asset.Id
      );
      appliAssetList.add(applicantAssetsAndLiabilities);
    }

    if (appliAssetList.size() > 0) {
      insert appliAssetList;
    }
    List<FinServ__ReciprocalRole__c> roles = new List<FinServ__ReciprocalRole__c>();
    List<String> roleNames = new List<String>{
      'Emergency Contact',
      'Political Affiliation',
      'JN Affiliation'
    };
    for (String roleName : roleNames) {
      roles.add(TestDataFactory.CreateRole(roleName));
    }
    insert roles;

    List<FinServ__ContactContactRelation__c> conToCons = new List<FinServ__ContactContactRelation__c>();
    Map<String, FinServ__ReciprocalRole__c> mappedRoles = Util.getRoleRelationships(
      'ContactRole'
    ); //get contact roles
    Id roleId = mappedRoles.get('Emergency Contact').Id;
    Id roleId2 = mappedRoles.get('Political Affiliation').Id;
    Id roleId3 = mappedRoles.get('JN Affiliation').Id;
    Contact con = TestDataFactory.CreateBasicContacts(1, 'testlastname')[0];
    insert con;
    Contact con1 = TestDataFactory.CreateBasicContacts(1, 'Abc Test')[0];
    insert con1;

    Test.startTest();

    List<Account> accounts = [
      SELECT Id, PersonContactId
      FROM Account
      WHERE LastName LIKE 'Test%'
    ];

    FinServ__ContactContactRelation__c record = new FinServ__ContactContactRelation__c();
    record.FinServ__Role__c = roleId;
    record.FinServ__Contact__c = con.Id;
    record.FinServ__RelatedContact__c = accounts[0].PersonContactId;
    insert record;

    FinServ__ContactContactRelation__c record4 = new FinServ__ContactContactRelation__c();
    record4.FinServ__Role__c = roleId;
    record4.FinServ__Contact__c = con1.Id;
    record4.FinServ__RelatedContact__c = accounts[0].PersonContactId;
    insert record4;

    FinServ__ContactContactRelation__c record1 = new FinServ__ContactContactRelation__c();
    record1.FinServ__Role__c = roleId2;
    record1.FinServ__Contact__c = con.Id;
    record1.FinServ__RelatedContact__c = accounts[0].PersonContactId;
    insert record1;

    FinServ__ContactContactRelation__c record2 = new FinServ__ContactContactRelation__c();
    record2.FinServ__Role__c = roleId3;
    record2.FinServ__Contact__c = con.Id;
    record2.FinServ__RelatedContact__c = accounts[0].PersonContactId;
    insert record2;

    pageReference pageRef = page.ApplicationForm_SOA;
    pageRef.getParameters().put('oppid', String.valueOf(opList[0].Id));
    Test.setCurrentPage(pageRef);
    ApplicationForm applicationForm1 = new ApplicationForm();
    applicationForm1.ApplicationForm1();
    ApplicationForm.saveAttachement(opList[0].Id);
    applicationForm1.creatingPdfBlob();
    Test.StopTest();
  }
}
