@isTest
public class JN1_4287_TestClass {
    //User
    public static User testUser;
    
    //Account
    public static Account testAccountObj;
    public static list<Account> testAccountObjs;
    
    //Loan Calculator
    public static Loan_Calculator__c testLoanCalculatorObj;
    public static List<Loan_Calculator__c> testLoanCalculatorLst;
    
    //Opportunity
    public static Opportunity testOpportunityObj;
    public static List<Opportunity> testOpportunityLst;
    
    //Loan_Calculation_Product__c
    public static Loan_Calculation_Product__c testLoanCalculationProductObj;
    public static List<Loan_Calculation_Product__c> testLoanCalculationProductLst;
	
    //Loan_Calculation_Applicant_Product__c
    public static Loan_Calculation_Applicant_Product__c testLoanCalculationApplicationProductObj;
    public static List<Loan_Calculation_Applicant_Product__c> testLoanCalculationApplicationProductLst;
    
    //Employment
    public static FinServ__Employment__c testEmploymentObj;
    public static List<FinServ__Employment__c> testEmploymentLst;
  
    //Applicant
    public static Applicant__c testApplicantObj;    

    //Product2    
    public static Product2 prodctObj;
    
    //Price book 2    
    public static Pricebook2 priceBook2Obj; 
    
    //Price book Entry    
    public static PricebookEntry PricebookEntryObj;
    
    //Opportunity Line Item
    public static OpportunityLineItem testOpportunityLineItemObj;

    public static void CreateData(){                      
        //------Create User--------//
        testUser = TestDataFactory.CreateUser('testUserSunil@test.com');
        
        //------Create Account--------//
        Date dt = Date.newInstance(1995,11,13);
        testAccountObjs = TestDataFactory.CreateBasicAccounts(1, 'lastName');
        testAccountObj = testAccountObjs.get(0);
        testAccountObj.Political_Exposure__pc = False;
        testAccountObj.Jamaican_Tax_Registration_Number__pc = '123456789';
        testAccountObj.PersonBirthdate = Date.newInstance(1984, 02, 14);
        testAccountObj.Highest_Level_of_Education_attained__pc = 'High School';
        testAccountObj.Status_of_Address__pc='Own (without mortgage)';
        testAccountObj.Years_at_Residence__pc = 4;
        insert testAccountObj;
        
        //------Create Loan Calculator--------//
        Map<String, Id> recordTypeids = Util.getRecordTypeids('Loan_Calculator__c');
        testLoanCalculatorLst = TestDataFactory.CreateLoanCalculation(1);
        testLoanCalculatorObj = testLoanCalculatorLst.get(0);
        testLoanCalculatorObj.RecordTypeId = recordTypeids.get('Product_Details');
        insert testLoanCalculatorObj;
        
        //------Create Opportunity--------//
        testOpportunityLst = TestDataFactory.CreateOpportunities(1);
        testOpportunityObj = testOpportunityLst.get(0);
        testOpportunityObj.AccountId = testAccountObj.Id;
        testOpportunityObj.Product_Details__c = testLoanCalculatorObj.Id;
        testOpportunityObj.StageName ='Submitted and Processing'; 
        insert testOpportunityObj;
        testLoanCalculatorObj.Opportunity__c = testOpportunityObj.Id;
        update testLoanCalculatorObj;
        
        //------Create Loan Calculation Product--------//
        testLoanCalculationProductLst = TestDataFactory.CreateLoanCalculationProduct(1);
        testLoanCalculationProductObj = testLoanCalculationProductLst.get(0);
        testLoanCalculationProductObj.Loan_Calculation_Id__c = testLoanCalculatorObj.Id;
        testLoanCalculationProductObj.Requested_Credit_Limit_Number__c = 500;
        testLoanCalculationProductObj.Collateral_Type_List__c = 'Cash/Investments';
        testLoanCalculationProductObj.Loan_to_Value_Number__c = 26;
        testLoanCalculationProductObj.Ability_to_Service_Before_Number__c = 25;
        testLoanCalculationProductObj.Repayment_Method_List__c = 'Salary Deduction';
        insert testLoanCalculationProductObj;

        //------Create Employement--------//
        testEmploymentObj = TestDataFactory.CreateEmployment(testAccountObj.Id, 'name');
        testEmploymentObj.FinServ__StartDate__c = Date.newInstance(2010,11,13);
        testEmploymentObj.Current_Employment__c = True;
        testEmploymentObj.FinServ__EmploymentStatus__c = 'Permanent';
        testEmploymentObj.Industry__c='Financial Services';
        testEmploymentObj.Professional_Category__c = 'Professional';
        testEmploymentObj.Assessment_of_Business_Working_Capita__c = 'Good';
        testEmploymentObj.Nature_of_Engagement__c = 'Professional service provider';
        testEmploymentObj.Assessment_of_Business__c = 'Good growth and or profit trends for 3 - 4 years';
        testEmploymentObj.Assessment_of_Statement__c = 'Strongly Supported';
        testEmploymentObj.Length_of_Trade__c = 'More than 5 years';
        testEmploymentObj.Account__c = testAccountObj.Id;
        
        insert testEmploymentObj;
        
        //------Create Application--------//
        testApplicantObj = TestDataFactory.CreateApplicant(testAccountObj.Id, testOpportunityObj.Id);
        testApplicantObj.Sanction_Screening_has_Negative_Trace__c = 'No';
        testApplicantObj.Account__c = testAccountObj.Id;
        testApplicantObj.Opportunity__c = testOpportunityObj.Id;
        testApplicantObj.Credit_History_in_last_24_Months__c = '1 - 10 Days Delinquent';
        testApplicantObj.Assessment_of_Applicant_Net_Worth__c = 'Strong net worth';
        
        insert testApplicantObj;
        
        //------Create Loan Calculation Application Product--------//
        testLoanCalculationApplicationProductLst = TestDataFactory.CreateLoanCalculationApplicationPrdct(1);
        testLoanCalculationApplicationProductObj = testLoanCalculationApplicationProductLst.get(0);
        testLoanCalculationApplicationProductObj.Loan_Calculation_Product_Id__c = testLoanCalculationProductObj.Id;
        testLoanCalculationApplicationProductObj.Loan_Amount_Number__c = 56;
        testLoanCalculationApplicationProductObj.Applicant_Id__c = testApplicantObj.id;
        insert testLoanCalculationApplicationProductObj;
        
        //------Create Product--------//
        prodctObj = TestDataFactory.CreateProduct('JN Bank Auto Loan', 'JN Bank Auto Loan');
        prodctObj.QuantityUnitOfMeasure = 'Each';
        insert prodctObj;
        
        //------Create Pricebook2--------//
        priceBook2Obj = New Pricebook2(Id = Test.getStandardPricebookId(), 
                                       IsActive = true);
        Update priceBook2Obj;
        
        //------Create PriceBookEntry--------//
        PricebookEntryObj = TestDataFactory.CreatePriceBookEntry(priceBook2Obj.Id, prodctObj.Id);
        insert PricebookEntryObj;
        
        //------Create Opportunity Line Item--------//
        testOpportunityLineItemObj = TestDataFactory.CreateOpportunityLineItem(testOpportunityObj.Id, PricebookEntryObj.Id);
        insert testOpportunityLineItemObj;
    }
    
    @isTest
    public static void test1_AutoCreditScoreModelPage(){
        CreateData();
        Test.StartTest();
        pageReference pager = page.AutoCreditScoreModel;
        pager.getParameters().put('id', String.valueOf(testApplicantObj.Id));
        Test.setCurrentPage(pager);
        AutoCreditScoreModelController testAccPlan = new AutoCreditScoreModelController();
        
        System.assertEquals('Test 0 lastNamei', testAccPlan.nameOfApplicant, 'Name of Applicant Not matching');
        System.assertEquals('No', testAccPlan.isApplicantPolicExpoxed, 'Is the Applicant a Politcally Exposed Person (PEP)?* Not matching');
        System.assertEquals('123456789', testAccPlan.jamaicanTaxNumber, 'jamaicanTaxNumber Not matching');
        System.assertEquals('No', testAccPlan.hasSanctionNegativeTrace, 'Has the sanction screening(s) resulted in a negative trace?* Not matching');
        
        System.assertEquals('31-40', testAccPlan.ageString, 'Age Score Not matching');
        System.assertEquals(600, testAccPlan.ageScore, 'Age Score Not matching');
        System.assertEquals(18, testAccPlan.ageWeightage, 'Age Weightage Not matching');
        
        System.assertEquals('High School', testAccPlan.educationString, 'Education Not matching');
        System.assertEquals(400, testAccPlan.educationScore, 'Education Score Not matching');
        System.assertEquals(16, testAccPlan.educationWeightage, 'Education Weightage Not matching');

        Test.StopTest(); 
    }
}