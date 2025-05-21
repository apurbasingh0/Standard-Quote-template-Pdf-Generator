@isTest
public class QuoteDocumentGeneratorTest {
    
    @isTest
    static void testGenerateQuoteDocuments() {
        // Create Account
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Create Specifier
        PLSI_Specifier__c spp = new PLSI_Specifier__c(
            First_Name__c='TestSpecifier',
            Last_Name__c = 'test',
            PLSI_Role__c='Architect',
            PLSI_Email__c='abctest@gmail.com'
        );
        insert spp;

        // Insert Custom Setting
        allowupdateopplineitem__c cs = new allowupdateopplineitem__c(Name='isallowed', allowupdate__c = false);
        insert cs;

        // Pricebook and Products
        Id pricebookId = Test.getStandardPricebookId();
        List<Product2> ProdList = new List<Product2>{
            new Product2(Name='testproduct', IsActive=true, PLSI_ItemId__c='A1234'),
            new Product2(Name='testproduct', IsActive=true, PLSI_ItemId__c='B1234'),
            new Product2(Name='testproduct', IsActive=true, PLSI_ItemId__c='C1234')
        };
        insert ProdList;

        List<PricebookEntry> PEList = new List<PricebookEntry>();
        for (Product2 prd : ProdList) {
            PEList.add(new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=prd.Id, UnitPrice=1000, IsActive=true));
        }
        insert PEList;

        // Product Approval Hierarchies
        List<Product_Approval_Hierarchy__c> AHList = new List<Product_Approval_Hierarchy__c>();
        for (Product2 prd : ProdList) {
            AHList.add(new Product_Approval_Hierarchy__c(
                Product__c = prd.Id,
                Record_Type__c = 'Power Project',
                Discount_Max__c = 59,
                Sales_Discount__c = 53,
                Discount_Percentage__c = 58,
                Above_Policy_Discount_Percentage__c = 60,
                Approval_Level__c = 20,
                Approval_Max__c = 30,
                Approval_grt_max__c = 40,
                Above_Policy_Level__c = 50
            ));
        }
        insert AHList;

        // Create Opportunity
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
            .get('PLSI_Power_Project').getRecordTypeId();

        Opportunity opp = new Opportunity(
            Name='Test Opp',
            PLSI_Project_Name__c='Test Project Name',
            StageName='Prospecting',
            RecordTypeId=recid,
            PLSI_Business_Unit__c = 'Power Project',
            PLSI_Expected_value_WCT__c = 10000.00,
            PLSI_Expected_value_CMS__c = 10000.00,
            PLSI_Expected_value_SWG__c = 10000.00,
            PLSI_Expected_value_WD__c = 10000.00,
            PLSI_Expected_value_WH__c = 10000.00,
            PLSI_CRM_ID__c = 'abc1234',
            CloseDate = System.today().addMonths(11),
            AccountId = acc.Id,
            PLSI_Specifier_Id__c = spp.Id,
            Re_Work__c = false,
            Pricebook2Id = pricebookId,
            PLSI_Price_Validity__c = Date.Today().addDays(5),
            Approval_Status__c = 'Not Approved',
            PLSI_CMS_Status__c = 'In-Progress',
            PLSI_SWG_Status__c = 'In-Progress',
            PLSI_WH_Status__c = 'In-Progress',
            PLSI_WCT_Status__c = 'In-Progress',
            PLSI_WD_Status__c = 'In-Progress'
        );
        insert opp;

        // Add Opportunity Line Items
        List<OpportunityLineItem> OLList = new List<OpportunityLineItem>();
        for (Integer i = 0; i < 3; i++) {
            OLList.add(new OpportunityLineItem(
                Quantity = 1,
                Discount = 20 + i,
                Competitor_Price__c = 1500,
                Competitor_range__c = 'Wires',
                Competitor_Name__c = 'testname' + (i + 1),
                Categore_Updated__c = false,
                ProductCategUpdated__c = true,
                Discount_Offered__c = 20,
                OpportunityId = opp.Id,
                Schedule_Ship_Date__c = Date.today().addDays(5),
                TotalPrice = 1000,
                Product2Id = ProdList[i].Id,
                PricebookEntryId = PEList[i].Id
            ));
        }
        insert OLList;

        // Create a Quote
        Quote quote = new Quote(
            Name = 'Test Quote',
            OpportunityId = opp.Id,
            Status = 'Draft',
            Quote_Type__c = 'Budgetory Quote',
            Pricebook2Id = pricebookId
        );
        insert quote;

        // Invoke the future method
        Test.startTest();
            QuoteDocumentGenerator.generateDocuments(new List<Id>{quote.Id});
        Test.stopTest();

        // Assert a QuoteDocument is created
        List<QuoteDocument> docs = [SELECT Id, QuoteId FROM QuoteDocument WHERE QuoteId = :quote.Id];
        System.assertEquals(1, docs.size(), 'A QuoteDocument should be generated for the Quote');
    }

}