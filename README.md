"# Standard-Quote-template-Pdf-Generator" 
# Standard Quote Template PDF Generator

This Salesforce Apex class, `QuoteDocumentGenerator`, automates the generation of standard quote PDFs using a standard template Id.

---

## 🔧 Overview

- **Class Name:** `QuoteDocumentGenerator`
- **Purpose:** Automatically generates and attaches PDF documents to Quotes.
- **Trigger Type:** `@future(callout=true)` (Asynchronous for callout compatibility)

---

## 📄 Features

- Generates PDF documents from a standard quote template.
- Supports bulk operation using `@future` to handle multiple Quotes at once.
- Safely handles test context using `Test.isRunningTest()`.
- Automatically inserts generated `QuoteDocument` records.

---

## Get Standard Quote template Id

- got to standard template and choose the id which start with '0EH5g00....'
- then store it in the custom labels
- then call in the link :- '/quote/quoteTemplateDataViewer.apexp?id=' + q.Id +'&headerHeight=197&footerHeight=10&summlid=' + quoteTemplateId;


