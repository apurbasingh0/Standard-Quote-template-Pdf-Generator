/**
* @description       : used in "QuoteDocumentGenerator" class to generate the Quote Document from standard quote template and save it in the Quote Document Object
* @authorName        : Apurba Singh
* @group             : Appstrail
* @last modified on  : 20-05-2025
* @last modified by  : Apurba Singh
**/
public class QuoteDocumentGenerator {
    
    @future(callout=true)
    public static void generateDocuments(List<Id> quoteIds) {
        try{
            List<QuoteDocument> lstQuoteDoc = new List<QuoteDocument>();
            String quoteTemplateId = Label.Budgetary_Quote_templated_Id;
            
            List<Quote> quotes = [SELECT Id FROM Quote WHERE Id IN :quoteIds];
            
            for (Quote q : quotes) {
                String quoteUrl = '/quote/quoteTemplateDataViewer.apexp?id=' + q.Id +
                    '&headerHeight=197&footerHeight=10&summlid=' + quoteTemplateId;
                
                PageReference pageRef = new PageReference(quoteUrl);
                Blob quoteBlob;
                
                if (Test.isRunningTest()) {
                    quoteBlob = Blob.valueOf('Generate Pdf');
                } else {
                    quoteBlob = pageRef.getContentAsPDF();
                }
                
                QuoteDocument quoteDoc = new QuoteDocument();
                quoteDoc.Document = quoteBlob;
                quoteDoc.QuoteId = q.Id;
                lstQuoteDoc.add(quoteDoc);
            }
            
            if (!lstQuoteDoc.isEmpty()) {
                insert lstQuoteDoc;
            }
        }
        catch (Exception e) {
            System.debug('Error generating quote documents: ' + e.getMessage());
        }
    }
}