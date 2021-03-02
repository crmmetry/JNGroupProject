trigger ContentDocumentTrigger on ContentDocument(after update) {
  if (Trigger.isUpdate) {
    if (Trigger.isAfter) {
      ContentDocTriggerHandler.CheckIfAllDocumentsAreUploaded(Trigger.New);
    }
  }
}
