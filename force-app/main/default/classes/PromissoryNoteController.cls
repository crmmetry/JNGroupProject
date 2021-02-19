//Sample Applicant Ids are a15f0000002F8z5AAC 	a15f0000002F9sIAAS
//Sample Opportunities Id 006f000000PhctcAAB  006f000000PhpadAAB
//Sample Account Id 001f000001dJOzdAAG	001f000001dXjJ9AAK
public class PromissoryNoteController {
    //Date of Application
    public date dateOfApplication{get;set;}
    public String dateString{get;set;}
    
    //Application ID
    public String applicationIdString{get;set;}
    public Id applicantId{get;set;}
    
    public Account personAccount {get; set;}
    public Applicant__c applicantObject{get; set;}
    public Opportunity oppObject {get; set;}
    public Loan_Calculation_Product__c loanCalculProductObj {get; set;}
    
    public PromissoryNoteController(){
        //Get applicant id from URL
        applicantId = ApexPages.currentPage().getParameters().get(Constants.ID_STRING);
        
        if(applicantId!=Null){
            //Form the date of application value to display in vf page
            dateOfApplication = date.today();
            dateString = dateOfApplication.format();
            
            //Get applicant objects by using the applicant id from URL
            applicantObject = getApplicant(applicantId);
            
            //Get account objects
            personAccount = getAccount(applicantObject.Account__c);
            
            //Get Loan Amount/Limit Value
            loanCalculProductObj = getLoanCalculationProduct(applicantObject.Opportunity__c);
        }
       // Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename= PromissoryNote'); 
    }
    
    private Applicant__c getApplicant(Id applicantId){
        Applicant__c applicantObjectInstance;
        applicantObjectInstance = [SELECT 	Id, 
                                   			Opportunity__c,
                                   			Account__c,
                                   			CurrencyIsoCode
                                   FROM Applicant__c 
                                   WHERE Id =:applicantId];
        
        if(applicantObjectInstance!=Null){
            return applicantObjectInstance;
        }else{
            return Null;
        }
    }
    
    private Account getAccount(Id accountId) {    
        Account accountObj = [SELECT Name,
                              		Street_1__pc,
                              		Street_2__pc,
                              		Street_3__pc,
                              		City_Town__pc,
                              		Residential_Area_District__pc,
                              		Province_Parish_State__pc,
                              		Post_Office_Zip_Code__pc,
                              		Country__c                              
                              FROM Account
                              WHERE Id = :accountId];
        if (accountObj != null) {
            return accountObj;
        }else{
            return Null;   
        }
    }
    
    private Loan_Calculation_Product__c getLoanCalculationProduct(Id oppId){
        Opportunity OppObj = new Opportunity();
        list<Loan_Calculation_Product__c> loanCalPrdct; 
        Loan_Calculation_Product__c loanCalculationProductObj;
        
        OppObj = [SELECT Id,
                  Product_Details__c
                  FROM Opportunity 
                  WHERE Id =: oppId];
     
        if(OppObj!=Null){
            loanCalPrdct = [SELECT Loan_Amount_Number__c,
                            		Interest_Rate_Number__c
                            FROM Loan_Calculation_Product__c 
                            WHERE Loan_Calculation_Id__c =: OppObj.Product_Details__c];
            
            if(loanCalPrdct != Null){
                if(loanCalPrdct.size()>0){
                    loanCalculationProductObj = loanCalPrdct.get(0);         
                    return loanCalculationProductObj;         
                }
            }
            return Null;
        }    
        return Null;
    }
}