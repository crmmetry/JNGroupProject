public class PDFGeneratorController {
  public String PDFData { get; set; }
  public String recordId { get; set; }
  public Opportunity thisOpportunity { get; set; }
  public Integer assetsSize { get; set; }
  public List<FinServ__AssetsAndLiabilities__c> assets { get; set; }
  public Application_Asset_Liability__c[] applicantAssetLiabilities {
    get;
    set;
  }
  Map<String, Decimal> recordTypeAccumPior = new Map<String, Decimal>(); //for record types
  Map<String, Decimal> recordTypeAccumAfter = new Map<String, Decimal>(); //for record types
  public Applicant__c applicant { get; set; }
  public Decimal realEstateBefore {
    get {
      if (realEstateBefore == null)
        return 0.0;
      else
        return realEstateBefore;
    }
    set;
  }
  public Decimal realEstateAfter {
    get {
      if (realEstateAfter == null)
        return 0.0;
      else
        return realEstateAfter;
    }
    set;
  }

  public Decimal realEstateSumBoth {
    get {
      if (realEstateSumBoth == null)
        return 0.0;
      else
        return realEstateSumBoth;
    }
    set;
  }
  public Decimal motorVehicleAfter {
    get {
      if (motorVehicleAfter == null)
        return 0.0;
      else
        return motorVehicleAfter;
    }
    set;
  }
  public Decimal motorVehicleBefore {
    get {
      if (motorVehicleBefore == null)
        return 0.0;
      else
        return motorVehicleBefore;
    }
    set;
  }
  public Decimal otherAssetBefore {
    get {
      if (otherAssetBefore == null)
        return 0.0;
      else
        return otherAssetBefore;
    }
    set;
  }
  public Decimal otherAssetAfter {
    get {
      if (otherAssetAfter == null)
        return 0.0;
      else
        return otherAssetAfter;
    }
    set;
  }
  public Decimal lifeInsuranceBefore {
    get {
      if (lifeInsuranceBefore == null)
        return 0.0;
      else
        return lifeInsuranceBefore;
    }
    set;
  }
  public Decimal lifeInsuranceAfter {
    get {
      if (lifeInsuranceAfter == null)
        return 0.0;
      else
        return lifeInsuranceAfter;
    }
    set;
  }

  public Decimal savingsBefore {
    get {
      if (savingsBefore == null)
        return 0.0;
      else
        return savingsBefore;
    }
    set;
  }
  public Decimal savingsAfter {
    get {
      if (savingsAfter == null)
        return 0.0;
      else
        return savingsAfter;
    }
    set;
  }
  public Decimal pensionBefore {
    get {
      if (pensionBefore == null)
        return 0.0;
      else
        return pensionBefore;
    }
    set;
  }
  public Decimal pensionAfter {
    get {
      if (pensionAfter == null)
        return 0.0;
      else
        return pensionAfter;
    }
    set;
  }

  public Decimal loanRealEstateBefore {
    get {
      if (loanRealEstateBefore == null)
        return 0.0;
      else
        return loanRealEstateBefore;
    }
    set;
  }
  public Decimal loanMotorVehicleAfter {
    get {
      if (loanMotorVehicleAfter == null)
        return 0.0;
      else
        return loanMotorVehicleAfter;
    }
    set;
  }
  public Decimal loanMotorVehicleBefore {
    get {
      if (loanMotorVehicleBefore == null)
        return 0.0;
      else
        return loanMotorVehicleBefore;
    }
    set;
  }
  public Decimal loanOtherAssetAfter {
    get {
      if (loanOtherAssetAfter == null)
        return 0.0;
      else
        return loanOtherAssetAfter;
    }
    set;
  }
  public Decimal loanOtherAssetBefore {
    get {
      if (loanOtherAssetBefore == null)
        return 0.0;
      else
        return loanOtherAssetBefore;
    }
    set;
  }
  public Decimal otherLoansBefore {
    get {
      if (otherLoansBefore == null)
        return 0.0;
      else
        return otherLoansBefore;
    }
    set;
  }
  public Decimal loanCreditCardBefore {
    get {
      if (loanCreditCardBefore == null)
        return 0.0;
      else
        return loanCreditCardBefore;
    }
    set;
  }
  public Decimal loanCurrentAccountOverdraftBefore {
    get {
      if (loanCurrentAccountOverdraftBefore == null)
        return 0.0;
      else
        return loanCurrentAccountOverdraftBefore;
    }
    set;
  }

  public Decimal netWorthPrior {
    get {
      if (netWorthPrior == null)
        return 0.0;
      else
        return netWorthPrior;
    }
    set;
  }
  public Decimal netWorthAfter {
    get {
      if (netWorthAfter == null)
        return 0.0;
      else
        return netWorthAfter;
    }
    set;
  }
  public Decimal totalAssetsPrior {
    get {
      if (totalAssetsPrior == null)
        return 0.0;
      else
        return totalAssetsPrior;
    }
    set;
  }
  public Decimal totalAssetsAfter {
    get {
      if (totalAssetsAfter == null)
        return 0.0;
      else
        return totalAssetsAfter;
    }
    set;
  }
  public Decimal totalLiabilitiesAfter {
    get {
      if (totalLiabilitiesAfter == null)
        return 0.0;
      else
        return totalLiabilitiesAfter;
    }
    set;
  }
  public Decimal totalLiabilitiesPrior {
    get {
      if (totalLiabilitiesPrior == null)
        return 0.0;
      else
        return totalLiabilitiesPrior;
    }
    set;
  }

  public Decimal loanRealEstateAfter {
    get {
      if (loanRealEstateAfter == null)
        return 0.0;
      else
        return loanRealEstateAfter;
    }
    set;
  }
  public Decimal otherLoansAfter {
    get {
      if (otherLoansAfter == null)
        return 0.0;
      else
        return otherLoansAfter;
    }
    set;
  }
  public Decimal loanCreditCardAfter {
    get {
      if (loanCreditCardAfter == null)
        return 0.0;
      else
        return loanCreditCardAfter;
    }
    set;
  }
  public Decimal loanCurrentAccountOverdraftAfter {
    get {
      if (loanCurrentAccountOverdraftAfter == null)
        return 0.0;
      else
        return loanCurrentAccountOverdraftAfter;
    }
    set;
  }

  public Decimal incomeRegular {
    get {
      if (incomeRegular == null)
        return 0.0;
      else
        return incomeRegular;
    }
    set;
  }
  public Decimal incomePerformance {
    get {
      if (incomePerformance == null)
        return 0.0;
      else
        return incomePerformance;
    }
    set;
  }
  public Decimal incomeSelfEmployed {
    get {
      if (incomeSelfEmployed == null)
        return 0.0;
      else
        return incomeSelfEmployed;
    }
    set;
  }
  public Decimal incomeRental {
    get {
      if (incomeRental == null)
        return 0.0;
      else
        return incomeRental;
    }
    set;
  }
  public Decimal incomePension {
    get {
      if (incomePension == null)
        return 0.0;
      else
        return incomePension;
    }
    set;
  }
  public Decimal incomeOther {
    get {
      if (incomeOther == null)
        return 0.0;
      else
        return incomeOther;
    }
    set;
  }
  public Decimal totalGrossMontlyIncome {
    get {
      if (totalGrossMontlyIncome == null)
        return 0.0;
      else
        return totalGrossMontlyIncome;
    }
    set;
  }
  public Decimal lessStatutoryDeductions {
    get {
      if (lessStatutoryDeductions == null)
        return 0.0;
      else
        return lessStatutoryDeductions;
    }
    set;
  }
  public Decimal totalInflows {
    get {
      if (totalInflows == null)
        return 0.0;
      else
        return totalInflows;
    }
    set;
  }

  public Decimal installmentPayments {
    get {
      if (installmentPayments == null)
        return 0.0;
      else
        return installmentPayments;
    }
    set;
  }
  public Decimal lifeInsurancePayments {
    get {
      if (lifeInsurancePayments == null)
        return 0.0;
      else
        return lifeInsurancePayments;
    }
    set;
  }
  public Decimal savingsInvestments {
    get {
      if (savingsInvestments == null)
        return 0.0;
      else
        return savingsInvestments;
    }
    set;
  }
  public Decimal pensionContribution {
    get {
      if (pensionContribution == null)
        return 0.0;
      else
        return pensionContribution;
    }
    set;
  }
  public Decimal propertyRelatedCosts {
    get {
      if (propertyRelatedCosts == null)
        return 0.0;
      else
        return propertyRelatedCosts;
    }
    set;
  }
  public Decimal personalFamilyCosts {
    get {
      if (personalFamilyCosts == null)
        return 0.0;
      else
        return personalFamilyCosts;
    }
    set;
  }
  public Decimal utilitiesExpenses {
    get {
      if (utilitiesExpenses == null)
        return 0.0;
      else
        return utilitiesExpenses;
    }
    set;
  }
  public Decimal transportationCosts {
    get {
      if (transportationCosts == null)
        return 0.0;
      else
        return transportationCosts;
    }
    set;
  }

  public Decimal installmentPaymentsAfter {
    get {
      if (installmentPaymentsAfter == null)
        return 0.0;
      else
        return installmentPaymentsAfter;
    }
    set;
  }
  public Decimal lifeInsurancePaymentsAfter {
    get {
      if (lifeInsurancePaymentsAfter == null)
        return 0.0;
      else
        return lifeInsurancePaymentsAfter;
    }
    set;
  }
  public Decimal savingsInvestmentsAfter {
    get {
      if (savingsInvestmentsAfter == null)
        return 0.0;
      else
        return savingsInvestmentsAfter;
    }
    set;
  }
  public Decimal pensionContributionAfter {
    get {
      if (pensionContributionAfter == null)
        return 0.0;
      else
        return pensionContributionAfter;
    }
    set;
  }
  public Decimal propertyRelatedCostsAfter {
    get {
      if (propertyRelatedCostsAfter == null)
        return 0.0;
      else
        return propertyRelatedCostsAfter;
    }
    set;
  }
  public Decimal personalFamilyCostsAfter {
    get {
      if (personalFamilyCostsAfter == null)
        return 0.0;
      else
        return personalFamilyCostsAfter;
    }
    set;
  }
  public Decimal utilitiesExpensesAfter {
    get {
      if (utilitiesExpensesAfter == null)
        return 0.0;
      else
        return utilitiesExpensesAfter;
    }
    set;
  }
  public Decimal transportationCostsAfter {
    get {
      if (transportationCostsAfter == null)
        return 0.0;
      else
        return transportationCostsAfter;
    }
    set;
  }
  public Decimal totalOutflowsAfter {
    get {
      if (totalOutflowsAfter == null)
        return 0.0;
      else
        return totalOutflowsAfter;
    }
    set;
  }
  public Decimal totalOutflowsBefore {
    get {
      if (totalOutflowsBefore == null)
        return 0.0;
      else
        return totalOutflowsBefore;
    }
    set;
  }
  public Decimal residualIncomeAfterBeforeLoan {
    get {
      if (residualIncomeAfterBeforeLoan == null)
        return 0.0;
      else
        return residualIncomeAfterBeforeLoan;
    }
    set;
  }
  public Decimal residualIncomeAfterAfterLoan {
    get {
      if (residualIncomeAfterAfterLoan == null)
        return 0.0;
      else
        return residualIncomeAfterAfterLoan;
    }
    set;
  }

  public Loan_Calculator__c loanCalculator { get; set; }
  public String todayDate { get; set; }

  public List<FinServ__AssetsAndLiabilities__c> realEstateAssets { get; set; }
  public List<FinServ__AssetsAndLiabilities__c> motorVehicleAssets { get; set; }
  public List<FinServ__AssetsAndLiabilities__c> otherLoanAssets { get; set; }
  public List<FinServ__AssetsAndLiabilities__c> otherAssetsAssets { get; set; }
  public List<FinServ__AssetsAndLiabilities__c> pensionAssets { get; set; }
  public List<FinServ__AssetsAndLiabilities__c> creditCardAssets { get; set; }
  public List<FinServ__AssetsAndLiabilities__c> lineOfCreditAssets { get; set; }
  public List<FinServ__AssetsAndLiabilities__c> lifeInsuranceAssets {
    get;
    set;
  }
  public List<FinServ__AssetsAndLiabilities__c> savingsAssets { get; set; }

  public static String combinationString { get; set; }
  public static List<Application_Asset_Liability__c> applicantAssetsLiabilities {
    get;
    set;
  }
  public static String applicantNumber = '';
  public PDFGeneratorController(ApexPages.StandardController controller) {
    DateTime thisDate = Datetime.now();
    todayDate = thisDate.format('dd-MMM-yyyy');
    System.debug('Parameters: ' + ApexPages.currentPage().getParameters());
    if (
      ApexPages.currentPage().getParameters().containsKey('oppid') &&
      ApexPages.currentPage().getParameters().containsKey('appid')
    ) {
      recordId = ApexPages.currentPage().getParameters().get('oppid');
      Id applicantId = ApexPages.currentPage().getParameters().get('appid');
      applicantNumber = ApexPages.currentPage().getParameters().get('num');

      thisOpportunity = [
        SELECT Id, AccountId, Product_Details__c
        FROM Opportunity
        WHERE id = :recordId
      ];

      Loan_Calculator__c[] productDetails = [
        SELECT
          Id,
          Market_Value_of_Vehicle__c,
          Total_Loan_Amount__c,
          Monthly_Loan_Payment__c,
          Unsecured_Loan_Amount__c,
          App_3_Monthly_Payment_UL__c,
          Unsecure_Monthly_Loan_Payment__c,
          Line_of_Credit_Starting_Limit__c,
          Minimum_Payment_as_per_Credit_Limit__c,
          Type_of_LOC__c,
          App_3_Monthly_Payment_A__c,
          unsecure_Monthly_n_Loan_Savings__c,
          Monthly_Loan_Savings__c,
          App1_Loan_Amt_Alloc_UL__c,
          App_3_Loan_Amount_A__c,
          App_2_Loan_Amount_A__c,
          Minimum_Payment__c,
          App_1_Loan_Amount_A__c,
          App_3_Min_Payment_LOC__c,
          App_1_Min_Payment__c,
          App_2_Min_Payment_LOC__c,
          App1_Monthly_Payment_A__c,
          App_2_Monthly_Payment_A__c
        FROM Loan_Calculator__c
        WHERE Id = :thisOpportunity.Product_Details__c
      ];

      if (productDetails.size() > 0) {
        loanCalculator = productDetails.get(0);
      } else {
        loanCalculator = new Loan_Calculator__c();
      }
      applicant = [
        SELECT
          Id,
          Applicable_sources_of_income__c,
          Salary_and_Allowances_as_per_pay_slips__c,
          Gratuity_in_lieu_of_Pension__c,
          Performance_Based_Pay_Includes_Commissi__c,
          Net_Profit_Sole_Trader__c,
          Director_s_Emoluments_Director__c,
          Share_of_Profit_Partnership__c,
          Share_of_Profit_Shareholder__c,
          Pension__c,
          Existing_Real_estate_Rental_II__c,
          Existing_Real_Estate_Rental_I__c,
          Projected_Real_Estate_Rental__c,
          Other_Income__c,
          Income_Tax_Monthly_Payment_Prior_Loan__c,
          NIS_Contribution_Monthly_Prior_Loan__c,
          NHT_Contributions_Monthly_Prior_Loan__c,
          Education_Tax_Monthly_Prior_Loan__c,
          Food_Cost_Monthly_Prior_Loan__c,
          Food_Costs_Monthly_After_Loan__c,
          Personal_Expenses_Monthly_Prior_Loan__c,
          Personal_Expenses_Monthly_After_Loan__c,
          Child_Care_Costs_Monthly_Prior_Loan__c,
          Child_Care_Costs_Monthly_After_Loan__c,
          School_Costs_Monthly_Prior_Loan__c,
          School_Costs_Monthly_After_Loan__c,
          Health_Costs_Monthly_Prior_Loan__c,
          Health_Costs_Monthly_After_Loan__c,
          Other_Personal_Family_Costs_Prior_After__c,
          Other_Personal_Family_Monthly_Prior_Loan__c,
          Rent_Board_Monthly_Prior_Loan__c,
          Rent_Board_Monthly_After_Loan__c,
          Strata_Maintenance_Monthly_Prior_Loan__c,
          Strata_Maintenance_Monthly_After_Loan__c,
          Property_Tax_Monthly_Prior_Loan__c,
          Property_Tax_Monthly_After_Loan__c,
          Property_Insurance_Monthly_Prior_Loan__c,
          Property_Insurance_Monthly_After_Loan__c,
          Property_Maintenance_Monthly_Prior_loan__c,
          Property_Maintenance_Monthly_After_Loan__c,
          Electricity_Monthly_Prior_Loan__c,
          Electricity_Monthly_After_Loan__c,
          Water_Monthly_Prior_Loan__c,
          Water_Monthly_After_Loan__c,
          Cell_Phone_Landline_Monthly_Prior_Loan__c,
          Cell_Phone_Landline_Monthly_After_Loan__c,
          Internet_Cable_Monthly_Prior_Loan__c,
          Internet_Cable_Monthly_After_Loan__c,
          Cooking_Gas_Monthly_Prior_Loan__c,
          Cooking_Gas_Monthly_After_Loan__c,
          House_Keeping_Monthly_Prior_Loan__c,
          House_Keeping_Costs_Monthly_After_Loan__c,
          Other_Utilities_Monthly_Prior_Loan__c,
          Other_Utilities_Monthly_After_Loan__c,
          Fares_Monthly_Prior_Loan__c,
          Fares_Monthly_After_Loan__c,
          Toll_Fees_Monthly_Prior_Loan__c,
          Toll_Fees_Monthly_After_Loan__c,
          Petrol_Fuel_Monthly_Prior_Loan__c,
          Petrol_Fuel_Monthly_After_Loan__c,
          Motor_V_Insurance_Monthly_Prior_Loan__c,
          Motor_V_Insurance_Monthly_After_Loan__c,
          Motor_Vehicle_Reg_Monthly_Prior_Loan__c,
          Motor_Vehicle_Reg_Monthly_After_Loan__c,
          Motor_Vehicle_Fitness_Monthly_Prior_Loan__c,
          Motor_Vehicle_Fitness_Monthly_After_Loan__c,
          Motor_V_Maintenance_Monthly_Before_Loan__c,
          Motor_V_Maintenance_Monthly_After_Loan__c,
          Other_Transport_Costs_Monthly_Prior_Loan__c,
          Other_Transport_Monthly_After_Loan__c,
          Gratuity_in_lieu_of_PensionC__c,
          Net_Profit_Sole_TraderC__c,
          Director_s_Emoluments_DirectorC__c,
          Share_of_Profit_PartnershipC__c,
          Share_of_Profit_ShareholderC__c,
          Projected_Real_Estate_RentalC__c,
          Existing_Real_estate_Rental_II_C__c,
          PensionC__c,
          Account__r.Name,
          Other_IncomeC__c,
          Performance_Based_PayC__c,
          Account__c,
          Existing_Real_Estate_Rental_IC__c,
          Overdraft_Limit__c,
          Gross_Monthly_IncomeC__c
        FROM Applicant__c
        WHERE id = :applicantId
      ];
      System.debug('Found applicant: ' + applicant.Id);
      System.debug('Found applicant Account: ' + applicant.Account__c);
      FinServ__AssetsAndLiabilities__c[] assetsTemp = [
        SELECT
          Id,
          Loan_Balance_Prior__c,
          Monthly_Payment_Prior__c,
          Total_Market_Value__c,
          Cash_Value__c,
          Account_Balance__c,
          Total_Contributions_to_Date__c,
          Asset_Credit_Balance__c,
          Overdraft_Limit__c,
          Asset_Credit_Balance_After__c,
          Loan_Balance_After__c,
          Annual_Premium__c,
          Monthly_Savings_Investment__c,
          Minimum_Payment__c,
          Monthly_Contribution_Before_Loan__c,
          Monthly_Saving_Investment_after_Loan__c,
          Monthly_Contribution_After_Loan__c,
          Address__c,
          Property_Type__c,
          Lender__c,
          Monthly_Payment__c,
          Vehicle_Details__c,
          Description_of_Asset__c,
          Financial_Institution__c,
          Type_of_Loan__c,
          Pension_Scheme__c,
          Percent_Average_Monthly_User__c,
          Asset_Credit_Limit__c,
          Minimum_Payment_After__c,
          Type_of_Card__c,
          Average_Monthly_Usage__c,
          Total_Market_Value_Calc__c,
          Policy_Number__c,
          Sum_Insured__c,
          Type_Of_Account__C,
          Percent_Ownership__c
        FROM FinServ__AssetsAndLiabilities__c
        WHERE FinServ__PrimaryOwner__c = :applicant.Account__c
      ];
      System.debug('Found Assets: ' + assetsTemp.size());
      if (assetsTemp.size() > 0) {
        assets = assetsTemp;
      } else {
        assets = new List<FinServ__AssetsAndLiabilities__c>();
      }
      System.debug('Assets ==> ' + assets);

      applicantAssetsLiabilities = [
        SELECT
          Id,
          Assets_and_Liabilities__r.RecordType.DeveloperName,
          Loan_Balance_Prior__c,
          Asset_Credit_Balance__c,
          Account_Balance_After__c,
          Loan_Balance_After__c,
          Asset_Credit_Balance_After__c,
          Monthly_Payment_Prior__c,
          Assets_and_Liabilities__r.Id,
          Minimum_payment__c,
          Minimum_Payment_After__c,
          Assets_and_Liabilities__r.Loan_Balance_Prior__c,
          Assets_and_Liabilities__r.Monthly_Payment_Prior__c,
          Assets_and_Liabilities__r.Total_Market_Value__c,
          Assets_and_Liabilities__r.Cash_Value__c,
          Assets_and_Liabilities__r.Account_Balance__c,
          Assets_and_Liabilities__r.Total_Contributions_to_Date__c,
          Assets_and_Liabilities__r.Asset_Credit_Balance__c,
          Assets_and_Liabilities__r.Overdraft_Limit__c,
          Assets_and_Liabilities__r.Asset_Credit_Balance_After__c,
          Assets_and_Liabilities__r.Loan_Balance_After__c,
          Assets_and_Liabilities__r.Annual_Premium__c,
          Assets_and_Liabilities__r.Monthly_Savings_Investment__c,
          Assets_and_Liabilities__r.Minimum_Payment__c,
          Assets_and_Liabilities__r.Monthly_Contribution_Before_Loan__c,
          Assets_and_Liabilities__r.Monthly_Saving_Investment_after_Loan__c,
          Assets_and_Liabilities__r.Monthly_Contribution_After_Loan__c,
          Assets_and_Liabilities__r.Address__c,
          Assets_and_Liabilities__r.Property_Type__c,
          Assets_and_Liabilities__r.Lender__c,
          Assets_and_Liabilities__r.Monthly_Payment__c,
          Assets_and_Liabilities__r.Vehicle_Details__c,
          Assets_and_Liabilities__r.Description_of_Asset__c,
          Assets_and_Liabilities__r.Financial_Institution__c,
          Assets_and_Liabilities__r.Type_of_Loan__c,
          Assets_and_Liabilities__r.Pension_Scheme__c,
          Assets_and_Liabilities__r.Percent_Average_Monthly_User__c,
          Assets_and_Liabilities__r.Asset_Credit_Limit__c,
          Assets_and_Liabilities__r.Minimum_Payment_After__c,
          Assets_and_Liabilities__r.Type_of_Card__c,
          Assets_and_Liabilities__r.Average_Monthly_Usage__c,
          Assets_and_Liabilities__r.Total_Market_Value_Calc__c,
          Assets_and_Liabilities__r.Policy_Number__c,
          Assets_and_Liabilities__r.Sum_Insured__c,
          Assets_and_Liabilities__r.Type_Of_Account__C,
          Assets_and_Liabilities__r.Percent_Ownership__c,
          Assets_and_Liabilities__r.Percent_Applicant_Portion__c,
          Monthly_Contribution_Before_Loan__c,
          Monthly_Contribution_After_Loan__c
        FROM Application_Asset_Liability__c
        WHERE
          Application__c = :applicantId
          AND Application__r.Opportunity__c = :thisOpportunity.Id
      ];
      System.debug(
        'Found Applicant Assets: ' + applicantAssetsLiabilities.size()
      );
      if (applicantAssetsLiabilities == null) {
        applicantAssetsLiabilities = new List<Application_Asset_Liability__c>();
      }
      addAssetLiaibilityRecords(assets);
      sumApplicantAssetsLiabilities(applicantAssetsLiabilities);
      netWorthPrior = totalAssetsPrior - totalLiabilitiesPrior;
      netWorthAfter = totalAssetsAfter - totalLiabilitiesAfter;
      sumUpAllMonthlyflows();
      String selection = MultiProductCalculatorController.getproductselection(
        recordId
      );
      setCombinations(selection);
    }
  }

  private static void setCombinations(String selection) {
    switch on selection {
      when '1' {
        combinationString = 'Auto Loan';
      }
      when '2' {
        combinationString = 'Unsecured Loan';
      }
      when '3' {
        combinationString = 'Credit Card';
      }
      when '4' {
        combinationString = 'Line of Credit';
      }
      when '5' {
        combinationString = 'Auto Loan &amp; Unsecured Loan';
      }
      when '6' {
        combinationString = 'Auto Loan &amp; Credit Card';
      }
      when '7' {
        combinationString = 'Auto Loan &amp; Line of Credit';
      }
      when '8' {
        combinationString = 'Unsecured Loan &amp; Credit Card';
      }
      when '9' {
        combinationString = 'Unsecured Loan &amp; Line of Credit';
      }
      when '10' {
        combinationString = 'Credit Card &amp; Line of Credit';
      }
      when '11' {
        combinationString = 'Auto Loan, Unsecured Loan &amp; Credit Card';
      }
      when '12' {
        combinationString = 'Auto Loan, Unsecured Loan &amp; Line of Credit';
      }
      when '13' {
        combinationString = 'Auto Loan, Credit Card &amp; Line of Credit';
      }
      when '14' {
        combinationString = 'Unsecured Loan, Credit Card &amp; Line of Credit';
      }
      when '15' {
        combinationString = 'Auto Loan, Unsecured Loan, Credit Card &amp; Line of Credit';
      }
    }
  }
  private Map<Id, RecordType> getRecordTypeMap(String sObjectType) {
    return new Map<Id, RecordType>(
      [
        SELECT Id, Name, DeveloperName
        FROM RecordType
        WHERE sobjecttype = :sObjectType
      ]
    );
  }
  private String getRecordTypeName(Id recordTypeId, String sObjectType) {
    return getRecordTypeMap(sObjectType).get(recordTypeId).DeveloperName;
  }
  private Decimal cv(Object obj) {
    String value = String.valueOf(obj);
    Decimal result = 0.0;
    if (value != null) {
      result = Decimal.valueOf(value);
    }
    return result;
  }

  public void sumApplicantAssetsLiabilities(
    List<Application_Asset_Liability__c> records
  ) {
    for (Application_Asset_Liability__c record : records) {
      System.debug(
        'Applicant record type: ' +
        record.Assets_and_Liabilities__r.RecordType.DeveloperName
      );
      System.debug(
        'Applicant data convert: ' +
        cv(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c)
      );
      System.debug(
        'Applicant data: ' +
        (record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c)
      );
      switch on record.Assets_and_Liabilities__r.RecordType.DeveloperName {
        when 'Real_Estate' {
          //Summary Assets and Liabilities - Assets Before Proposed assets
          realEstateBefore += cv(
            record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c
          );
          realEstateAfter += cv(
            record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c
          );

          //Summary Assets and Liabilities - Liabilities Before Proposed Loan
          loanRealEstateBefore +=
            cv(record.get('Loan_Balance_Prior__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Ownership__c);

          loanRealEstateAfter +=
            cv(record.get('Loan_Balance_After__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Ownership__c);

          //infows & outflows
          installmentPayments +=
            cv(record.Monthly_Payment_Prior__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
          installmentPaymentsAfter +=
            cv(record.Assets_and_Liabilities__r.Monthly_Payment__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
        }
        when 'Motor_Vehicle' {
          //Summary Assets and Liabilities - Assets Before Proposed assets
          motorVehicleBefore += cv(
            record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c
          );
          motorVehicleAfter += cv(
            record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c
          );

          //Summary Assets and Liabilities - Liabilities Before Proposed Loan
          loanMotorVehicleBefore +=
            cv(record.get('Loan_Balance_Prior__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Ownership__c);

          loanMotorVehicleAfter +=
            cv(record.get('Loan_Balance_After__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Ownership__c);

          installmentPayments +=
            cv(record.Monthly_Payment_Prior__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
          installmentPaymentsAfter +=
            cv(record.Assets_and_Liabilities__r.Monthly_Payment__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c) +
            cv(loanCalculator.Monthly_Loan_Payment__c);
          if (applicantNumber == '1') {
            motorVehicleAfter +=
              cv(loanCalculator.Market_Value_of_Vehicle__c) +
              cv(loanCalculator.App_1_Loan_Amount_A__c);
            installmentPaymentsAfter *= cv(
              loanCalculator.App1_Monthly_Payment_A__c
            );
          } else if (applicantNumber == '2') {
            motorVehicleAfter +=
              cv(loanCalculator.Market_Value_of_Vehicle__c) +
              cv(loanCalculator.App_2_Loan_Amount_A__c);
            installmentPaymentsAfter *= cv(
              loanCalculator.App_2_Monthly_Payment_A__c
            );
          } else {
            motorVehicleAfter +=
              cv(loanCalculator.Market_Value_of_Vehicle__c) +
              cv(loanCalculator.App_3_Loan_Amount_A__c);
            installmentPaymentsAfter *= cv(
              loanCalculator.App_3_Monthly_Payment_A__c
            );
          }
        }
        when 'Other_Assets' {
          //Summary Assets and Liabilities - Assets Before Proposed assets
          otherAssetBefore += cv(
            record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c
          );
          otherAssetAfter += cv(
            record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c
          );

          //Summary Assets and Liabilities - Liabilities Before Proposed loan
          loanOtherAssetBefore +=
            cv(record.get('Loan_Balance_Prior__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Ownership__c);

          loanOtherAssetAfter +=
            cv(record.get('Loan_Balance_After__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Ownership__c);

          installmentPayments +=
            cv(record.Monthly_Payment_Prior__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
          installmentPaymentsAfter +=
            cv(record.Assets_and_Liabilities__r.Monthly_Payment__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
        }
        when 'Other_Loans' {
          //Summary Assets and Liabilities - Liabilities Before Proposed Loan
          otherLoansBefore +=
            cv(record.get('Loan_Balance_Prior__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Ownership__c);

          otherLoansAfter +=
            cv(record.get('Loan_Balance_After__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Ownership__c);

          installmentPayments +=
            cv(record.Monthly_Payment_Prior__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
          installmentPaymentsAfter +=
            cv(record.Assets_and_Liabilities__r.Monthly_Payment__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c) +
            cv(loanCalculator.Unsecure_Monthly_Loan_Payment__c);
          if (applicantNumber == '1') {
            otherLoansAfter += cv(loanCalculator.App1_Loan_Amt_Alloc_UL__c);
            installmentPaymentsAfter *= cv(
              loanCalculator.App_1_Monthly_Payment_UL__c
            );
          } else if (applicantNumber == '2') {
            installmentPaymentsAfter *= cv(
              loanCalculator.App_2_Monthly_Payment_UL__c
            );
          } else {
            installmentPaymentsAfter *= cv(
              loanCalculator.App_3_Monthly_Payment_UL__c
            );
          }
        }
        when 'Credit_Cards', 'Lines_of_Credit' {
          //Summary Assets and Liabilities - Liabilities Before Proposed Loan
          loanCreditCardBefore += cv(record.get('Asset_Credit_Balance__c'));
          loanCreditCardBefore += cv(
            record.get('Asset_Credit_Balance_After__c')
          );

          installmentPayments +=
            cv(record.Minimum_payment__c) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);

          installmentPaymentsAfter +=
            cv(record.get('Minimum_Payment_After__c')) *
            cv(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c) +
            cv(loanCalculator.Minimum_Payment__c);
          if (applicantNumber == '1') {
            installmentPaymentsAfter *= cv(loanCalculator.App_1_Min_Payment__c);
          } else if (applicantNumber == '2') {
            installmentPaymentsAfter *= cv(
              loanCalculator.App_2_Min_Payment_LOC__c
            );
          } else {
            installmentPaymentsAfter *= cv(
              loanCalculator.App_3_Min_Payment_LOC__c
            );
          }
        }
        when 'Life_Insurance_Policies' {
          //Summary Assets and Liabilities - Assets Before Proposed Loan
          lifeInsuranceBefore += cv(
            record.Assets_and_Liabilities__r.Cash_Value__c
          );
          lifeInsuranceAfter += cv(
            record.Assets_and_Liabilities__r.Cash_Value__c
          );
          lifeInsurancePaymentsAfter += cv(
            record.Assets_and_Liabilities__r.Annual_Premium__c
          );
        }
        when 'Savings_Current_Accounts_Investments' {
          savingsAfter +=
            cv(record.Assets_and_Liabilities__r.Account_Balance__c) +
            cv(record.Account_Balance_After__c);
          savingsBefore += cv(
            record.Assets_and_Liabilities__r.Account_Balance__c
          );

          savingsInvestmentsAfter += cv(
            record.Assets_and_Liabilities__r.Monthly_Saving_Investment_after_Loan__c
          );
        }
        when 'Pension_Contributions_or_Individual' {
          //Summary Assets and Liabilities - Assets Before Proposed assets
          pensionBefore += cv(
            record.Assets_and_Liabilities__r.Total_Contributions_to_Date__c
          );
          pensionAfter += cv(
            record.Assets_and_Liabilities__r.Total_Contributions_to_Date__c
          );

          pensionContribution += cv(
            record.get('Monthly_Contribution_Before_Loan__c')
          );
          pensionContributionAfter += cv(
            record.get('Monthly_Contribution_After_Loan__c')
          );
        }
      }
      loanCurrentAccountOverdraftBefore += cv(
        record.Assets_and_Liabilities__r.Overdraft_Limit__c
      );
      loanCurrentAccountOverdraftAfter += cv(
        record.Assets_and_Liabilities__r.Overdraft_Limit__c
      );
    }
    //grand totals
    totalAssetsPrior +=
      pensionBefore +
      lifeInsuranceBefore +
      otherAssetBefore +
      loanMotorVehicleBefore +
      realEstateBefore +
      savingsBefore;
    totalAssetsAfter +=
      pensionAfter +
      lifeInsuranceAfter +
      otherAssetAfter +
      loanMotorVehicleAfter +
      realEstateAfter +
      savingsAfter;
    totalLiabilitiesPrior +=
      loanCurrentAccountOverdraftBefore +
      loanCreditCardBefore +
      otherLoansBefore +
      loanOtherAssetBefore +
      loanMotorVehicleBefore +
      loanRealEstateBefore;
    totalLiabilitiesAfter +=
      loanCreditCardAfter +
      otherLoansAfter +
      loanOtherAssetAfter +
      loanMotorVehicleAfter +
      realEstateAfter +
      loanCurrentAccountOverdraftAfter;
  }
  public void addAssetLiaibilityRecords(
    FinServ__AssetsAndLiabilities__c[] assets
  ) {
    String recordTypeId;
    String name;
    realEstateAssets = new List<FinServ__AssetsAndLiabilities__c>();
    motorVehicleAssets = new List<FinServ__AssetsAndLiabilities__c>();
    otherLoanAssets = new List<FinServ__AssetsAndLiabilities__c>();
    otherAssetsAssets = new List<FinServ__AssetsAndLiabilities__c>();
    pensionAssets = new List<FinServ__AssetsAndLiabilities__c>();
    creditCardAssets = new List<FinServ__AssetsAndLiabilities__c>();
    lineOfCreditAssets = new List<FinServ__AssetsAndLiabilities__c>();
    lifeInsuranceAssets = new List<FinServ__AssetsAndLiabilities__c>();
    savingsAssets = new List<FinServ__AssetsAndLiabilities__c>();

    for (FinServ__AssetsAndLiabilities__c asset : assets) {
      name = getRecordTypeName(
        asset.RecordTypeId,
        'FinServ__AssetsAndLiabilities__c'
      );
      switch on name {
        when 'Real_Estate' {
          realEstateAssets.add(asset);
        }
        when 'Motor_Vehicle' {
          motorVehicleAssets.add(asset);
        }
        when 'Other_Assets' {
          otherAssetsAssets.add(asset);
        }
        when 'Life_Insurance_Policies' {
          lifeInsuranceAssets.add(asset);
          lifeInsurancePayments += cv(asset.get('Annual_Premium__c')) / 12;
        }
        when 'Savings_Current_Accounts_Investments' {
          savingsAssets.add(asset);
          savingsInvestments += cv(asset.get('Monthly_Savings_Investment__c'));
        }
        when 'Pension_Contributions_or_Individual' {
          pensionAssets.add(asset);
        }
        when 'Other_Loans' {
          otherLoanAssets.add(asset);
        }
        when 'Lines_of_Credit' {
          lineOfCreditAssets.add(asset);
        }
        when 'Credit_Cards' {
          creditCardAssets.add(asset);
        }
      }
    }
  }
  public void sumUpAllMonthlyflows() {
    incomeRegular = loanCurrentAccountOverdraftAfter =
      cv(applicant.get('Salary_and_Allowances_as_per_pay_slips__c')) +
      cv(applicant.get('Gratuity_in_lieu_of_PensionC__c'));

    incomePerformance = cv(applicant.get('Performance_Based_PayC__c'));

    incomeSelfEmployed =
      cv(applicant.get('Net_Profit_Sole_TraderC__c')) +
      cv(applicant.get('Director_s_Emoluments_DirectorC__c')) +
      cv(applicant.get('Share_of_Profit_PartnershipC__c')) +
      cv(applicant.get('Share_of_Profit_ShareholderC__c'));

    incomeRental =
      cv(applicant.get('Projected_Real_Estate_RentalC__c')) +
      cv(applicant.get('Existing_Real_estate_Rental_II_C__c')) +
      cv(applicant.get('Existing_Real_Estate_Rental_IC__c'));

    incomePension = cv(applicant.get('PensionC__c'));

    incomeOther = cv(applicant.get('Other_IncomeC__c'));

    totalGrossMontlyIncome = cv(applicant.get('Gross_Monthly_IncomeC__c'));
    //incomeRegular + incomePerformance + incomeSelfEmployed + incomeRental + incomePension + incomeOther;

    lessStatutoryDeductions =
      cv(applicant.get('Income_Tax_Monthly_Payment_Prior_Loan__c')) +
      cv(applicant.get('NIS_Contribution_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Education_Tax_Monthly_Prior_Loan__c')) +
      cv(applicant.get('NHT_Contributions_Monthly_Prior_Loan__c'));

    totalInflows = totalGrossMontlyIncome - lessStatutoryDeductions;

    propertyRelatedCosts =
      cv(applicant.get('Property_Maintenance_Monthly_Prior_loan__c')) +
      cv(applicant.get('Property_Insurance_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Property_Tax_Monthly_Prior_Loan__c'));

    personalFamilyCosts =
      cv(applicant.get('Personal_Expenses_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Food_Cost_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Child_Care_Costs_Monthly_Prior_Loan__c')) +
      cv(applicant.get('School_Costs_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Health_Costs_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Other_Personal_Family_Monthly_Prior_Loan__c'));

    utilitiesExpenses =
      cv(applicant.get('Electricity_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Water_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Cell_Phone_Landline_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Internet_Cable_Monthly_Prior_Loan__c')) +
      cv(applicant.get('House_Keeping_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Other_Utilities_Monthly_Prior_Loan__c'));

    transportationCosts =
      cv(applicant.get('Fares_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Petrol_Fuel_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Toll_Fees_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Motor_V_Insurance_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Motor_Vehicle_Reg_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Motor_Vehicle_Fitness_Monthly_Prior_Loan__c')) +
      cv(applicant.get('Motor_V_Maintenance_Monthly_Before_Loan__c')) +
      cv(applicant.get('Other_Transport_Costs_Monthly_Prior_Loan__c'));

    transportationCostsAfter =
      cv(applicant.get('Other_Transport_Monthly_After_Loan__c')) +
      cv(applicant.get('Fares_Monthly_After_Loan__c')) +
      cv(applicant.get('Petrol_Fuel_Monthly_After_Loan__c')) +
      cv(applicant.get('Motor_V_Insurance_Monthly_After_Loan__c')) +
      cv(applicant.get('Toll_Fees_Monthly_After_Loan__c')) +
      cv(applicant.get('Motor_V_Insurance_Monthly_After_Loan__c')) +
      cv(applicant.get('Motor_Vehicle_Reg_Monthly_After_Loan__c')) +
      cv(applicant.get('Motor_V_Maintenance_Monthly_After_Loan__c')) +
      cv(applicant.get('Motor_Vehicle_Fitness_Monthly_After_Loan__c'));

    propertyRelatedCostsAfter =
      cv(applicant.get('Property_Insurance_Monthly_After_Loan__c')) +
      cv(applicant.get('Property_Tax_Monthly_After_Loan__c')) +
      cv(applicant.get('Property_Maintenance_Monthly_After_Loan__c'));

    personalFamilyCostsAfter =
      cv(applicant.get('Personal_Expenses_Monthly_After_Loan__c')) +
      cv(applicant.get('Food_Costs_Monthly_After_Loan__c')) +
      cv(applicant.get('Child_Care_Costs_Monthly_After_Loan__c')) +
      cv(applicant.get('School_Costs_Monthly_After_Loan__c')) +
      cv(applicant.get('Health_Costs_Monthly_After_Loan__c')) +
      cv(applicant.get('Other_Personal_Family_Costs_Prior_After__c'));

    utilitiesExpensesAfter =
      cv(applicant.get('Electricity_Monthly_After_Loan__c')) +
      cv(applicant.get('Water_Monthly_After_Loan__c')) +
      cv(applicant.get('Cell_Phone_Landline_Monthly_After_Loan__c')) +
      cv(applicant.get('Internet_Cable_Monthly_After_Loan__c')) +
      cv(applicant.get('Cooking_Gas_Monthly_After_Loan__c')) +
      cv(applicant.get('Other_Utilities_Monthly_After_Loan__c')) +
      cv(applicant.get('House_Keeping_Costs_Monthly_After_Loan__c'));

    totalOutflowsBefore =
      installmentPayments +
      lifeInsurancePayments +
      savingsInvestments +
      pensionContribution +
      propertyRelatedCosts +
      personalFamilyCosts +
      utilitiesExpenses +
      transportationCosts;

    totalOutflowsAfter =
      installmentPaymentsAfter +
      lifeInsurancePaymentsAfter +
      savingsInvestmentsAfter +
      pensionContributionAfter +
      propertyRelatedCostsAfter +
      personalFamilyCostsAfter +
      utilitiesExpensesAfter +
      transportationCostsAfter;

    residualIncomeAfterBeforeLoan = totalInflows - totalOutflowsBefore;
    residualIncomeAfterAfterLoan = totalInflows - totalOutflowsAfter;
  }
}
