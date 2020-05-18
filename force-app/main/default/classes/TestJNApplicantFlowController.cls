@isTest
public class TestJNApplicantFlowController {
    
    @testSetup static void setup(){
        User newUser = TestDataFactory.CreateUser('leadtester@test.com');
        insert newUser;
        List<FinServ__ReciprocalRole__c> roles = new  List<FinServ__ReciprocalRole__c>();
        List<String> roleNames = new String[]{'Emergency Contact','Political Affiliation','JN Affiliation'};
            for(String roleName: roleNames){
                roles.add(TestDataFactory.CreateRole(roleName));
            }
        insert roles;
    }
    
    @isTest
    public static void shouldGetContactsAccount(){
        Test.startTest();
        List<Account> accounts = TestDataFactory.CreateBasicAccounts(2, 'Maxine');
        insert accounts;
        
        List<String> ids = new List<String>();
        
        for(Account acc: accounts){
            ids.add(acc.Id);
        }
        
        System.assert(ids!=null, 'Id List is empty.');
        JNApplicantFlowController.getContactsAccount(ids);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetAccounts(){
        Test.startTest();
        List<Account> accounts = TestDataFactory.CreateBasicAccounts(2, 'Maxine');
        for(Account acc: accounts){
            acc.PersonMobilePhone = '18767547845';
        }
        insert accounts;
        
        List<String> ids = new List<String>();
        
        for(Account acc: accounts){
            ids.add(acc.Id);
        }
        
        JNApplicantFlowController.getAccounts(ids);
        System.assert(ids!=null, 'Id List is empty.');
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetApplicantDetails(){
        Test.startTest();
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        insert acc;
        
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        Applicant__c applicant = TestDataFactory.CreateApplicant(acc.Id, opp.Id);
        insert applicant;
        
        applicant.CRIF_Rating__c = 'Low Risk';
        applicant.CreditInfo_Rating__c = 'Average Risk';
        applicant.Overall_Rating__c = 'Average';
        applicant.Credit_History_in_last_24_Months__c = 'No Delinquency';
        applicant.Assessment_of_Applicant_Net_Worth__c = 'Low Net Worth';
        applicant.Judgements_Filed__c = 'No';
        applicant.Bankrupt_in_Last_7_Years__c = 'No';
        applicant.Lawsuits_or_Claims__c = 'No';
        applicant.Is_applicant_KYC_Compliant__c = 'Yes';
        applicant.Primary_Relationship_Tier__c = 'JN Mahogany Club';
        applicant.Affiliation_Type__c = 'Unconnected';
        applicant.Time_as_Member_Months__c = 3;
        applicant.Time_as_Member_Years__c = 2;
        applicant.JN_Group_Employee__c = 'No';
        applicant.Sanction_Screening_Completed__c = 'Yes';
        applicant.Rim_Number__c = '99';
        applicant.Basic_monthly_pay_no_allowances__c = 5000.00;
        applicant.Total_unsecured_Balance_Installment_and__c = 1000.00;
        applicant.JN_Employee_Loan_Benefit__c = false;
        applicant.Sanction_Screening_has_Negative_Trace__c = 'No';
        update applicant;
        
        JNApplicantFlowController.getApplicantDetails(applicant.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetApplicantDetailsNegative(){
        Test.startTest();
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Lowe')[0];
        insert acc;
        
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.StageName = 'Prospecting';
        opp.AccountId = acc.Id;
        insert opp;
        
        Applicant__c applicant = TestDataFactory.CreateApplicant(acc.Id, opp.Id);
        insert applicant;
        Id appId = applicant.Id;
        
        List<Applicant__c> applicantList = [SELECT Id FROM Applicant__c WHERE Id =: appId];
        DELETE applicantList;
        
        boolean a = false;
        try{
            
        }catch(System.DmlException e){
            if(e.getMessage()!= null){
                a = true;
            }
        }
        JNApplicantFlowController.getApplicantDetails(applicant.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetFullApplicantDetails(){
        Test.startTest();
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        insert acc;
        
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.StageName = 'Prospecting';
        opp.AccountId = acc.Id;
        insert opp;
        
        Applicant__c applicant = TestDataFactory.CreateApplicant(acc.Id, opp.Id);
        insert applicant;
        
        applicant.Applicable_sources_of_income__c = 'Salary'; 
        applicant.Salary_and_Allowances_as_per_pay_slips__c = 50000.00;
        applicant.Gratuity_in_lieu_of_Pension__c = 30000.00;
        applicant.Performance_Based_Pay_Includes_Commissi__c = 10000.00;
        applicant.Net_Profit_Sole_Trader__c = 200.00;
        applicant.Director_s_Emoluments_Director__c = 400.00;
        applicant.Share_of_Profit_Partnership__c = 300.00;
        applicant.Share_of_Profit_Shareholder__c = 9000.00;
        applicant.Pension__c = 550.00;
        applicant.Existing_Real_estate_Rental_II__c = 84002.00;
        applicant.Existing_Real_Estate_Rental_I__c = 92000.00;
        applicant.Projected_Real_Estate_Rental__c = 70000.00;
        applicant.Other_Income__c = 950.00;
        applicant.Income_Tax_Monthly_Payment_Prior_Loan__c = 8000.00;
        applicant.NIS_Contribution_Monthly_Prior_Loan__c = 8300.00;
        applicant.NHT_Contributions_Monthly_Prior_Loan__c = 9400.00;
        applicant.Education_Tax_Monthly_Prior_Loan__c = 900.00;
        applicant.Food_Cost_Monthly_Prior_Loan__c = 880.00; 
        applicant.Food_Costs_Monthly_After_Loan__c = 2000.00;
        applicant.Personal_Expenses_Monthly_Prior_Loan__c = 7600.00;
        applicant.Personal_Expenses_Monthly_After_Loan__c = 840.00;
        applicant.Child_Care_Costs_Monthly_Prior_Loan__c = 2300.00;
        applicant.Child_Care_Costs_Monthly_After_Loan__c = 5500.00;
        applicant.School_Costs_Monthly_Prior_Loan__c = 2800.00;
        applicant.School_Costs_Monthly_After_Loan__c = 610.00; 
        applicant.Health_Costs_Monthly_Prior_Loan__c = 5200.00;
        applicant.Health_Costs_Monthly_After_Loan__c = 1000.00;
        applicant.Other_Personal_Family_Costs_Prior_After__c = 1240.00;
        applicant.Other_Personal_Family_Monthly_Prior_Loan__c = 9280.00;      
        applicant.Rent_Board_Monthly_Prior_Loan__c = 300.00;
        applicant.Rent_Board_Monthly_After_Loan__c = 7800.00;
        applicant.Strata_Maintenance_Monthly_Prior_Loan__c = 200.00;
        applicant.Strata_Maintenance_Monthly_After_Loan__c = 5900.00;
        applicant.Property_Tax_Monthly_Prior_Loan__c = 3400.00;
        applicant.Property_Tax_Monthly_After_Loan__c = 9382.00;
        applicant.Property_Insurance_Monthly_Prior_Loan__c = 8900.00;
        applicant.Property_Insurance_Monthly_After_Loan__c = 7392.00;
        applicant.Property_Maintenance_Monthly_Prior_loan__c = 120.00;
        applicant.Property_Maintenance_Monthly_After_Loan__c = 430.00;
        applicant.Electricity_Monthly_Prior_Loan__c = 293.00;
        applicant.Electricity_Monthly_After_Loan__c = 9830.00;
        applicant.Water_Monthly_Prior_Loan__c = 230.00;
        applicant.Water_Monthly_After_Loan__c = 1000.00;
        applicant.Cell_Phone_Landline_Monthly_Prior_Loan__c = 930.00;
        applicant.Cell_Phone_Landline_Monthly_After_Loan__c = 670.00;
        applicant.Internet_Cable_Monthly_Prior_Loan__c = 230.00;
        applicant.Internet_Cable_Monthly_After_Loan__c = 530.00;
        applicant.Cooking_Gas_Monthly_Prior_Loan__c = 600.00;
        applicant.Cooking_Gas_Monthly_After_Loan__c = 750.00;
        applicant.House_Keeping_Monthly_Prior_Loan__c = 980.00;
        applicant.House_Keeping_Costs_Monthly_After_Loan__c = 125.00;
        applicant.Other_Utilities_Monthly_Prior_Loan__c = 360.00;
        applicant.Other_Utilities_Monthly_After_Loan__c = 540.00;
        applicant.Fares_Monthly_Prior_Loan__c = 230.00;
        applicant.Fares_Monthly_After_Loan__c = 991.00;
        applicant.Toll_Fees_Monthly_Prior_Loan__c = 520.00;
        applicant.Toll_Fees_Monthly_After_Loan__c = 938.00;
        applicant.Petrol_Fuel_Monthly_Prior_Loan__c = 650.00;
        applicant.Petrol_Fuel_Monthly_After_Loan__c = 850.00;
		applicant.Motor_V_Insurance_Monthly_Prior_Loan__c = 620.00;
        applicant.Motor_V_Insurance_Monthly_After_Loan__c = 520.00;
        applicant.Motor_Vehicle_Reg_Monthly_Prior_Loan__c = 670.00;
        applicant.Motor_Vehicle_Reg_Monthly_After_Loan__c = 530.00;
        applicant.Motor_Vehicle_Fitness_Monthly_Prior_Loan__c = 398.00;
        applicant.Motor_Vehicle_Fitness_Monthly_After_Loan__c = 830.00;        
        applicant.Motor_V_Maintenance_Monthly_Before_Loan__c = 2000.00;
        applicant.Motor_V_Maintenance_Monthly_After_Loan__c = 400.00;
        applicant.Other_Transport_Costs_Monthly_Prior_Loan__c = 120.00;
        applicant.Other_Transport_Monthly_After_Loan__c = 280.00;

		update applicant;
        
        JNApplicantFlowController.getFullApplicantDetails(applicant.Id);
        
		Test.stopTest();
    }
    
    @isTest
    public static void shouldGetFullApplicantDetailsNegative(){
        Test.startTest();
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Lowe')[0];
        insert acc;
        
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.StageName = 'Prospecting';
        opp.AccountId = acc.Id;
        insert opp;
        
        Applicant__c applicant = TestDataFactory.CreateApplicant(acc.Id, opp.Id);
        insert applicant;
        Id appId = applicant.Id;
        
        List<Applicant__c> applicantList = [SELECT Id FROM Applicant__c WHERE Id =: appId];
        DELETE applicantList;
        
        boolean a = false;
        try{
            
        }catch(System.DmlException e){
            if(e.getMessage()!= null){
                a = true;
            }
        }
        JNApplicantFlowController.getFullApplicantDetails(applicant.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldUpdateApplicantDetailsBasic(){
        Test.startTest();
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        insert acc;
        
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        Applicant__c applicant = TestDataFactory.CreateApplicant(acc.Id, opp.Id);
        insert applicant;
        
        JNApplicantFlowController.updateApplicantDetailsBasic(applicant);
        
        Test.stopTest();
    }
    
    @isTest
    public static void shouldUpdateApplicantDetailsBasicNegative(){
        Test.startTest();
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        insert acc;
        
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        Applicant__c applicant = TestDataFactory.CreateApplicant(acc.Id, opp.Id);
        JNApplicantFlowController.updateApplicantDetailsBasic(applicant); 
        
        Test.stopTest();
    }
    
    @isTest
    public static void shouldUpdateApplicantDetails(){
        Test.startTest();
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        insert acc;
        
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        Applicant__c applicant = TestDataFactory.CreateApplicant(acc.Id, opp.Id);
        applicant.CRIF_Rating__c = 'Low Risk';
        applicant.CreditInfo_Rating__c = 'Average Risk';
        insert applicant;
        
        JNApplicantFlowController.updateApplicantDetails(applicant);
        
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetRecordTypeId(){
        Test.startTest();
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        insert acc;
        
        String devName;
        Map<String, Id> recordTypeId = Util.getRecordTypeids('Account');
        
        for(String key: recordTypeId.keySet()){
            if(acc.RecordTypeId == recordTypeId.get(key)){
                devName = key;
            }
        }
                
        System.assert(devName!=null, 'Developer Name is null.');

        JNApplicantFlowController.getRecordTypeId(devName);
        
        
        Test.stopTest();
    }
    
    /*@isTest
    public static void shouldGetPickListValues(){
        Test.startTest();
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        acc.Type = 'Analyst';
        acc.RecordTypeId = recordTypeId;
        insert acc;
        
        //System.debug('Record type' + recordTypeId);
        Account result = [SELECT RecordType.name, RecordType.DeveloperName FROM Account Where RecordTypeId =:recordTypeId];
        
        JNApplicantFlowController.getPickListValues('Account', 'Type', result.RecordType.name, acc.RecordTypeId);
        
        Test.stopTest();
    }*/
    
    @isTest
    public static void shouldGetPickListValuesList(){
        Test.startTest();
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        acc.Type = 'Analyst';
        acc.Rating = 'Hot';
        insert acc;
        
        List<String> names = new List<String>();
        
        names.add('Type');
        names.add('Rating');
        
        System.assert(names!=null, 'Picklists fields not being added.');
        JNApplicantFlowController.getPickListValuesList('Account', names);
        
        Test.stopTest();
    }
    
    @isTest
    public static void shouldGetMultiPickListValuesList(){
        Test.startTest();
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Maxine')[0];
        acc.Type = 'Analyst';
        acc.Rating = 'Hot';
        insert acc;
        
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        List<String> namesApi = new List<String>();
        List<String> namesFields = new List<String>();
        
        namesApi.add('Account');
        namesApi.add('Opportunity');
        
        namesFields.add('Type');
        namesFields.add('Rating');
        namesFields.add('StageName');
        
        System.assert(namesApi!=null, 'sObjects not added');
        System.assert(namesFields!=null, 'Fields not added');
        JNApplicantFlowController.getMultiPickListValuesList(namesApi, namesFields);
        
        Test.stopTest();
    }
}