/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  RUB-134     22/02/2021      Tushar C.(thinqloud)  	Test Class for DebtConsolidationRecordController
 **/
@isTest
public inherited sharing class TestDebtConsolidationRecordController {
    @isTest
    public static void testSaveApplAssetLiabilityRecords() {
        test.startTest();
        Map<String, Id> recordTypeMap = Util.getRecordTypeids('Application_Asset_Liability__c');
        Id recordTypeId= recordTypeMap.get('Debt_Consolidation');
        
        List<Account> accList = TestDataFactory.CreateBasicAccounts(1, 'TestAccount');
        insert accList;
        System.assertNotEquals(null, accList,'No Accounts Available');
        System.assertEquals(1, accList.size());
        
        List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
        opList[0].accountId = accList[0].id;
        insert opList;
        System.assertNotEquals(null, opList,'Opportunity not created');
        System.assertEquals(1, opList.size());
        
		Applicant__c applicant = TestDataFactory.CreateApplicant(accList[0].Id, opList[0].Id);
        insert applicant;
        System.assertEquals(accList[0].Id, applicant.Account__c);
        System.assertEquals(opList[0].Id, applicant.Opportunity__c);
        
        FinServ__AssetsAndLiabilities__c assetLiability = TestDataFactory.CreateAssetsAndLiabilities(accList[0].Id, recordTypeId, 'TestAsset');
        assetLiability.Name = 'other loan';
        insert assetLiability;
        
        Application_Asset_Liability__c applAssetLiability = TestDataFactory.CreateApplicantAssetsAndLiabilities(applicant.Id, assetLiability.Id);
        List<Application_Asset_Liability__c> listRecords = new List<Application_Asset_Liability__c>();
        listRecords.add(applAssetLiability);
        insert listRecords;
        
        Application_Asset_Liability__c applAssetLiabilityToInsert = TestDataFactory.CreateApplicantAssetsAndLiabilities(applicant.Id, assetLiability.Id);
        listRecords.add(applAssetLiabilityToInsert);


        DebtConsolidationRecordController.saveAssetLiablityRecords(listRecords, applicant.Id, Decimal.valueOf(1000),Decimal.valueOf(500));
        List<Application_Asset_Liability__c> getRecords = DebtConsolidationRecordController.getAssetLiabilityRecords(applicant.Id);
        System.assertEquals(listRecords.size(), getRecords.size());

        test.stopTest();
    }
}