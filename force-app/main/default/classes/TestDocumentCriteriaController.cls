@isTest(seeAllData=false)
public  class TestDocumentCriteriaController {



    @isTest
    public static void shouldDocumentCriteriaControllerOfficer(){
        Pagereference pageReference = Page.DocumentCriteriaOfficer;
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put('kycdone', '1');
        ApexPages.currentPage().getParameters().put('location', 'Kingston');
        ApexPages.currentPage().getParameters().put('commision', 'Overtime');
        ApexPages.currentPage().getParameters().put('payslip', 'general');
        ApexPages.currentPage().getParameters().put('loc', '1');
        ApexPages.currentPage().getParameters().put('isloc', '1');
        ApexPages.currentPage().getParameters().put('autoin', '1');
        ApexPages.currentPage().getParameters().put('autovc', '1');
        ApexPages.currentPage().getParameters().put('credit', '1');

        ApexPages.currentPage().getParameters().put('incr', '1');
        ApexPages.currentPage().getParameters().put('kyc', '1');
        ApexPages.currentPage().getParameters().put('uns', 'Education');
        ApexPages.currentPage().getParameters().put('autolp', '1');
        
        DocumentCriteriaController controller = new DocumentCriteriaController();
        System.assert(controller != null, 'controller null');
    }
        @isTest
    public static void shouldDocumentCriteriaControllerOfficerAll(){
        Map<String, String> params = new Map<String, String> {
            'Education' => 'uns',
            'Debt' => 'uns',
            'Medical' => 'uns',
            'HomeImprovement' => 'uns',
            'AssetAcquisition' => 'uns',
            'Other' => 'uns',
            'AutoRepair' => 'uns',
            'Salaried' => 'incr',
            'Pension' => 'incr',
            'NetProfit' => 'incr',
            'CompanyDirector' => 'incr',
            'ShareofProfitPartnership' => 'incr',
            'ShareofProfitShareholder' => 'incr',
            'PropertyRental' => 'incr',
            'ProofofIdentity' => 'kyc',
            'ProofofAge' => 'kyc',
            'ProofofAddress' => 'kyc',
            'TRN' => 'kyc',
            'FATCA' => 'kyc'   
        };
        for(String key: params.keySet()){
             ApexPages.currentPage().getParameters().put(params.get(key),key);
             System.assert(new DocumentCriteriaController() != null, 'controller null');
        }
    }
    @isTest
    public static void shouldDownloadPDF(){
        DocumentCriteriaController controller = new DocumentCriteriaController();
        Pagereference pageReference = controller.downloadPDF();
        System.assert(pageReference != null, 'controller null');
        System.assertEquals(pageReference.getUrl(), '/apex/DocumentCriteriaDoc', 'incorrect url');
    }


}