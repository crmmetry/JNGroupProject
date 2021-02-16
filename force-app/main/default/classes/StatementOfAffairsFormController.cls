public class StatementOfAffairsFormController {
  public Id applicantId { get; set; }
  public Applicant__c applicantObj { get; set; }
  public ApplicantWrapperClass applicantWrapper { get; set; }
  public ApplicantWrapper appWrapper { get; set; }
  public List<RealEstateWrapper> realEstateWrapperList { get; set; }
  public List<MotorVehicalWrapper> motorVehicalWrapperList { get; set; }
  public List<OtherAssetsWrapper> otherAssetsWrapperList { get; set; }
  public List<OtherLoansWrapper> otherLoanWrapperList { get; set; }
  public List<CreditCardWrapper> creditCardWrapperList { get; set; }
  public List<LineOfCreditWrapper> lineOfCreditWrapperList { get; set; }
  public List<SavingsAccountWrapper> savingsAccountWrapperList { get; set; }
  public List<LifeInsuranceWrapper> lifeInsuranceWrapperList { get; set; }
  public List<PensionContributionWrapper> pensionWrapperList { get; set; }
  public List<LiabilitiesWrapper> liabilitiesWrapperList { get; set; }
  public Map<String, Id> recordTypesMap { get; set; }
  public Decimal realEstateSummaryBefore { get; set; }
  public Decimal realEstateSummaryAfter { get; set; }
  public Decimal realEstateSummaryBefore_Loan { get; set; }
  public Decimal realEstateSummaryAfter_Loan { get; set; }
  public Decimal MotorVehicalSummaryBefore { get; set; }
  public Decimal MotorVehicalSummaryAfter { get; set; }
  public Decimal MotorVehicalSummaryBefore_Loan { get; set; }
  public Decimal MotorVehicalSummaryAfter_Loan { get; set; }
  public Decimal OtherAssetsSummaryBefore { get; set; }
  public Decimal OtherAssetsSummaryAfter { get; set; }
  public Decimal OtherAssetsSummaryBefore_Loan { get; set; }
  public Decimal OtherAssetsSummaryAfter_Loan { get; set; }
  public Decimal contigentLiabilitiesSummaryBefore { get; set; }
  public Decimal contigentLiabilitiesSummaryAfter { get; set; }
  public Decimal OtherLoanSummaryBefore_Loan { get; set; }
  public Decimal OtherLoanSummaryAfter_Loan { get; set; }
  public Decimal currentAccountOverdraft_Before { get; set; }
  public Decimal currentAccountOverdraft_After { get; set; }
  public Decimal lifeInsurance_Before { get; set; }
  public Decimal lifeInsurance_After { get; set; }
  public Decimal PensionContribution_Before { get; set; }
  public Decimal PensionContribution_After { get; set; }
  public Decimal ccAndLocBalance_Before { get; set; }
  public Decimal ccAndLocBalance_After { get; set; }
  public Decimal totalAssets_before { get; set; }
  public Decimal totalAssets_after { get; set; }
  public Decimal totalLiabilities_before { get; set; }
  public Decimal totalLiabilities_after { get; set; }
  public Decimal savingsAccountBalance_Before { get; set; }
  public Decimal savingsAccountBalance_After { get; set; }
  public Decimal netWorth_Before { get; set; }
  public Decimal netWorth_After { get; set; }
  public Decimal applicantAllotedAmountFromProposedLoan { get; set; }
  public Object productCombination { get; set; }
  public StatementOfAffairsFormController() {
    recordTypesMap = Util.getRecordTypeids('FinServ__AssetsAndLiabilities__c');
    SET<Id> assetsIdSet = new Set<Id>();
    applicantId = ApexPages.currentPage().getParameters().get('Id');
    Decimal monthlyPaymentOwnership;
    Decimal totalMonthlyLoanPayment;
    realEstateSummaryBefore = 0;
    realEstateSummaryAfter = 0;
    realEstateSummaryBefore_Loan = 0;
    realEstateSummaryAfter_Loan = 0;
    MotorVehicalSummaryBefore = 0;
    MotorVehicalSummaryAfter = 0;
    MotorVehicalSummaryBefore_Loan = 0;
    MotorVehicalSummaryAfter_Loan = 0;
    OtherAssetsSummaryBefore = 0;
    OtherAssetsSummaryAfter = 0;
    OtherAssetsSummaryBefore_Loan = 0;
    OtherAssetsSummaryAfter_Loan = 0;
    contigentLiabilitiesSummaryBefore = 0;
    contigentLiabilitiesSummaryAfter = 0;
    OtherLoanSummaryBefore_Loan = 0;
    OtherLoanSummaryAfter_Loan = 0;
    currentAccountOverdraft_Before = 0;
    currentAccountOverdraft_After = 0;
    lifeInsurance_Before = 0;
    lifeInsurance_After = 0;
    PensionContribution_Before = 0;
    PensionContribution_After = 0;
    ccAndLocBalance_Before = 0;
    ccAndLocBalance_After = 0;
    totalAssets_before = 0;
    totalAssets_after = 0;
    totalLiabilities_before = 0;
    totalLiabilities_after = 0;
    savingsAccountBalance_Before = 0;
    savingsAccountBalance_After = 0;
    netWorth_Before = 0;
    netWorth_After = 0;
    applicantAllotedAmountFromProposedLoan = 0;
    applicantObj = [
      SELECT
        Id,
        Name,
        Account__r.Name,
        Opportunity__c,
        CurrencyIsoCode,
        Salary_and_Allowances_as_per_pay_slips__c,
        Gratuity_in_lieu_of_Pension__c,
        Performance_Based_PayC__c,
        Net_Profit_Sole_Trader__c,
        Director_s_Emoluments_Director__c,
        Share_of_Profit_Partnership__c,
        Share_of_Profit_Shareholder__c,
        Pension__c,
        Existing_Real_Estate_Rental_I__c,
        Existing_Real_estate_Rental_II__c,
        Other_Income__c,
        Income_Tax_Monthly_Payment_Prior_Loan__c,
        NIS_Contribution_Monthly_Prior_Loan__c,
        NHT_Contributions_Monthly_Prior_Loan__c,
        Education_Tax_Monthly_Prior_Loan__c,
        Rent_Board_Monthly_Prior_Loan__c,
        Strata_Maintenance_Monthly_Prior_Loan__c,
        Property_Tax_Monthly_Prior_Loan__c,
        Property_Insurance_Monthly_Prior_Loan__c,
        Property_Maintenance_Monthly_Prior_loan__c,
        Personal_Expenses_Monthly_Prior_Loan__c,
        Food_Cost_Monthly_Prior_Loan__c,
        Child_Care_Costs_Monthly_Prior_Loan__c,
        School_Costs_Monthly_Prior_Loan__c,
        Health_Costs_Monthly_Prior_Loan__c,
        Electricity_Monthly_Prior_Loan__c,
        Cell_Phone_Landline_Monthly_Prior_Loan__c,
        Water_Monthly_Prior_Loan__c,
        Internet_Cable_Monthly_Prior_Loan__c,
        Cooking_Gas_Monthly_Prior_Loan__c,
        House_Keeping_Monthly_Prior_Loan__c,
        Other_Utilities_Monthly_Prior_Loan__c,
        Fares_Monthly_Prior_Loan__c,
        Petrol_Fuel_Monthly_Prior_Loan__c,
        Toll_Fees_Monthly_Prior_Loan__c,
        Motor_V_Insurance_Monthly_Prior_Loan__c,
        Motor_Vehicle_Reg_Monthly_Prior_Loan__c,
        Motor_V_Maintenance_Monthly_Before_Loan__c,
        Other_Transport_Costs_Monthly_Prior_Loan__c,
        Ownership_Real_Estate_Rental__c,
        Ownership_Real_Estate_Rental_II__c,
        Rent_Board_Monthly_After_Loan__c,
        Strata_Maintenance_Monthly_After_Loan__c,
        Property_Tax_Monthly_After_Loan__c,
        Property_Insurance_Monthly_After_Loan__c,
        Property_Maintenance_Monthly_After_Loan__c,
        Food_Costs_Monthly_After_Loan__c,
        Personal_Expenses_Monthly_After_Loan__c,
        Child_Care_Costs_Monthly_After_Loan__c,
        School_Costs_Monthly_After_Loan__c,
        Health_Costs_Monthly_After_Loan__c,
        Other_Personal_Family_Costs_Prior_After__c,
        Electricity_Monthly_After_Loan__c,
        Cell_Phone_Landline_Monthly_After_Loan__c,
        Water_Monthly_After_Loan__c,
        Internet_Cable_Monthly_After_Loan__c,
        Cooking_Gas_Monthly_After_Loan__c,
        House_Keeping_Costs_Monthly_After_Loan__c,
        Other_Utilities_Monthly_After_Loan__c,
        Fares_Monthly_After_Loan__c,
        Petrol_Fuel_Monthly_After_Loan__c,
        Toll_Fees_Monthly_After_Loan__c,
        Motor_V_Insurance_Monthly_After_Loan__c,
        Motor_Vehicle_Reg_Monthly_After_Loan__c,
        Motor_V_Maintenance_Monthly_After_Loan__c,
        Other_Transport_Monthly_After_Loan__c,
        (
          SELECT Id, Assets_and_Liabilities__c, Name
          FROM Application_Assets_Liabilities__r
        ),
        (
          SELECT
            ID,
            Monthly_Payment_Ownership_Number__c,
            Loan_Calculation_Product_Id__c,
            Loan_Calculation_Product_Id__r.Total_Monthly_Loan_Payment_Number__c
          FROM Loan_Calculation_Applicant_Products__r
        )
      FROM Applicant__c
      WHERE Id = :applicantId
    ];

    if (applicantObj <> null) {
      object productDetails = ProductDetailController.getSingleProductFamilySelection(
        applicantObj.Opportunity__c
      );

      if (productDetails <> 'None') {
        productCombination = ((ProductSelectionWrapper) productDetails)
          .productFamily;
      }
      appWrapper = new ApplicantWrapper(applicantObj);
      applicantWrapper = new ApplicantWrapperClass(appWrapper, applicantObj);
      if (applicantObj.Application_Assets_Liabilities__r.size() > 0) {
        for (
          Application_Asset_Liability__c assets : applicantObj.Application_Assets_Liabilities__r
        ) {
          assetsIdSet.add(assets.Assets_and_Liabilities__c);
        }
      }
      if (applicantObj.Loan_Calculation_Applicant_Products__r.size() > 0) {
        monthlyPaymentOwnership = checkIfPercentNull(
          applicantObj.Loan_Calculation_Applicant_Products__r[0]
            .Monthly_Payment_Ownership_Number__c
        );
        totalMonthlyLoanPayment = checkIfNull(
          applicantObj.Loan_Calculation_Applicant_Products__r[0]
            .Loan_Calculation_Product_Id__r.Total_Monthly_Loan_Payment_Number__c
        );
        applicantAllotedAmountFromProposedLoan =
          monthlyPaymentOwnership * totalMonthlyLoanPayment;
      }
      if (assetsIdSet.size() > 0) {
        List<FinServ__AssetsAndLiabilities__c> assetsList = [
          SELECT
            id,
            Address__c,
            Percent_Ownership__c,
            Total_Market_Value__c,
            Property_Type__c,
            Lien_on_Asset__c,
            Lender__c,
            Loan_Balance_Prior__c,
            Percent_Applicant_Portion__c,
            Monthly_Payment_Prior__c,
            Loan_Repaid_from_Facility__c,
            Monthly_Payment__c,
            Loan_Balance_After__c,
            Vehicle_Details__c,
            Description_of_Asset__c,
            Financial_Institution__c,
            Type_of_Card__c,
            Asset_Credit_Limit__c,
            Average_Monthly_Usage__c,
            Asset_Credit_Balance__c,
            Minimum_Payment__c,
            Asset_Credit_Balance_After__c,
            Minimum_Payment_After__c,
            Type_of_Account__c,
            Overdraft_Limit__c,
            Monthly_Savings_Investment__c,
            Monthly_Saving_Investment_after_Loan__c,
            Policy_Number__c,
            Cash_Value__c,
            Sum_Insured__c,
            Annual_Premium__c,
            Pension_Scheme__c,
            Total_Contributions_to_Date__c,
            Monthly_Contribution_Before_Loan__c,
            Monthly_Contribution_After_Loan__c,
            RecordTypeId,
            Type_of_Loan__c,
            Treatment_of_Credit__c
          FROM FinServ__AssetsAndLiabilities__c
          WHERE Id IN :assetsIdSet
        ];

        if (assetsList.size() > 0) {
          assetsCalculations(assetsList);
        }
      }
    }
  }

  private class ApplicantWrapper {
    public Decimal salaryAndAllownce { get; set; }
    public Decimal gratutyInLieu { get; set; }
    public Decimal performanceBasedPay { get; set; }
    public Decimal netProfit { get; set; }
    public Decimal directorsEmoluments { get; set; }
    public Decimal shareOfPartnershipProfit { get; set; }
    public Decimal shareOfShareholderProfit { get; set; }
    public Decimal realEstateRental_I { get; set; }
    public Decimal realEstateRental_II { get; set; }

    ApplicantWrapper(Applicant__c applicantObj) {
      this.salaryAndAllownce = checkIfNull(
        applicantObj.Salary_and_Allowances_as_per_pay_slips__c
      );
      this.gratutyInLieu = checkIfNull(
        applicantObj.Gratuity_in_lieu_of_Pension__c
      );
      this.performanceBasedPay = checkIfNull(
        applicantObj.Performance_Based_PayC__c
      );
      this.netProfit = checkIfNull(applicantObj.Net_Profit_Sole_Trader__c);
      this.directorsEmoluments = checkIfNull(
        applicantObj.Director_s_Emoluments_Director__c
      );
      this.shareOfPartnershipProfit = checkIfNull(
        applicantObj.Share_of_Profit_Partnership__c
      );
      this.shareOfShareholderProfit = checkIfNull(
        applicantObj.Share_of_Profit_Shareholder__c
      );
      this.realEstateRental_I = checkIfNull(
        applicantObj.Existing_Real_Estate_Rental_I__c
      );
      this.realEstateRental_II = checkIfNull(
        applicantObj.Existing_Real_estate_Rental_II__c
      );
    }
  }

  private class ApplicantWrapperClass {
    public Decimal incomeRegularEmployed { get; set; }
    public Decimal incomePerformanceBased { get; set; }
    public Decimal incomeSelfEmployed { get; set; }
    public Decimal inflowsRealEstateIncome { get; set; }
    public Decimal inflowsTotalMonthlyIncome { get; set; }
    public Decimal inflowsLessStatutoryDeduction { get; set; }
    public Decimal totalInflows { get; set; }
    public Decimal outflowsPropertyRelatedCostPrior { get; set; }
    public Decimal outflowsPropertyRelatedCostAfter { get; set; }
    public Decimal outflowsPersonalCostPrior { get; set; }
    public Decimal outflowsPersonalCostAfter { get; set; }
    public Decimal outflowsUtilityExpencesPrior { get; set; }
    public Decimal outflowsUtilityExpencesAfter { get; set; }
    public Decimal outflowsTransportExpencesPrior { get; set; }
    public Decimal outflowsTransportExpencesAfter { get; set; }
    public Decimal totalOutflowbefore { get; set; }
    public Decimal totalOutflowAfter { get; set; }
    public Decimal recidualIncomeAfterCommitments { get; set; }
    public ApplicantWrapper appWrapper { get; set; }
    applicantWrapperClass(ApplicantWrapper wrapper, Applicant__c applicantObj) {
      this.appWrapper = wrapper;
      this.incomeRegularEmployed =
        wrapper.salaryAndAllownce + wrapper.gratutyInLieu;

      this.incomePerformanceBased = wrapper.performanceBasedPay;

      this.incomeSelfEmployed =
        wrapper.netProfit +
        wrapper.directorsEmoluments +
        wrapper.shareOfPartnershipProfit +
        wrapper.shareOfShareholderProfit;

      this.inflowsRealEstateIncome =
        checkIfNull(applicantObj.Ownership_Real_Estate_Rental__c) *
        wrapper.realEstateRental_I +
        checkIfNull(applicantObj.Ownership_Real_Estate_Rental_II__c) *
        wrapper.realEstateRental_II;

      this.inflowsTotalMonthlyIncome =
        wrapper.salaryAndAllownce +
        wrapper.gratutyInLieu +
        wrapper.performanceBasedPay +
        wrapper.netProfit +
        wrapper.directorsEmoluments +
        wrapper.shareOfPartnershipProfit +
        wrapper.shareOfShareholderProfit +
        wrapper.realEstateRental_I +
        wrapper.realEstateRental_II +
        (applicantObj.Pension__c <> null ? applicantObj.Pension__c : 0);

      this.inflowsLessStatutoryDeduction =
        checkIfNull(
          applicantObj.Income_Tax_Monthly_Payment_Prior_Loan__c <> null
            ? applicantObj.Income_Tax_Monthly_Payment_Prior_Loan__c
            : 0
        ) +
        checkIfNull(
          applicantObj.NIS_Contribution_Monthly_Prior_Loan__c <> null
            ? applicantObj.NIS_Contribution_Monthly_Prior_Loan__c
            : 0
        ) +
        checkIfNull(
          applicantObj.NHT_Contributions_Monthly_Prior_Loan__c <> null
            ? applicantObj.NHT_Contributions_Monthly_Prior_Loan__c
            : 0
        ) +
        checkIfNull(
          applicantObj.Education_Tax_Monthly_Prior_Loan__c <> null
            ? applicantObj.Education_Tax_Monthly_Prior_Loan__c
            : 0
        );

      this.totalInflows =
        this.inflowsTotalMonthlyIncome - this.inflowsLessStatutoryDeduction;

      this.outflowsPropertyRelatedCostPrior =
        checkIfNull(applicantObj.Rent_Board_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Strata_Maintenance_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Property_Tax_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Property_Insurance_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Property_Maintenance_Monthly_Prior_loan__c);

      this.outflowsPropertyRelatedCostAfter =
        checkIfNull(applicantObj.Rent_Board_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Strata_Maintenance_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Property_Tax_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Property_Insurance_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Property_Maintenance_Monthly_After_Loan__c);

      this.outflowsPersonalCostPrior =
        checkIfNull(applicantObj.Personal_Expenses_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Food_Cost_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Child_Care_Costs_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.School_Costs_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Health_Costs_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Other_Personal_Family_Costs_Prior_After__c);

      this.outflowsPersonalCostAfter =
        checkIfNull(applicantObj.Food_Costs_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Personal_Expenses_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Child_Care_Costs_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.School_Costs_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Health_Costs_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Other_Personal_Family_Costs_Prior_After__c);

      this.outflowsUtilityExpencesPrior =
        checkIfNull(applicantObj.Electricity_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Cell_Phone_Landline_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Water_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Internet_Cable_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Cooking_Gas_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.House_Keeping_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Other_Utilities_Monthly_Prior_Loan__c);

      this.outflowsUtilityExpencesAfter =
        checkIfNull(applicantObj.Electricity_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Cell_Phone_Landline_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Water_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Internet_Cable_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Cooking_Gas_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.House_Keeping_Costs_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Other_Utilities_Monthly_After_Loan__c);

      this.outflowsTransportExpencesPrior =
        checkIfNull(applicantObj.Fares_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Petrol_Fuel_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Toll_Fees_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Motor_V_Insurance_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Motor_Vehicle_Reg_Monthly_Prior_Loan__c) +
        checkIfNull(applicantObj.Motor_V_Maintenance_Monthly_Before_Loan__c) +
        checkIfNull(applicantObj.Other_Transport_Costs_Monthly_Prior_Loan__c);

      this.outflowsTransportExpencesAfter =
        checkIfNull(applicantObj.Fares_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Petrol_Fuel_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Toll_Fees_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Motor_V_Insurance_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Motor_Vehicle_Reg_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Motor_V_Maintenance_Monthly_After_Loan__c) +
        checkIfNull(applicantObj.Other_Transport_Monthly_After_Loan__c);

      this.totalOutflowbefore =
        this.outflowsPropertyRelatedCostPrior +
        this.outflowsPersonalCostPrior +
        this.outflowsUtilityExpencesPrior +
        this.outflowsTransportExpencesPrior;

      this.totalOutflowbefore =
        this.outflowsPropertyRelatedCostAfter +
        this.outflowsPersonalCostAfter +
        this.outflowsUtilityExpencesAfter +
        this.outflowsTransportExpencesAfter;

      this.recidualIncomeAfterCommitments =
        this.totalInflows - this.totalOutflowbefore;
    }
  }

  public class RealEstateWrapper {
    public String details { get; set; }
    public Decimal marketvalue { get; set; }
    public String lender { get; set; }
    public Decimal loanBalanceBefore { get; set; }
    public Decimal loanBalanceAfter { get; set; }
    public Decimal monthlyPaymentBefore { get; set; }
    public Decimal monthlyPaymentAfter { get; set; }
    StatementOfAffairsFormController soa;
    public RealEstateWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.details = asset.Address__c;
      this.marketvalue =
        asset.Percent_Ownership__c * asset.Total_Market_Value__c;
      if (asset.Lien_on_Asset__c) {
        this.monthlyPaymentBefore =
          asset.Percent_Applicant_Portion__c * asset.Monthly_Payment_Prior__c;
        this.loanBalanceBefore =
          asset.Percent_Ownership__c * asset.Loan_Balance_Prior__c;
        if (asset.Treatment_of_Credit__c == 'Will Remain') {
          this.monthlyPaymentAfter =
            asset.Percent_Applicant_Portion__c * asset.Monthly_Payment__c;
          this.loanBalanceAfter =
            asset.Percent_Ownership__c * asset.Loan_Balance_After__c;
        } else if (asset.Treatment_of_Credit__c == 'Close facility') {
          this.monthlyPaymentAfter = 0.0;
          this.loanBalanceAfter = 0.0;
        }
      } else {
        this.monthlyPaymentBefore = 0.0;
        this.loanBalanceBefore = 0.0;
        this.monthlyPaymentAfter = 0.0;
        this.loanBalanceAfter = 0.0;
      }
      this.soa.realEstateSummaryBefore += this.monthlyPaymentBefore;
      this.soa.realEstateSummaryBefore_Loan += this.loanBalanceBefore;

      this.soa.realEstateSummaryAfter += this.monthlyPaymentAfter;
      this.soa.realEstateSummaryAfter_Loan += this.loanBalanceAfter;
    }
  }
  public class MotorVehicalWrapper {
    public String details { get; set; }
    public Decimal marketvalue { get; set; }
    public String lender { get; set; }
    public Decimal loanBalanceBefore { get; set; }
    public Decimal loanBalanceAfter { get; set; }
    public Decimal monthlyPaymentBefore { get; set; }
    public Decimal monthlyPaymentAfter { get; set; }
    StatementOfAffairsFormController soa;
    public MotorVehicalWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.details = asset.Vehicle_Details__c;
      this.marketvalue =
        asset.Percent_Ownership__c * asset.Total_Market_Value__c;
      if (asset.Lien_on_Asset__c) {
        this.monthlyPaymentBefore =
          asset.Percent_Applicant_Portion__c * asset.Monthly_Payment_Prior__c;
        this.loanBalanceBefore =
          asset.Percent_Ownership__c * asset.Loan_Balance_Prior__c;
        if (asset.Treatment_of_Credit__c == 'Will Remain') {
          this.monthlyPaymentAfter =
            asset.Percent_Applicant_Portion__c * asset.Monthly_Payment__c;
          this.loanBalanceAfter =
            asset.Percent_Ownership__c * asset.Loan_Balance_After__c;
        } else if (asset.Treatment_of_Credit__c == 'Close facility') {
          this.monthlyPaymentAfter = 0.0;
          this.loanBalanceAfter = 0.0;
        }
      } else {
        this.monthlyPaymentBefore = 0.0;
        this.loanBalanceBefore = 0.0;
        this.monthlyPaymentAfter = 0.0;
        this.loanBalanceAfter = 0.0;
      }
      this.soa.MotorVehicalSummaryBefore += this.monthlyPaymentBefore;
      this.soa.MotorVehicalSummaryBefore_Loan += this.loanBalanceBefore;

      this.soa.MotorVehicalSummaryAfter += this.monthlyPaymentAfter;
      this.soa.MotorVehicalSummaryAfter_Loan += this.loanBalanceAfter;
    }
  }
  public class OtherAssetsWrapper {
    public String details { get; set; }
    public Decimal marketvalue { get; set; }
    public String lender { get; set; }
    public Decimal loanBalanceBefore { get; set; }
    public Decimal loanBalanceAfter { get; set; }
    public Decimal monthlyPaymentBefore { get; set; }
    public Decimal monthlyPaymentAfter { get; set; }
    StatementOfAffairsFormController soa;
    public OtherAssetsWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.details = asset.Description_of_Asset__c;
      this.marketvalue =
        asset.Percent_Ownership__c * asset.Total_Market_Value__c;
      this.lender = asset.Lender__c;
      if (asset.Lien_on_Asset__c) {
        this.monthlyPaymentBefore =
          asset.Percent_Applicant_Portion__c * asset.Monthly_Payment_Prior__c;
        this.loanBalanceBefore =
          asset.Percent_Ownership__c * asset.Loan_Balance_Prior__c;
        if (asset.Treatment_of_Credit__c == 'Will Remain') {
          this.monthlyPaymentAfter =
            asset.Percent_Applicant_Portion__c * asset.Monthly_Payment__c;
          this.loanBalanceAfter =
            asset.Percent_Ownership__c * asset.Loan_Balance_After__c;
        } else if (asset.Treatment_of_Credit__c == 'Close facility') {
          this.monthlyPaymentAfter = 0.0;
          this.loanBalanceAfter = 0.0;
        }
      } else {
        this.monthlyPaymentBefore = 0.0;
        this.loanBalanceBefore = 0.0;
        this.monthlyPaymentAfter = 0.0;
        this.loanBalanceAfter = 0.0;
      }
      this.soa.OtherAssetsSummaryBefore += this.monthlyPaymentBefore;
      this.soa.OtherAssetsSummaryBefore_Loan += this.loanBalanceBefore;

      this.soa.OtherAssetsSummaryAfter += this.monthlyPaymentAfter;
      this.soa.OtherAssetsSummaryAfter_Loan += this.loanBalanceAfter;
    }
  }
  public class OtherLoansWrapper {
    public String details { get; set; }
    public Decimal loanBalanceBefore { get; set; }
    public Decimal loanBalanceAfter { get; set; }
    public Decimal monthlyPaymentBefore { get; set; }
    public Decimal monthlyPaymentAfter { get; set; }
    StatementOfAffairsFormController soa;
    public OtherLoansWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.details = asset.Financial_Institution__c;
      this.monthlyPaymentBefore =
        asset.Percent_Applicant_Portion__c * asset.Monthly_Payment_Prior__c;
      this.loanBalanceBefore =
        asset.Percent_Ownership__c * asset.Loan_Balance_Prior__c;
      if (asset.Type_of_Loan__c == 'Unsecured') {
        if (asset.Treatment_of_Credit__c == 'Will Remain') {
          this.monthlyPaymentAfter =
            asset.Percent_Applicant_Portion__c * asset.Monthly_Payment__c +
            this.soa.applicantAllotedAmountFromProposedLoan;
          this.loanBalanceAfter =
            asset.Percent_Ownership__c * asset.Loan_Balance_After__c +
            this.soa.applicantAllotedAmountFromProposedLoan;
        } else if (asset.Treatment_of_Credit__c == 'Close facility') {
          this.monthlyPaymentAfter = 0.0;
          this.loanBalanceAfter = 0.0;
        }
      } else if (asset.Type_of_Loan__c == 'Cash-Secured') {
        this.monthlyPaymentAfter =
          asset.Percent_Applicant_Portion__c * asset.Monthly_Payment__c;
        this.loanBalanceAfter =
          asset.Percent_Ownership__c * asset.Loan_Balance_After__c;
        if (asset.Treatment_of_Credit__c == 'Close facility') {
          this.monthlyPaymentAfter = 0.0;
          this.loanBalanceAfter = 0.0;
        }
      }
      this.soa.OtherLoanSummaryBefore_Loan += checkIfNull(
        this.loanBalanceBefore
      );
      this.soa.OtherLoanSummaryAfter_Loan += checkIfNull(this.loanBalanceAfter);
    }
  }
  public class CreditCardWrapper {
    public String finacialInstitution { get; set; }
    public String cardType { get; set; }
    public Decimal creditLimit { get; set; }
    public Decimal avgLimit { get; set; }
    public Decimal creditCardBalance_before { get; set; }
    public Decimal creditCardBalance_After { get; set; }
    public Decimal minimumPayment_before { get; set; }
    public Decimal minimumPayment_After { get; set; }
    StatementOfAffairsFormController soa;
    public CreditCardWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.finacialInstitution = asset.Financial_Institution__c;
      this.cardType = asset.Type_of_Card__c;
      this.creditLimit = asset.Asset_Credit_Limit__c;
      this.avgLimit = asset.Average_Monthly_Usage__c;
      this.creditCardBalance_before = asset.Asset_Credit_Balance__c;
      this.minimumPayment_before = asset.Minimum_Payment__c;

      this.minimumPayment_After = asset.Minimum_Payment_After__c;
      if (asset.Treatment_of_Credit__c == 'Will Remain') {
        this.creditCardBalance_After = asset.Asset_Credit_Balance_After__c;
      } else if (asset.Treatment_of_Credit__c == 'Close facility') {
        this.creditCardBalance_After = 0.0;
      } else {
        this.creditCardBalance_After = 0.0;
      }
      this.soa.ccAndLocBalance_Before += this.creditCardBalance_before;
      this.soa.ccAndLocBalance_After += this.creditCardBalance_After;
    }
  }
  public class LineOfCreditWrapper {
    public String finacialInstitution { get; set; }
    public String cardType { get; set; }
    public Decimal creditLimit { get; set; }
    public Decimal avgLimit { get; set; }
    public Decimal creditCardBalance_before { get; set; }
    public Decimal creditCardBalance_After { get; set; }
    public Decimal minimumPayment_before { get; set; }
    public Decimal minimumPayment_After { get; set; }
    StatementOfAffairsFormController soa;
    public LineOfCreditWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.finacialInstitution = asset.Financial_Institution__c;
      this.cardType = asset.Type_of_Card__c;
      this.creditLimit = asset.Asset_Credit_Limit__c;
      this.avgLimit = asset.Average_Monthly_Usage__c;
      this.creditCardBalance_before = asset.Asset_Credit_Balance__c;
      this.minimumPayment_before = asset.Minimum_Payment__c;
      this.minimumPayment_After = asset.Minimum_Payment_After__c;
      if (asset.Treatment_of_Credit__c == 'Will Remain') {
        this.creditCardBalance_After = asset.Asset_Credit_Balance_After__c;
      } else if (asset.Treatment_of_Credit__c == 'Close facility') {
        this.creditCardBalance_After = 0.0;
      } else {
        this.creditCardBalance_After = 0.0;
      }
      this.soa.ccAndLocBalance_Before += this.creditCardBalance_before;
      this.soa.ccAndLocBalance_After += this.creditCardBalance_After;
    }
  }
  public class SavingsAccountWrapper {
    public String finacialInstitution { get; set; }
    public String accountType { get; set; }
    public Decimal balance { get; set; }
    public Decimal overdraftLimit { get; set; }
    public Decimal investment_before { get; set; }
    public Decimal investment_after { get; set; }
    StatementOfAffairsFormController soa;
    public SavingsAccountWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.finacialInstitution = asset.Financial_Institution__c;
      this.accountType = asset.Type_of_Account__c;
      this.balance = asset.Average_Monthly_Usage__c;
      this.overdraftLimit = asset.Overdraft_Limit__c;
      this.investment_before = asset.Monthly_Savings_Investment__c;
      this.investment_after = asset.Monthly_Saving_Investment_after_Loan__c;
      this.soa.currentAccountOverdraft_Before += checkIfNull(
        this.overdraftLimit
      );
      this.soa.currentAccountOverdraft_After += checkIfNull(
        this.overdraftLimit
      );

      this.soa.savingsAccountBalance_Before += checkIfNull(this.balance);
      this.soa.savingsAccountBalance_After += checkIfNull(this.balance);
    }
  }
  public class LifeInsuranceWrapper {
    public String finacialInstitution { get; set; }
    public Decimal policyNumber { get; set; }
    public Decimal cashValue { get; set; }
    public Decimal sumInsured { get; set; }
    public Decimal annualPremium { get; set; }
    StatementOfAffairsFormController soa;
    public LifeInsuranceWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.finacialInstitution = asset.Financial_Institution__c;
      this.policyNumber = asset.Policy_Number__c;
      this.cashValue = asset.Cash_Value__c;
      this.sumInsured = asset.Sum_Insured__c;
      this.annualPremium = asset.Annual_Premium__c;
      this.soa.lifeInsurance_Before += checkIfNull(this.cashValue);
      this.soa.lifeInsurance_After += checkIfNull(this.cashValue);
    }
  }
  public class PensionContributionWrapper {
    public String pensionScheme { get; set; }
    public Decimal contributionToDate { get; set; }
    public Decimal montlyContribution_before { get; set; }
    public Decimal montlyContribution_After { get; set; }
    StatementOfAffairsFormController soa;
    public PensionContributionWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.pensionScheme = asset.Pension_Scheme__c;
      this.contributionToDate = asset.Total_Contributions_to_Date__c;
      this.montlyContribution_before = asset.Monthly_Contribution_Before_Loan__c;
      this.montlyContribution_After = asset.Monthly_Contribution_After_Loan__c;
      this.soa.PensionContribution_Before = checkIfNull(
        this.contributionToDate
      );
      this.soa.PensionContribution_After = checkIfNull(this.contributionToDate);
    }
  }
  public class LiabilitiesWrapper {
    public String details { get; set; }
    public Decimal valueOfDebtBefore { get; set; }
    public Decimal valueOfDebtAfter { get; set; }
    public Decimal monthlyPaymentBefore { get; set; }
    public Decimal monthlyPaymentAfter { get; set; }
    StatementOfAffairsFormController soa;
    public LiabilitiesWrapper(
      FinServ__AssetsAndLiabilities__c asset,
      StatementOfAffairsFormController soa
    ) {
      this.soa = soa;
      this.details = asset.Financial_Institution__c;
      this.monthlyPaymentBefore =
        (checkIfPercentNull(asset.Percent_Applicant_Portion__c) / 100) *
        asset.Monthly_Payment_Prior__c;
      this.valueOfDebtBefore =
        (checkIfPercentNull(asset.Percent_Ownership__c) / 100) *
        asset.Loan_Balance_Prior__c;
      if (asset.Type_of_Loan__c == 'Unsecured') {
        if (asset.Treatment_of_Credit__c == 'Will Remain') {
          this.monthlyPaymentAfter =
            asset.Percent_Applicant_Portion__c * asset.Monthly_Payment__c +
            this.soa.applicantAllotedAmountFromProposedLoan;
          this.valueOfDebtAfter =
            asset.Percent_Ownership__c * asset.Loan_Balance_After__c +
            this.soa.applicantAllotedAmountFromProposedLoan;
        } else if (asset.Treatment_of_Credit__c == 'Close facility') {
          this.monthlyPaymentAfter = 0.0;
          this.valueOfDebtAfter = 0.0;
        }
      } else if (asset.Type_of_Loan__c == 'Cash-Secured') {
        this.monthlyPaymentAfter =
          asset.Percent_Applicant_Portion__c * asset.Monthly_Payment__c;
        this.valueOfDebtAfter =
          asset.Percent_Ownership__c * asset.Loan_Balance_After__c;
        if (asset.Treatment_of_Credit__c == 'Close facility') {
          this.monthlyPaymentAfter = 0.0;
          this.valueOfDebtAfter = 0.0;
        }
      }
      this.soa.contigentLiabilitiesSummaryBefore += checkIfNull(
        this.valueOfDebtBefore
      );
      this.soa.contigentLiabilitiesSummaryAfter += checkIfNull(
        this.valueOfDebtAfter
      );
    }
  }

  public static Decimal checkIfNull(Decimal value) {
    return (value <> null ? value : 0.0);
  }

  public static Decimal checkIfPercentNull(Decimal value) {
    return (value <> null ? value : 100.0);
  }
  public void assetsCalculations(
    List<FinServ__AssetsAndLiabilities__c> assetsList
  ) {
    realEstateWrapperList = new List<RealEstateWrapper>();
    motorVehicalWrapperList = new List<MotorVehicalWrapper>();
    otherAssetsWrapperList = new List<OtherAssetsWrapper>();
    otherLoanWrapperList = new List<OtherLoansWrapper>();
    creditCardWrapperList = new List<CreditCardWrapper>();
    lineOfCreditWrapperList = new List<LineOfCreditWrapper>();
    savingsAccountWrapperList = new List<SavingsAccountWrapper>();
    lifeInsuranceWrapperList = new List<LifeInsuranceWrapper>();
    pensionWrapperList = new List<PensionContributionWrapper>();
    liabilitiesWrapperList = new List<LiabilitiesWrapper>();
    for (FinServ__AssetsAndLiabilities__c asset : assetsList) {
      if (recordTypesMap.get('Real_Estate') == asset.RecordTypeId) {
        realEstateWrapperList.add(new RealEstateWrapper(asset, this));
      } else if (recordTypesMap.get('Motor_Vehicle') == asset.RecordTypeId) {
        motorVehicalWrapperList.add(new MotorVehicalWrapper(asset, this));
      } else if (recordTypesMap.get('Other_Assets') == asset.RecordTypeId) {
        otherAssetsWrapperList.add(new OtherAssetsWrapper(asset, this));
      } else if (recordTypesMap.get('Other_Loans') == asset.RecordTypeId) {
        otherLoanWrapperList.add(new OtherLoansWrapper(asset, this));
      } else if (recordTypesMap.get('Credit_Cards') == asset.RecordTypeId) {
        creditCardWrapperList.add(new CreditCardWrapper(asset, this));
      } else if (recordTypesMap.get('Lines_of_Credit') == asset.RecordTypeId) {
        lineOfCreditWrapperList.add(new LineOfCreditWrapper(asset, this));
      } else if (
        recordTypesMap.get('Savings_Current_Accounts_Investments') ==
        asset.RecordTypeId
      ) {
        savingsAccountWrapperList.add(new SavingsAccountWrapper(asset, this));
      } else if (
        recordTypesMap.get('Life_Insurance_Policies') == asset.RecordTypeId
      ) {
        lifeInsuranceWrapperList.add(new LifeInsuranceWrapper(asset, this));
      } else if (
        recordTypesMap.get('Pension_Contributions_or_Individual') ==
        asset.RecordTypeId
      ) {
        pensionWrapperList.add(new PensionContributionWrapper(asset, this));
      } else if (recordTypesMap.get('Liability') == asset.RecordTypeId) {
        liabilitiesWrapperList.add(new LiabilitiesWrapper(asset, this));
      }
    }
    this.totalAssets_before =
      this.realEstateSummaryBefore +
      this.MotorVehicalSummaryBefore +
      this.OtherAssetsSummaryBefore +
      this.lifeInsurance_Before +
      this.PensionContribution_Before;
    this.totalAssets_after =
      this.realEstateSummaryAfter +
      this.MotorVehicalSummaryAfter +
      this.OtherAssetsSummaryAfter +
      this.lifeInsurance_After +
      this.PensionContribution_After;
    this.totalLiabilities_before =
      this.realEstateSummaryBefore_Loan +
      this.MotorVehicalSummaryBefore_Loan +
      this.OtherAssetsSummaryBefore_Loan +
      this.contigentLiabilitiesSummaryBefore +
      this.OtherLoanSummaryBefore_Loan +
      this.currentAccountOverdraft_Before +
      this.ccAndLocBalance_Before;
    this.totalLiabilities_after =
      this.realEstateSummaryAfter_Loan +
      this.MotorVehicalSummaryAfter_Loan +
      this.OtherAssetsSummaryAfter_Loan +
      this.contigentLiabilitiesSummaryAfter +
      this.OtherLoanSummaryAfter_Loan +
      this.currentAccountOverdraft_After +
      this.ccAndLocBalance_After;

    this.netWorth_Before =
      this.totalAssets_before - this.totalLiabilities_before;
    this.netWorth_After = this.totalAssets_after - this.totalLiabilities_after;
  }
}
