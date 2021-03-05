@isTest
public class PromissoryNoteController_Test {
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
    //update standardPricebook;

    //Query for the Pricebook2 recordapplicant.to check IsStandard field
    /*standardPricebook = [
            SELECT Id, IsStandard
            FROM Pricebook2
            WHERE Id = :standardPricebook.Id
            FOR UPDATE
        ];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);*/

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
    Test.StartTest();
    pageReference pageRef = page.PromissoryNotePage;
    pageRef.getParameters().put('Id', String.valueOf(opList[0].Id));
    Test.setCurrentPage(pageRef);
    PromissoryNoteController pnc = new PromissoryNoteController();
    Test.StopTest();
  }
}
