/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 04-21-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-21-2021   Travis Allen   Initial Version
 **/
public with sharing class ServiceResourceWrapper {
  public String relatedRecord;
  public static Set<String> products;
  public static Set<String> locations;
  public static Map<String, Worker> workerHashMap;
  public static String newProduct = '';

  public ServiceResourceWrapper(ServiceResource record) {
    this.relatedRecord = record.RelatedRecordId;
    this.products = record.products;
    this.locations = record.locations;
    this.workerHashMap = new Map<String, Worker>();
  }

  public static void generateWorkerHashMap() {
    String generatedHash;
    for (String location : locations) {
      generatedHash = Util.GenerateHash(
        new List<String>{ relatedRecordId, newProduct, location }
      );
      workerHashMap.put(
        generatedHash,
        new Worker(relatedRecordId, 0, location, newProduct)
      );
    }
  }
}
