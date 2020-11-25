@IsTest
public with sharing class ProductDetailServiceTest {
    @IsTest
    public static void testAge() {
        List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
        List<Account> accList = TestDataFactory.CreateBasicAccounts(1,'Test');
        accList[0].Status_of_Address__c = 'Family';
        accList[0].Years_at_Residence__c = 4;
        accList[0].Highest_Level_of_Education__c = 'High School';
        accList[0].PersonBirthdate = date.newInstance(System.Today().year()-22, 2, 11);
        insert accList;
        Util.ExecutionCount = 2;
        /*List<FinServ__ReciprocalRole__c> reciprocalRole = new List<FinServ__ReciprocalRole__c>();
        FinServ__ReciprocalRole__c finServReciprocalRole = new FinServ__ReciprocalRole__c();
        finServReciprocalRole.FinServ__InverseRole__c = '';
        finServReciprocalRole.FinServ__RelationshipType__c = '';
        finServReciprocalRole.Name = 'Political Affiliation';
        finServReciprocalRole.DeveloperName = */
        
        opList[0].accountId = accList[0].id;
        opList[0].Collateral_CC__c = 'Realestate - Residential';
        opList[0].Collateral_LOC__c = 'Realestate - Residential';
        insert opList[0];

        FinServ__Employment__c employeeList = TestDataFactory.CreateEmployment(accList[0].id,'Employeement Test');
        employeeList.Current_Employment__c = true;
        employeeList.FinServ__EmploymentStatus__c = 'Permanent';
        employeeList.Employment_Status__c = 'Contractual';
        employeeList.Industry__c = 'Manufacturing';
        employeeList.Professional_Category__c = 'Clerical';
        employeeList.Assessment_of_Business_Working_Capita__c = 'Negative';
        employeeList.Nature_of_Engagement__c = 'Vocational service provider';
        employeeList.Assessment_of_Business__c = 'Good growth and profit trends for 3 - 4 years';
        employeeList.Assessment_of_Statement__c = '	Strongly Supported';
        employeeList.Length_of_Trade__c = 'Between 3-5 years';
        employeeList.RecordTypeId = '012q00000001gsFAAQ';//Schema.SObjectType.FinServ__Employment__c.getRecordTypeInfosByName().get('Employed').getRecordTypeId();
        insert employeeList;

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

        SubCriteriaOptionWrapper SubCriteriaOptionWrapperObj = ProductDetailService.getSubcriteriaOptions(opList[0].id);
        CreditScoreModelWrapper creditScoreModelWrapperObj = new CreditScoreModelWrapper(SubCriteriaOptionWrapperObj);

    }
}
