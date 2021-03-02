@isTest
public class WrapperApplicationForm_Test {
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
    opList[0].accountId = accList[0].id;
    opList[0].Collateral_CC__c = 'Cash';
    opList[0].Collateral_LOC__c = 'Cash';
    opList[0].Loan_to_ValueCC__c = 1;
    opList[0].StageName = 'Customer Interview';
    opList[0].CloseDate = Date.today().addDays(6);
    // opList[0].Product_Details__c = loanCalcList[0].Id;
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
    Test.StopTest();
  }
}
