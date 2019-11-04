global with sharing class JNApplicantFlowController {
    private static final String TAG = 'JNApplicantFlowController';
    @AuraEnabled
    global static List<Account> getContactsAccount(List<String> ids) {
        List<Account> accounts = [SELECT Id,Name FROM Account WHERE PersonContactId in :ids];
        return accounts;
    }
    @AuraEnabled
    global static List<Account> getAccounts(List<String> ids) {
        return [SELECT Id,Name,PersonMobilePhone  FROM Account WHERE id in :ids];
    }
    @AuraEnabled
    global static Object getApplicantDetails(String applicantId){
        try{
            Applicant__c applicant = [SELECT Id,CRIF_Rating__c,CreditInfo_Rating__c,
                                      Overall_Credit_Bureau_Rating__c,Credit_History_in_last_24_Months__c,
                                      Assessment_of_Applicant_Net_Worth__c,Judgements_Filed__c,
                                      Bankrupt_in_Last_7_Years__c,Lawsuits_or_Claims__c,Is_applicant_KYC_Compliant__c,
                                      Rim_Number__c,Primary_Relationship_Tier__c,Affiliation_Type__c,
                                       Time_as_Member_Months__c,Time_as_Member_Years__c,JN_Group_Employee__c,
                                       Sanction_Screening_Completed__c 
                                      FROM Applicant__c WHERE Id =:applicantId];
            if(applicant != null){
                return applicant;
            }
            return null;
        } catch(Exception e){
            return e;
        }
    }
        @AuraEnabled
    global static Object getFullApplicantDetails(String applicantId){
        try{
            Applicant__c applicant = [SELECT Id,Applicable_sources_of_income__c, 
                                      				Salary_and_Allowances_as_per_pay_slips__c,
													Gratuity_in_lieu_of_Pension__c,
													Performance_Based_PayC__c,
													Net_Profit_Sole_Trader__c,
													Director_s_Emoluments_Director__c,
													Share_of_Profit_Partnership__c,
													Share_of_Profit_Shareholder__c,
                                      				Pension__c,
													Existing_Real_Estate_Rental_IC__c,
													Existing_Real_estate_Rental_II__c,
													Projected_Real_Estate_Rental__c,
													Other_Income__c,
                                      				Income_Tax_Monthly_Payment_Prior_Loan__c,
													NIS_Contribution_Monthly_Prior_Loan__c,
													NHT_Contributions_Monthly_Prior_Loan__c,
													Education_Tax_Monthly_Prior_Loan__c,
                                     				Food_Cost_Monthly_Prior_Loan__c,
													Personal_Expenses_Monthly_Prior_Loan__c,
													Child_Care_Costs_Monthly_Prior_Loan__c,
													School_Costs_Monthly_Prior_Loan__c,
													Health_Costs_Monthly_Prior_Loan__c,
													Other_Personal_Family_Costs_Prior_After__c,
													Food_Costs_Monthly_After_Loan__c,
													Personal_Expenses_Monthly_After_Loan__c,
													Child_Care_Costs_Monthly_After_Loan__c,
                                      				School_Costs_Monthly_After_Loan__c,
                                      				Health_Costs_Monthly_After_Loan__c,
                                      				Rent_Board_Monthly_Prior_Loan__c,
                                      				Strata_Maintenance_Monthly_Prior_Loan__c,
                                      				Property_Tax_Monthly_Prior_Loan__c,
                                   					Property_Insurance_Monthly_Prior_Loan__c,
                                      				Property_Maintenance_Monthly_Prior_loan__c,
                                      				Rent_Board_Monthly_After_Loan__c,
                                      				Strata_Maintenance_Monthly_After_Loan__c,
                                      				Property_Tax_Monthly_After_Loan__c,
                                      				Property_Insurance_Monthly_After_Loan__c,
                                      				Property_Maintenance_Monthly_After_Loan__c,
                                      				Electricity_Monthly_Prior_Loan__c,
                                       				Water_Monthly_Prior_Loan__c,
                                      				Cell_Phone_Landline_Monthly_Prior_Loan__c,
                                      				Internet_Cable_Monthly_Prior_Loan__c,
                                      				Cooking_Gas_Monthly_Prior_Loan__c,
                                      				House_Keeping_Monthly_Prior_Loan__c,
                                      				Other_Utilities_Monthly_Prior_Loan__c,
                                      				Fares_Monthly_Prior_Loan__c,
                                      				Toll_Fees_Monthly_Prior_Loan__c,
                                      				Petrol_Fuel_Monthly_Prior_Loan__c,
                                      				Electricity_Monthly_After_Loan__c,
                                      				Water_Monthly_After_Loan__c,
                                      				Cell_Phone_Landline_Monthly_After_Loan__c,
                                      				Internet_Cable_Monthly_After_Loan__c,
                                      				Cooking_Gas_Monthly_After_Loan__c,
                                      				House_Keeping_Costs_Monthly_After_Loan__c,
                                      				Other_Utilities_Monthly_After_Loan__c,
                                      				Fares_Monthly_After_Loan__c,
                                      				Toll_Fees_Monthly_After_Loan__c,
                                      				Petrol_Fuel_Monthly_After_Loan__c,
                                      				Motor_V_Insurance_Monthly_Prior_Loan__c,
                                      				Motor_Vehicle_Reg_Monthly_Prior_Loan__c,
                                      				Motor_V_Maintenance_Monthly_Before_Loan__c,
                                      				Other_Transport_Costs_Monthly_Prior_Loan__c,
                                      				Motor_V_Insurance_Monthly_After_Loan__c,
                                      				Motor_Vehicle_Reg_Monthly_After_Loan__c,
                                      				Motor_Vehicle_Fitness_Monthly_Prior_Loan__c,
                                      				Motor_V_Maintenance_Monthly_After_Loan__c,
                                      				Other_Transport_Monthly_After_Loan__c
                                   					FROM Applicant__c WHERE Id =:applicantId];
            if(applicant != null){
                return applicant;
            }
            return null;
        } catch(Exception e){
            return e;
        }
    }
    @AuraEnabled
    global static Object updateApplicantDetails(Applicant__C applicant){
        try {
            
            if(applicant != null){
                update applicant;
            }
            return applicant;
        } catch(Exception e){
            return e;
        }
    }
        @AuraEnabled
    public static Map<String, List<String>> getPickListValuesList(String objectApiName, List<String> fieldApiNames){
        List<String> pickListValuesList= new List<String>();
        Map<String, List<String>> mapFields = new Map<String, List<String>>();
        
        Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
        Schema.sObjectType sObjType = globalDescription.get(objectApiName);
        Schema.DescribeSObjectResult r1 = sObjType.getDescribe();
        Map<String , Schema.SObjectField> mapFieldList = r1.fields.getMap();
        
        for(String fieldApiName: fieldApiNames){
            Schema.SObjectField field = mapFieldList.get(fieldApiName);
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            pickListValuesList = new List<String>();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            } 
            mapFields.put(fieldApiName, pickListValuesList);
        }
        
        return mapFields;
    }
}