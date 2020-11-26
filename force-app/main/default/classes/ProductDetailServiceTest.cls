@IsTest
public with sharing class ProductDetailServiceTest {
    @IsTest
    public static void testAllTypesForEmployedValues() {
        List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
        List<Account> accList = TestDataFactory.CreateBasicAccounts(1,'Test');
        accList[0].Status_of_Address__c = 'Family';
        accList[0].Years_at_Residence__c = 4;
        accList[0].Highest_Level_of_Education__c = 'High School';
        accList[0].PersonBirthdate = date.newInstance(System.Today().year()-22, 2, 11);
        insert accList;
        Util.ExecutionCount = 2;
        
        opList[0].accountId = accList[0].id;
        opList[0].Collateral_CC__c = 'Realestate - Residential';
        opList[0].Collateral_LOC__c = 'Realestate - Residential';
        insert opList[0];

        FinServ__Employment__c employee = TestDataFactory.CreateEmployment(accList[0].id,'Employeement Test');
        employee.Current_Employment__c = true;
        employee.FinServ__EmploymentStatus__c = 'Permanent';
        employee.Employment_Status__c = 'Contractual';
        employee.Industry__c = 'Manufacturing';
        employee.Professional_Category__c = 'Clerical';
        employee.Assessment_of_Business_Working_Capita__c = 'Negative';
        employee.Nature_of_Engagement__c = 'Vocational service provider';
        employee.Assessment_of_Business__c = 'Good growth and profit trends for 3 - 4 years';
        employee.Assessment_of_Statement__c = '	Strongly Supported';
        employee.Length_of_Trade__c = 'Between 3-5 years';
        Map<String,Id> recordTypeMap =  Util.getRecordTypeids('FinServ__Employment__c');
        employee.RecordTypeId = recordTypeMap.get('Employed');
        insert employee;

        Applicant__c applicant = TestDataFactory.CreateApplicant(accList[0].id,opList[0].id);
        applicant.Credit_History_in_last_24_Months__c = '1 - 10 Days Delinquent';
        applicant.Assessment_of_Applicant_Net_Worth__c = 'Reasonable net worth';
        insert applicant;

        List<Loan_Calculator__c> loanCalculator =  TestDataFactory.CreateLoanCalculation(1);
        loanCalculator[0].Ability_to_Service_CC__c = 9;
        loanCalculator[0].Ability_to_Service_LOC__c = 10;
        loanCalculator[0].Repayment_Method_CC__c = 'Salary Deduction';
        loanCalculator[0].Repayment_Method_LOC__c = 'Salary Deduction';
        loanCalculator[0].Opportunity__c = opList[0].id;
        insert loanCalculator[0];
        test.startTest();
        RiskRatingWrapper riskRatingWrapperObj = ProductDetailService.getRiskRatingWrapper(opList[0].id);
        System.assertEquals('R3',riskRatingWrapperObj.rating);
        test.stopTest();
    }
    @IsTest
    public static void testAllTypesForSelfEmployedValues() {
        List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
        List<Account> accList = TestDataFactory.CreateBasicAccounts(1,'Test');
        accList[0].Status_of_Address__c = 'Family';
        accList[0].Years_at_Residence__c = 4;
        accList[0].Highest_Level_of_Education__c = 'High School';
        accList[0].PersonBirthdate = date.newInstance(System.Today().year()-22, 2, 11);
        insert accList;
        Util.ExecutionCount = 2;
        
        opList[0].accountId = accList[0].id;
        opList[0].Collateral_CC__c = 'Realestate - Residential';
        opList[0].Collateral_LOC__c = 'Realestate - Residential';
        insert opList[0];

        FinServ__Employment__c employee = TestDataFactory.CreateEmployment(accList[0].id,'Employeement Test');
        employee.Current_Employment__c = true;
        employee.FinServ__EmploymentStatus__c = 'Contractual';
        employee.Employment_Status__c = 'Permanent';
        employee.Industry__c = 'Manufacturing';
        employee.Professional_Category__c = 'Clerical';
        employee.Assessment_of_Business_Working_Capita__c = 'Negative';
        employee.Nature_of_Engagement__c = 'Vocational service provider';
        employee.Assessment_of_Business__c = 'Good growth and profit trends for up to 2 years';
        employee.Assessment_of_Statement__c = '	Strongly Supported';
        employee.Length_of_Trade__c = 'Between 3-5 years';
        Map<String,Id> recordTypeMap =  Util.getRecordTypeids('FinServ__Employment__c');
        employee.RecordTypeId = recordTypeMap.get('Self_Employed');
        insert employee;

        Applicant__c applicant = TestDataFactory.CreateApplicant(accList[0].id,opList[0].id);
        applicant.Credit_History_in_last_24_Months__c = '1 - 10 Days Delinquent';
        applicant.Assessment_of_Applicant_Net_Worth__c = 'Reasonable net worth';
        insert applicant;

        List<Loan_Calculator__c> loanCalculator =  TestDataFactory.CreateLoanCalculation(1);
        loanCalculator[0].Ability_to_Service_CC__c = 9;
        loanCalculator[0].Ability_to_Service_LOC__c = 10;
        loanCalculator[0].Repayment_Method_CC__c = 'Salary Deduction';
        loanCalculator[0].Repayment_Method_LOC__c = 'Salary Deduction';
        loanCalculator[0].Opportunity__c = opList[0].id;
        insert loanCalculator[0];
		test.startTest();
        RiskRatingWrapper riskRatingWrapperObj = ProductDetailService.getRiskRatingWrapper(opList[0].id);
        System.assertEquals('R4',riskRatingWrapperObj.rating);
        test.stopTest();
    }
    
    @IsTest
    public static void testAllTypesForEmployedValuesWithNullValues() {
        List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
        List<Account> accList = TestDataFactory.CreateBasicAccounts(1,'Test');
        accList[0].Status_of_Address__c = 'Rent';
        accList[0].Years_at_Residence__c = 1;
        accList[0].Highest_Level_of_Education__c = 'High School';
        accList[0].PersonBirthdate = date.newInstance(System.Today().year()-31, 2, 11);
        insert accList;
        Util.ExecutionCount = 2;
        
        opList[0].accountId = accList[0].id;
        opList[0].Collateral_CC__c = 'Cash';
        opList[0].Collateral_LOC__c = 'Cash';
        insert opList[0];

        FinServ__Employment__c employee = TestDataFactory.CreateEmployment(accList[0].id,'Employeement Test');
        employee.Current_Employment__c = true;
        employee.FinServ__EmploymentStatus__c = 'Permanent';
        employee.Employment_Status__c = 'Permanent';
        employee.Industry__c = 'Tourism';
        employee.Professional_Category__c = 'Skilled Worker';
        employee.Assessment_of_Business_Working_Capita__c = 'weak';
        employee.Nature_of_Engagement__c = 'Trader';
        employee.Assessment_of_Business__c = 'Inconsistent profit/growth trends';
        employee.Assessment_of_Statement__c = '	Sound Business Plan, Skill And Professional Competence';
        employee.Length_of_Trade__c = 'Between 3-5 years';
        Map<String,Id> recordTypeMap =  Util.getRecordTypeids('FinServ__Employment__c');
        employee.RecordTypeId = recordTypeMap.get('Employed');
        insert employee;

        Applicant__c applicant = TestDataFactory.CreateApplicant(accList[0].id,opList[0].id);
        applicant.Credit_History_in_last_24_Months__c = '31 - 60 days Delinquent';
        applicant.Assessment_of_Applicant_Net_Worth__c = 'Strong net worth';
        insert applicant;
		test.startTest();
        RiskRatingWrapper riskRatingWrapperObj = ProductDetailService.getRiskRatingWrapper(opList[0].id);
        System.assertEquals('R6',riskRatingWrapperObj.rating);
        test.stopTest();
    }
    @isTest
    public static void testAllTypesForSelfEmployedValuesWithNullValues() {
        List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
        List<Account> accList = TestDataFactory.CreateBasicAccounts(1,'Test');
        accList[0].Status_of_Address__c = 'Rent';
        accList[0].Highest_Level_of_Education__c = 'High School';
        accList[0].PersonBirthdate = date.newInstance(System.Today().year()-31, 2, 11);
        insert accList;
        Util.ExecutionCount = 2;
        
        opList[0].accountId = accList[0].id;
        opList[0].Collateral_CC__c = 'Cash';
        opList[0].Collateral_LOC__c = 'Cash';
        insert opList[0];

        FinServ__Employment__c employee = TestDataFactory.CreateEmployment(accList[0].id,'Employeement Test');
        employee.Current_Employment__c = true;
        employee.FinServ__EmploymentStatus__c = 'Contractual';
        employee.Employment_Status__c = 'Permanent';
        employee.Industry__c = 'Tourism';
        employee.Assessment_of_Business_Working_Capita__c = 'weak';
        employee.Nature_of_Engagement__c = 'Trader';
        employee.Assessment_of_Business__c = 'Inconsistent profit/growth trends';
        employee.Assessment_of_Statement__c = '	Sound Business Plan, Skill And Professional Competence';
        Map<String,Id> recordTypeMap =  Util.getRecordTypeids('FinServ__Employment__c');
        employee.RecordTypeId = recordTypeMap.get('Self_Employed');
        insert employee;

        Applicant__c applicant = TestDataFactory.CreateApplicant(accList[0].id,opList[0].id);
        applicant.Credit_History_in_last_24_Months__c = '31 - 60 days Delinquent';
        insert applicant;
		test.startTest();
        RiskRatingWrapper riskRatingWrapperObj = ProductDetailService.getRiskRatingWrapper(opList[0].id);
        System.assertEquals('R8',riskRatingWrapperObj.rating);
        test.stopTest();
    }
}