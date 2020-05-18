@isTest
public class TestApplicantTriggerHandler {
    
    @testSetup static void setup(){
        List<FinServ__ReciprocalRole__c> roles = new  List<FinServ__ReciprocalRole__c>();
        List<String> roleNames = new String[]{'Emergency Contact','Political Affiliation','JN Affiliation'};
            for(String roleName: roleNames){
                roles.add(TestDataFactory.CreateRole(roleName));
            }
        insert roles;
    }
    
    @isTest
    public static void shouldSetOverallCreditRating(){
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Richards')[0];
        insert acc;
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        List<Applicant__c> newApplicants = new List<Applicant__c>();
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very Low Risk', CreditInfo_Rating__c = 'Very Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very Low Risk', CreditInfo_Rating__c = 'Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very Low Risk', CreditInfo_Rating__c = 'Average Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very Low Risk', CreditInfo_Rating__c = 'Very High Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very Low Risk', CreditInfo_Rating__c = 'Score too low to rate'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very Low Risk', CreditInfo_Rating__c = 'Applicant too new to rate'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Low Risk', CreditInfo_Rating__c = 'Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Low Risk', CreditInfo_Rating__c = 'Very Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Low Risk', CreditInfo_Rating__c = 'Average Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Low Risk', CreditInfo_Rating__c = 'High Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Low Risk', CreditInfo_Rating__c = 'Score too low to rate'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Low Risk', CreditInfo_Rating__c = 'Applicant too new to rate'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Average Risk', CreditInfo_Rating__c = 'Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Average Risk', CreditInfo_Rating__c = 'Average Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Average Risk', CreditInfo_Rating__c = 'Very High Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Average Risk', CreditInfo_Rating__c = 'High Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Average Risk', CreditInfo_Rating__c = 'Score too low to rate'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Average Risk', CreditInfo_Rating__c = 'Applicant too new to rate'));
     	newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'High Risk', CreditInfo_Rating__c = 'Very Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'High Risk', CreditInfo_Rating__c = 'Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'High Risk', CreditInfo_Rating__c = 'Average Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'High Risk', CreditInfo_Rating__c = 'High Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'High Risk', CreditInfo_Rating__c = 'Very High Risk'));
		newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'High Risk', CreditInfo_Rating__c = 'Score too low to rate')); 
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'High Risk', CreditInfo_Rating__c = 'Applicant too new to rate'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very High Risk', CreditInfo_Rating__c = 'Very Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very High Risk', CreditInfo_Rating__c = 'Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very High Risk', CreditInfo_Rating__c = 'Average Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very High Risk', CreditInfo_Rating__c = 'High Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very High Risk', CreditInfo_Rating__c = 'Very High Risk'));
		newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very High Risk', CreditInfo_Rating__c = 'Score too low to rate')); 
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Very High Risk', CreditInfo_Rating__c = 'Applicant too new to rate'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Score too low to rate', CreditInfo_Rating__c = 'Very Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Score too low to rate', CreditInfo_Rating__c = 'Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Score too low to rate', CreditInfo_Rating__c = 'Average Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Score too low to rate', CreditInfo_Rating__c = 'High Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Score too low to rate', CreditInfo_Rating__c = 'Very High Risk'));
		newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Score too low to rate', CreditInfo_Rating__c = 'Score too low to rate')); 
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Score too low to rate', CreditInfo_Rating__c = 'Applicant too new to rate'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Applicant too new to rate', CreditInfo_Rating__c = 'Very Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Applicant too new to rate', CreditInfo_Rating__c = 'Low Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Applicant too new to rate', CreditInfo_Rating__c = 'Average Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Applicant too new to rate', CreditInfo_Rating__c = 'High Risk'));
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Applicant too new to rate', CreditInfo_Rating__c = 'Very High Risk'));
		newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Applicant too new to rate', CreditInfo_Rating__c = 'Score too low to rate')); 
        newApplicants.add(new Applicant__c(Account__c = acc.Id, Opportunity__c = opp.Id, CRIF_Rating__c = 'Applicant too new to rate', CreditInfo_Rating__c = 'Applicant too new to rate')); 
         
        insert newApplicants;
    }
    
    @isTest
    public static void shouldMaximumApplicantsOpportunity(){
        Integer count = 3;
        Test.startTest();
        List<Account> accounts = TestDataFactory.CreateBasicAccounts(count, 'ln');
        //Insert accounts
        insert accounts;
        
        List<Opportunity> opps = TestDataFactory.CreateOpportunities(count);
        for(Integer i = count-1; i >= 0 ; i--){
            opps[i].AccountId = accounts[i].Id;
        }
        // Insert opportunities
        insert opps;
        
        List<Applicant__c> applicants = new List<Applicant__c>();
        // Create applicant with opportunities
        for(Integer i = count-1; i >= 0 ; i--){
            applicants.add(TestDataFactory.CreateApplicant(accounts[0].Id, opps[0].Id));
        }
		// Insert Applicants
		insert applicants;
        update applicants;
        Test.stopTest();
    }
}