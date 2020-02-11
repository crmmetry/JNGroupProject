public class PDFGeneratorController {
    public String PDFData {get; set;} 
    public String recordId {get; set;}
    public Opportunity thisOpportunity {get; set;}
    public Integer assetsSize {set; get;}
    public List<FinServ__AssetsAndLiabilities__c> assets {get; set;}
    public Application_Asset_Liability__c[]  applicantAssetLiabilities {get; set;}
    Map<String, Decimal> recordTypeAccumPior = new Map<String, Decimal>(); //for record types
    Map<String, Decimal> recordTypeAccumAfter = new Map<String, Decimal>(); //for record types
    public  Applicant__c applicant {get; set;}
    public Decimal realEstateBefore {set;get {if(realEstateBefore == null) return  0.0;else return realEstateBefore; }}
    public Decimal realEstateAfter {set;get {if(realEstateAfter == null) return  0.0;else return realEstateAfter; }}
    
    public Decimal realEstateSumBoth {set;get {if(realEstateSumBoth == null) return  0.0;else return realEstateSumBoth; }}
    public Decimal motorVehicleAfter {set;get {if(motorVehicleAfter == null) return  0.0;else return motorVehicleAfter; }}
    public Decimal motorVehicleBefore {set;get {if(motorVehicleBefore == null) return  0.0;else return motorVehicleBefore; }}
    public Decimal otherAssetBefore {set;get {if(otherAssetBefore == null) return  0.0;else return otherAssetBefore; }}
    public Decimal otherAssetAfter {set;get {if(otherAssetAfter == null) return  0.0;else return otherAssetAfter; }}
    public Decimal lifeInsuranceBefore {set;get {if(lifeInsuranceBefore == null) return  0.0;else return lifeInsuranceBefore; }}
    public Decimal lifeInsuranceAfter {set;get {if(lifeInsuranceAfter == null) return  0.0;else return lifeInsuranceAfter; }}
    
    public Decimal  savingsBefore {set;get {if(savingsBefore == null) return  0.0;else return savingsBefore; }}
    public Decimal  savingsAfter {set;get {if(savingsAfter == null) return  0.0;else return savingsAfter; }}
    public Decimal  pensionBefore {set;get {if(pensionBefore == null) return  0.0;else return pensionBefore; }}
    public Decimal  pensionAfter {set;get {if(pensionAfter == null) return  0.0;else return pensionAfter; }}
    
    public Decimal loanRealEstateBefore {set;get {if(loanRealEstateBefore == null) return  0.0;else return loanRealEstateBefore; }}
    public Decimal loanMotorVehicleAfter {set;get {if(loanMotorVehicleAfter == null) return  0.0;else return loanMotorVehicleAfter; }}
    public Decimal loanMotorVehicleBefore {set;get {if(loanMotorVehicleBefore == null) return  0.0;else return loanMotorVehicleBefore; }}
    public Decimal loanOtherAssetAfter {set;get {if(loanOtherAssetAfter == null) return  0.0;else return loanOtherAssetAfter; }}
    public Decimal loanOtherAssetBefore {set;get {if(loanOtherAssetBefore == null) return  0.0;else return loanOtherAssetBefore; }}
    public Decimal otherLoansBefore {set;get {if(otherLoansBefore == null) return  0.0;else return otherLoansBefore; }}
    public Decimal loanCreditCardBefore {set;get {if(loanCreditCardBefore == null) return  0.0;else return loanCreditCardBefore; }}
    public Decimal loanCurrentAccountOverdraftBefore {set;get {if(loanCurrentAccountOverdraftBefore == null) return  0.0;else return loanCurrentAccountOverdraftBefore; }}
    
    public Decimal netWorthPrior {set;get {if(netWorthPrior == null) return  0.0;else return netWorthPrior; }}
    public Decimal netWorthAfter {set;get {if(netWorthAfter == null) return  0.0;else return netWorthAfter; }}
    public Decimal totalAssetsPrior {set;get {if(totalAssetsPrior == null) return  0.0;else return totalAssetsPrior; }}
    public Decimal totalAssetsAfter {set;get {if(totalAssetsAfter == null) return  0.0;else return totalAssetsAfter; }}
    public Decimal totalLiabilitiesAfter {set;get {if(totalLiabilitiesAfter == null) return  0.0;else return totalLiabilitiesAfter; }}
    public Decimal totalLiabilitiesPrior {set;get {if(totalLiabilitiesPrior == null) return  0.0;else return totalLiabilitiesPrior; }}
    
    public Decimal loanRealEstateAfter {set;get {if(loanRealEstateAfter == null) return  0.0;else return loanRealEstateAfter; }}
    public Decimal otherLoansAfter {set;get {if(otherLoansAfter == null) return  0.0;else return otherLoansAfter; }}
    public Decimal loanCreditCardAfter {set;get {if(loanCreditCardAfter == null) return  0.0;else return loanCreditCardAfter; }}
    public Decimal loanCurrentAccountOverdraftAfter {set;get {if(loanCurrentAccountOverdraftAfter == null) return  0.0;else return loanCurrentAccountOverdraftAfter; }}
    
    public Decimal incomeRegular {set;get {if(incomeRegular == null) return  0.0;else return incomeRegular; }}
    public Decimal incomePerformance {set;get {if(incomePerformance == null) return  0.0;else return incomePerformance; }}
    public Decimal incomeSelfEmployed {set;get {if(incomeSelfEmployed == null) return  0.0;else return incomeSelfEmployed; }}
    public Decimal incomeRental {set;get {if(incomeRental == null) return  0.0;else return incomeRental; }}
    public Decimal incomePension {set;get {if(incomePension == null) return  0.0;else return incomePension; }}
    public Decimal incomeOther {set;get {if(incomeOther == null) return  0.0;else return incomeOther; }}
    public Decimal totalGrossMontlyIncome {set;get {if(totalGrossMontlyIncome == null) return  0.0;else return totalGrossMontlyIncome; }}
    public Decimal lessStatutoryDeductions {set;get {if(lessStatutoryDeductions == null) return  0.0;else return lessStatutoryDeductions; }}
    public Decimal totalInflows {set;get {if(totalInflows == null) return  0.0;else return totalInflows; }}
    
    public Decimal installmentPayments {set;get {if(installmentPayments == null) return  0.0;else return installmentPayments; }}
    public Decimal lifeInsurancePayments {set;get {if(lifeInsurancePayments == null) return  0.0;else return lifeInsurancePayments; }}
    public Decimal savingsInvestments {set;get {if(savingsInvestments == null) return  0.0;else return savingsInvestments; }}
    public Decimal pensionContribution {set;get {if(pensionContribution == null) return  0.0;else return pensionContribution; }}
    public Decimal propertyRelatedCosts {set;get {if(propertyRelatedCosts == null) return  0.0;else return propertyRelatedCosts; }}
    public Decimal personalFamilyCosts {set;get {if(personalFamilyCosts == null) return  0.0;else return personalFamilyCosts; }}
    public Decimal utilitiesExpenses {set;get {if(utilitiesExpenses == null) return  0.0;else return utilitiesExpenses; }}
    public Decimal transportationCosts {set;get {if(transportationCosts == null) return  0.0;else return transportationCosts; }}
    
    public Decimal installmentPaymentsAfter {set;get {if(installmentPaymentsAfter == null) return  0.0;else return installmentPaymentsAfter; }}
    public Decimal lifeInsurancePaymentsAfter {set;get {if(lifeInsurancePaymentsAfter == null) return  0.0;else return lifeInsurancePaymentsAfter; }}
    public Decimal savingsInvestmentsAfter {set;get {if(savingsInvestmentsAfter == null) return  0.0;else return savingsInvestmentsAfter; }}
    public Decimal pensionContributionAfter {set;get {if(pensionContributionAfter == null) return  0.0;else return pensionContributionAfter; }}
    public Decimal propertyRelatedCostsAfter {set;get {if(propertyRelatedCostsAfter == null) return  0.0;else return propertyRelatedCostsAfter; }}
    public Decimal personalFamilyCostsAfter {set;get {if(personalFamilyCostsAfter == null) return  0.0;else return personalFamilyCostsAfter; }}
    public Decimal utilitiesExpensesAfter {set;get {if(utilitiesExpensesAfter == null) return  0.0;else return utilitiesExpensesAfter; }}
    public Decimal transportationCostsAfter {set;get {if(transportationCostsAfter == null) return  0.0;else return transportationCostsAfter; }}
    public Decimal totalOutflowsAfter {set;get {if(totalOutflowsAfter == null) return  0.0;else return totalOutflowsAfter; }}
    public Decimal totalOutflowsBefore {set;get {if(totalOutflowsBefore == null) return  0.0;else return totalOutflowsBefore; }}
    public Decimal residualIncomeAfterBeforeLoan {set;get {if(residualIncomeAfterBeforeLoan == null) return  0.0;else return residualIncomeAfterBeforeLoan; }}
    public Decimal residualIncomeAfterAfterLoan {set;get {if(residualIncomeAfterAfterLoan == null) return  0.0;else return residualIncomeAfterAfterLoan; }}
    
    public Loan_Calculator__c  loanCalculator{set;get;} 
    public String todayDate{set;get;}
    
    public List<FinServ__AssetsAndLiabilities__c> realEstateAssets {set;get;}
    public List<FinServ__AssetsAndLiabilities__c> motorVehicleAssets {set;get;}
    public List<FinServ__AssetsAndLiabilities__c> otherLoanAssets {set;get;}
    public List<FinServ__AssetsAndLiabilities__c> otherAssetsAssets {set;get;}
    public List<FinServ__AssetsAndLiabilities__c> pensionAssets {set;get;}
    public List<FinServ__AssetsAndLiabilities__c> creditCardAssets {set;get;}
    public List<FinServ__AssetsAndLiabilities__c> lineOfCreditAssets {set;get;}
    public List<FinServ__AssetsAndLiabilities__c> lifeInsuranceAssets {set;get;}
    public List<FinServ__AssetsAndLiabilities__c> savingsAssets {set;get;}
    
    public static String combinationString {set;get;}
    public static List<Application_Asset_Liability__c > applicantAssetsLiabilities {set;get;}
    public static String applicantNumber = '';
    public PDFGeneratorController(ApexPages.StandardController controller) {
        DateTime thisDate = Datetime.now();
        todayDate = thisDate.format('dd-MMM-yyyy');
        System.debug('Parameters: ' + ApexPages.currentPage().getParameters());
        if(ApexPages.currentPage().getParameters().containsKey('oppid')&&
           ApexPages.currentPage().getParameters().containsKey('appid')){
               recordId = ApexPages.currentPage().getParameters().get('oppid');
               Id applicantId = ApexPages.currentPage().getParameters().get('appid');
               applicantNumber = ApexPages.currentPage().getParameters().get('num');
               //(Opportunity)controller.getRecord();
               
               thisOpportunity = [SELECT Id,AccountId, Product_Details__c   from Opportunity where id = :recordId];
               
               Loan_Calculator__c[] productDetails = [SELECT Id, Market_Value_of_Vehicle__c, Total_Loan_Amount__c,
                                                      Monthly_Loan_Payment__c, Unsecured_Loan_Amount__c,App_3_Monthly_Payment_UL__c,
                                                      Unsecure_Monthly_Loan_Payment__c, Line_of_Credit_Starting_Limit__c,
                                                      Minimum_Payment_as_per_Credit_Limit__c ,Type_of_LOC__c,App_3_Monthly_Payment_A__c,
                                                      unsecure_Monthly_n_Loan_Savings__c , Monthly_Loan_Savings__c,App1_Loan_Amt_Alloc_UL__c,
                                                      App_3_Loan_Amount_A__c,App_2_Loan_Amount_A__c,Minimum_Payment__c ,
                                                      App_1_Loan_Amount_A__c,App_3_Min_Payment_LOC__c, App_1_Min_Payment__c,
                                                      App_2_Min_Payment_LOC__c, App1_Monthly_Payment_A__c, App_2_Monthly_Payment_A__c 
                                                      FROM Loan_Calculator__c WHERE Id =: thisOpportunity.Product_Details__c ];
               
               if(productDetails.size() > 0) {
                   loanCalculator = productDetails.get(0);
               } else {
                   loanCalculator = new Loan_Calculator__c();
               }
               applicant = [SELECT Id ,Applicable_sources_of_income__c, 
                            Salary_and_Allowances_as_per_pay_slips__c,
                            Gratuity_in_lieu_of_Pension__c,
                            Performance_Based_Pay_Includes_Commissi__c ,
                            Net_Profit_Sole_Trader__c,
                            Director_s_Emoluments_Director__c,
                            Share_of_Profit_Partnership__c,
                            Share_of_Profit_Shareholder__c,
                            Pension__c ,
                            Existing_Real_estate_Rental_II__c,
                            Existing_Real_Estate_Rental_I__c ,
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
                            PensionC__c,Account__r.Name,
                            Other_IncomeC__c ,Performance_Based_PayC__c,
                            Account__c, Existing_Real_Estate_Rental_IC__c,
                            Overdraft_Limit__c, Gross_Monthly_IncomeC__c 
                            from Applicant__c WHERE id = :applicantId];
               System.debug('Found applicant: ' + applicant.Id);
               System.debug('Found applicant Account: ' + applicant.Account__c);
               FinServ__AssetsAndLiabilities__c[]  assetsTemp = [SELECT Id,Loan_Balance_Prior__c ,
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
                                                                 Minimum_Payment__c ,
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
                                                                 from FinServ__AssetsAndLiabilities__c
                                                                 where FinServ__PrimaryOwner__c  = :applicant.Account__c];
               System.debug('Found Assets: ' + assetsTemp.size());
               if(assetsTemp.size() >0){
                   assets = assetsTemp;
               } else {
                   assets = new List<FinServ__AssetsAndLiabilities__c>();
               }
               System.debug('Assets ==> ' + assets);
               
               
               applicantAssetsLiabilities = [SELECT Id,
                                             Assets_and_Liabilities__r.RecordType.DeveloperName,
                                             Loan_Balance_Prior__c,Asset_Credit_Balance__c,Account_Balance_After__c,
                                             Loan_Balance_After__c ,Asset_Credit_Balance_After__c,Monthly_Payment_Prior__c,
                                             Assets_and_Liabilities__r.Id,Minimum_payment__c,Minimum_Payment_After__c , 
                                             Assets_and_Liabilities__r.Loan_Balance_Prior__c ,
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
                                             Assets_and_Liabilities__r.Minimum_Payment__c ,
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
                                             Monthly_Contribution_Before_Loan__c,Monthly_Contribution_After_Loan__c
                                             FROM Application_Asset_Liability__c 
                                             WHERE Application__c =:applicantId AND Application__r.Opportunity__c =:thisOpportunity.Id];
               System.debug('Found Applicant Assets: ' + applicantAssetsLiabilities.size());
               if(applicantAssetsLiabilities == null){
                   applicantAssetsLiabilities = new List<Application_Asset_Liability__c>();
               }
               addAssetLiaibilityRecords(assets);
               sumApplicantAssetsLiabilities(applicantAssetsLiabilities);
               netWorthPrior = totalAssetsPrior - totalLiabilitiesPrior;
               netWorthAfter = totalAssetsAfter - totalLiabilitiesAfter;
               sumUpAllMonthlyflows();
               String selection = MultiProductCalculatorController.getproductselection(recordId);
               setCombinations(selection);
           }
    }
    
    private static void setCombinations(String selection){
        switch on selection {
            when '1'{
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
    private Map<Id,RecordType> getRecordTypeMap(String sObjectType ){
        return new Map<Id, RecordType>([select Id,Name,DeveloperName 
                                        from RecordType where sobjecttype= :sObjectType]); 
    }
    private String getRecordTypeName(Id recordTypeId, String sObjectType){
        return getRecordTypeMap(sObjectType).get(recordTypeId).DeveloperName;
    }
    private Decimal convertValue(Object obj){
        String value = String.valueOf(obj);
        Decimal result = 0.0;
        if(value != null) {
            result = Decimal.valueOf(value);
        }
        return result;
    }
    
    public void sumApplicantAssetsLiabilities(List<Application_Asset_Liability__c> records){
        for(Application_Asset_Liability__c record: records){
            System.debug('Applicant record type: ' +record.Assets_and_Liabilities__r.RecordType.DeveloperName );
            System.debug('Applicant data convert: ' +convertValue(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c) );
            System.debug('Applicant data: ' +(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c) );
            switch on record.Assets_and_Liabilities__r.RecordType.DeveloperName {                    
                when 'Real_Estate' {
                    //Summary Assets and Liabilities - Assets Before Proposed assets
                    realEstateBefore += convertValue(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c);
                    realEstateAfter += convertValue(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c);
                    
                    //Summary Assets and Liabilities - Liabilities Before Proposed Loan
                    loanRealEstateBefore += convertValue(record.get('Loan_Balance_Prior__c')) 
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Ownership__c);
                    
                    loanRealEstateAfter += convertValue(record.get('Loan_Balance_After__c')) 
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Ownership__c);
                    
                    //infows & outflows
                    installmentPayments += convertValue(record.Monthly_Payment_Prior__c)* convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
                    installmentPaymentsAfter += convertValue(record.Assets_and_Liabilities__r.Monthly_Payment__c) 
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
                    
                }
                when 'Motor_Vehicle' {
                    //Summary Assets and Liabilities - Assets Before Proposed assets                        
                    motorVehicleBefore += convertValue(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c);                                       
                    motorVehicleAfter +=convertValue(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c) ;
                    
                    //Summary Assets and Liabilities - Liabilities Before Proposed Loan                    
                    loanMotorVehicleBefore += convertValue(record.get('Loan_Balance_Prior__c'))
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Ownership__c);
                    
                    loanMotorVehicleAfter += convertValue(record.get('Loan_Balance_After__c'))
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Ownership__c);
                    
                    installmentPayments += convertValue(record.Monthly_Payment_Prior__c)* convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
                    installmentPaymentsAfter += convertValue(record.Assets_and_Liabilities__r.Monthly_Payment__c)
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c)
                        + convertValue(loanCalculator.Monthly_Loan_Payment__c);
                    if(applicantNumber == '1') {
                        motorVehicleAfter+=convertValue(loanCalculator.Market_Value_of_Vehicle__c) + convertValue(loanCalculator.App_1_Loan_Amount_A__c);
                        installmentPaymentsAfter*= convertValue(loanCalculator.App1_Monthly_Payment_A__c);
                    } else if(applicantNumber == '2'){
                        motorVehicleAfter+=convertValue(loanCalculator.Market_Value_of_Vehicle__c) + convertValue(loanCalculator.App_2_Loan_Amount_A__c);
                        installmentPaymentsAfter*= convertValue(loanCalculator.App_2_Monthly_Payment_A__c );
                    } else {
                        motorVehicleAfter+=convertValue(loanCalculator.Market_Value_of_Vehicle__c) + convertValue(loanCalculator.App_3_Loan_Amount_A__c);
                        installmentPaymentsAfter*= convertValue(loanCalculator.App_3_Monthly_Payment_A__c );
                    }
                    
                }
                when 'Other_Assets' {
                    //Summary Assets and Liabilities - Assets Before Proposed assets
                    otherAssetBefore +=convertValue(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c);
                    otherAssetAfter += convertValue(record.Assets_and_Liabilities__r.Total_Market_Value_Calc__c);
                    
                    //Summary Assets and Liabilities - Liabilities Before Proposed loan
                    loanOtherAssetBefore += convertValue(record.get('Loan_Balance_Prior__c')) *
                        convertValue(record.Assets_and_Liabilities__r.Percent_Ownership__c);
                    
                    loanOtherAssetAfter += convertValue(record.get('Loan_Balance_After__c')) *
                        convertValue(record.Assets_and_Liabilities__r.Percent_Ownership__c);
                    
                    installmentPayments += convertValue(record.Monthly_Payment_Prior__c)* convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
                    installmentPaymentsAfter += convertValue(record.Assets_and_Liabilities__r.Monthly_Payment__c) 
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
                }
                when 'Other_Loans'{
                    //Summary Assets and Liabilities - Liabilities Before Proposed Loan
                    otherLoansBefore += convertValue(record.get('Loan_Balance_Prior__c')) * 
                        convertValue(record.Assets_and_Liabilities__r.Percent_Ownership__c);
                    
                    otherLoansAfter += convertValue(record.get('Loan_Balance_After__c')) * 
                        convertValue(record.Assets_and_Liabilities__r.Percent_Ownership__c);
                    
                    
                    
                    installmentPayments += convertValue(record.Monthly_Payment_Prior__c)* convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
                    installmentPaymentsAfter += convertValue(record.Assets_and_Liabilities__r.Monthly_Payment__c) 
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c)
                        + convertValue(loanCalculator.Unsecure_Monthly_Loan_Payment__c);
                    if(applicantNumber == '1') {
                        otherLoansAfter+=convertValue(loanCalculator.App1_Loan_Amt_Alloc_UL__c);
                        installmentPaymentsAfter *= convertValue(loanCalculator.App_1_Monthly_Payment_UL__c);
                    } else if(applicantNumber == '2') {
                        installmentPaymentsAfter *= convertValue(loanCalculator.App_2_Monthly_Payment_UL__c);
                    } else {
                        installmentPaymentsAfter *= convertValue(loanCalculator.App_3_Monthly_Payment_UL__c);
                    }
                }
                
                when 'Credit_Cards', 'Lines_of_Credit'{
                    //Summary Assets and Liabilities - Liabilities Before Proposed Loan
                    loanCreditCardBefore+=convertValue(record.get('Asset_Credit_Balance__c'));
                    loanCreditCardBefore+=convertValue(record.get('Asset_Credit_Balance_After__c'));
                    
                    installmentPayments += convertValue(record.Minimum_payment__c)* convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c);
                    
                    installmentPaymentsAfter += convertValue(record.get('Minimum_Payment_After__c')) 
                        * convertValue(record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c) +
                        convertValue(loanCalculator.Minimum_Payment__c);
                    if(applicantNumber == '1') {
                        
                        installmentPaymentsAfter *= convertValue(loanCalculator.App_1_Min_Payment__c  );
                    } else if(applicantNumber == '2') {
                        installmentPaymentsAfter *= convertValue(loanCalculator.App_2_Min_Payment_LOC__c );
                    } else {
                        installmentPaymentsAfter *= convertValue(loanCalculator.App_3_Min_Payment_LOC__c );
                    }
                }
                when 'Life_Insurance_Policies' {
                    //Summary Assets and Liabilities - Assets Before Proposed Loan
                    lifeInsuranceBefore += convertValue(record.Assets_and_Liabilities__r.Cash_Value__c);
                    lifeInsuranceAfter += convertValue(record.Assets_and_Liabilities__r.Cash_Value__c);
                    lifeInsurancePaymentsAfter+=convertValue(record.Assets_and_Liabilities__r.Annual_Premium__c);
                }
                when 'Savings_Current_Accounts_Investments' {
                    savingsAfter += convertValue(record.Assets_and_Liabilities__r.Account_Balance__c) + convertValue(record.Account_Balance_After__c);
                    savingsBefore += convertValue(record.Assets_and_Liabilities__r.Account_Balance__c);
                    
                    savingsInvestmentsAfter += convertValue(record.Assets_and_Liabilities__r.Monthly_Saving_Investment_after_Loan__c);
                }
                when 'Pension_Contributions_or_Individual' {
                    //Summary Assets and Liabilities - Assets Before Proposed assets
                    pensionBefore += convertValue(record.Assets_and_Liabilities__r.Total_Contributions_to_Date__c);
                    pensionAfter += convertValue(record.Assets_and_Liabilities__r.Total_Contributions_to_Date__c);
                    
                    pensionContribution += convertValue(record.get('Monthly_Contribution_Before_Loan__c'));
                    pensionContributionAfter += convertValue(record.get('Monthly_Contribution_After_Loan__c'));
                }
            }
            loanCurrentAccountOverdraftBefore += convertValue(record.Assets_and_Liabilities__r.Overdraft_Limit__c);    
            loanCurrentAccountOverdraftAfter += convertValue(record.Assets_and_Liabilities__r.Overdraft_Limit__c);    
            
        }
        //grand totals
        totalAssetsPrior+=pensionBefore+lifeInsuranceBefore+otherAssetBefore+loanMotorVehicleBefore+realEstateBefore+savingsBefore;
        totalAssetsAfter+=pensionAfter+lifeInsuranceAfter+otherAssetAfter+loanMotorVehicleAfter+realEstateAfter+savingsAfter;
        totalLiabilitiesPrior+=loanCurrentAccountOverdraftBefore+loanCreditCardBefore+otherLoansBefore+loanOtherAssetBefore+
            loanMotorVehicleBefore+loanRealEstateBefore;
        totalLiabilitiesAfter+=loanCreditCardAfter+otherLoansAfter+loanOtherAssetAfter+loanMotorVehicleAfter+realEstateAfter
            +loanCurrentAccountOverdraftAfter;
    }
    public void addAssetLiaibilityRecords(FinServ__AssetsAndLiabilities__c[] assets){
        String recordTypeId;
        String name;
        realEstateAssets = new List<FinServ__AssetsAndLiabilities__c>();
        motorVehicleAssets = new List<FinServ__AssetsAndLiabilities__c>();
        otherLoanAssets = new List<FinServ__AssetsAndLiabilities__c>();
        otherAssetsAssets  = new List<FinServ__AssetsAndLiabilities__c>();
        pensionAssets = new List<FinServ__AssetsAndLiabilities__c>();
        creditCardAssets = new List<FinServ__AssetsAndLiabilities__c>();
        lineOfCreditAssets = new List<FinServ__AssetsAndLiabilities__c>();
        lifeInsuranceAssets = new List<FinServ__AssetsAndLiabilities__c>();
        savingsAssets = new List<FinServ__AssetsAndLiabilities__c>();
        
        for(FinServ__AssetsAndLiabilities__c asset: assets) {
            name = getRecordTypeName(asset.RecordTypeId, 'FinServ__AssetsAndLiabilities__c');
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
                    lifeInsurancePayments += convertValue(asset.get('Annual_Premium__c'))/12;
                    
                }
                when 'Savings_Current_Accounts_Investments' {
                    savingsAssets.add(asset);
                    savingsInvestments += convertValue(asset.get('Monthly_Savings_Investment__c'));
                }
                when 'Pension_Contributions_or_Individual' {
                    pensionAssets.add(asset);                    
                    
                }
                when 'Other_Loans'{
                    otherLoanAssets.add(asset);
                }
                when 'Lines_of_Credit'{
                    lineOfCreditAssets.add(asset);
                }
                when 'Credit_Cards'{
                    creditCardAssets.add(asset);
                }
            }
            
        }
        
    }
    public void sumUpAllMonthlyflows(){
        
        incomeRegular = loanCurrentAccountOverdraftAfter = 
            convertValue(applicant.get('Salary_and_Allowances_as_per_pay_slips__c'))+
            convertValue(applicant.get('Gratuity_in_lieu_of_PensionC__c'));
        
        incomePerformance = convertValue(applicant.get('Performance_Based_PayC__c'));
        
        incomeSelfEmployed = 
            convertValue(applicant.get('Net_Profit_Sole_TraderC__c'))+
            convertValue(applicant.get('Director_s_Emoluments_DirectorC__c'))+
            convertValue(applicant.get('Share_of_Profit_PartnershipC__c'))+
            convertValue(applicant.get('Share_of_Profit_ShareholderC__c'));
        
        incomeRental = 
            convertValue(applicant.get('Projected_Real_Estate_RentalC__c'))+
            convertValue(applicant.get('Existing_Real_estate_Rental_II_C__c'))+
            convertValue(applicant.get('Existing_Real_Estate_Rental_IC__c'));
        
        incomePension = convertValue(applicant.get('PensionC__c'));
        
        incomeOther = convertValue(applicant.get('Other_IncomeC__c'));
        
        totalGrossMontlyIncome = convertValue(applicant.get('Gross_Monthly_IncomeC__c'));
        //incomeRegular + incomePerformance + incomeSelfEmployed + incomeRental + incomePension + incomeOther;
        
        lessStatutoryDeductions = 
            convertValue(applicant.get('Income_Tax_Monthly_Payment_Prior_Loan__c')) +
            convertValue(applicant.get('NIS_Contribution_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Education_Tax_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('NHT_Contributions_Monthly_Prior_Loan__c'));
        
        totalInflows = totalGrossMontlyIncome - lessStatutoryDeductions;
        
        
        propertyRelatedCosts = 
            convertValue(applicant.get('Property_Maintenance_Monthly_Prior_loan__c')) +
            convertValue(applicant.get('Property_Insurance_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Property_Tax_Monthly_Prior_Loan__c'));
        
        personalFamilyCosts = 
            convertValue(applicant.get('Personal_Expenses_Monthly_Prior_Loan__c')) +
            convertValue(applicant.get('Food_Cost_Monthly_Prior_Loan__c')) +
            convertValue(applicant.get('Child_Care_Costs_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('School_Costs_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Health_Costs_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Other_Personal_Family_Monthly_Prior_Loan__c'));
        
        utilitiesExpenses = 
            convertValue(applicant.get('Electricity_Monthly_Prior_Loan__c')) +
            convertValue(applicant.get('Water_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Cell_Phone_Landline_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Internet_Cable_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('House_Keeping_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Other_Utilities_Monthly_Prior_Loan__c'));
        
        transportationCosts = 
            convertValue(applicant.get('Fares_Monthly_Prior_Loan__c')) +
            convertValue(applicant.get('Petrol_Fuel_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Toll_Fees_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Motor_V_Insurance_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Motor_Vehicle_Reg_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Motor_Vehicle_Fitness_Monthly_Prior_Loan__c'))+
            convertValue(applicant.get('Motor_V_Maintenance_Monthly_Before_Loan__c'))+
            convertValue(applicant.get('Other_Transport_Costs_Monthly_Prior_Loan__c'));
        
        transportationCostsAfter = 
            convertValue(applicant.get('Other_Transport_Monthly_After_Loan__c')) +
            convertValue(applicant.get('Fares_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Petrol_Fuel_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Motor_V_Insurance_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Toll_Fees_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Motor_V_Insurance_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Motor_Vehicle_Reg_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Motor_V_Maintenance_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Motor_Vehicle_Fitness_Monthly_After_Loan__c'));
        
        propertyRelatedCostsAfter = 
            convertValue(applicant.get('Property_Insurance_Monthly_After_Loan__c')) +
            convertValue(applicant.get('Property_Tax_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Property_Maintenance_Monthly_After_Loan__c'));
        
        personalFamilyCostsAfter = 
            convertValue(applicant.get('Personal_Expenses_Monthly_After_Loan__c')) +
            convertValue(applicant.get('Food_Costs_Monthly_After_Loan__c')) +
            convertValue(applicant.get('Child_Care_Costs_Monthly_After_Loan__c'))+
            convertValue(applicant.get('School_Costs_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Health_Costs_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Other_Personal_Family_Costs_Prior_After__c'));
        
        utilitiesExpensesAfter = 
            convertValue(applicant.get('Electricity_Monthly_After_Loan__c')) +
            convertValue(applicant.get('Water_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Cell_Phone_Landline_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Internet_Cable_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Cooking_Gas_Monthly_After_Loan__c'))+
            convertValue(applicant.get('Other_Utilities_Monthly_After_Loan__c'))+
            convertValue(applicant.get('House_Keeping_Costs_Monthly_After_Loan__c'));
        
        totalOutflowsBefore = 
            installmentPayments + lifeInsurancePayments + 
            savingsInvestments + pensionContribution + propertyRelatedCosts +
            personalFamilyCosts + utilitiesExpenses + transportationCosts;
        
        totalOutflowsAfter = installmentPaymentsAfter + lifeInsurancePaymentsAfter + 
            savingsInvestmentsAfter + pensionContributionAfter + propertyRelatedCostsAfter +
            personalFamilyCostsAfter + utilitiesExpensesAfter + transportationCostsAfter;
        
        residualIncomeAfterBeforeLoan = totalInflows - totalOutflowsBefore;
        residualIncomeAfterAfterLoan = totalInflows - totalOutflowsAfter;
        
    }
    
    
}