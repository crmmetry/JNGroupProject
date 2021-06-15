/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-15-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-20-2021   Travis Allen   Initial Version
 **/
global with sharing class SkillsBasedRouting {
  public static final String TAG = 'SkillsBasedRouting';
  public static Boolean inRecursiveUpdate = false;

  public static void StartRoutingUsingTier2(
    List<Lead> leads,
    DateTime currentDateTime
  ) {
    if (inRecursiveUpdate)
      return;
    System.enqueueJob(new QueueableSkillsBasedRouting(leads, currentDateTime));
  }

  //Get a map of all skills with preferred location
  private static Map<Id, Skill> getLocationSkills(Set<String> locations) {
    return new Map<Id, Skill>(
      [SELECT Id FROM Skill WHERE MasterLabel IN :locations]
    );
  }

  //Get a map of all skills with products of interest
  private static Map<Id, Skill> getProductSkills(Set<String> products) {
    return new Map<Id, Skill>(
      [SELECT Id FROM Skill WHERE MasterLabel IN :products]
    );
  }

  private static PriorityQueue getProductLocationQueue(
    String leadLocation,
    String leadProduct,
    List<Worker> workers
  ) {
    PriorityQueue pq = new PriorityQueue(
      new SkillComparator(),
      SkillsBasedRouting.Worker.class
    );
    for (Worker record : workers) {
      if (
        leadLocation.equals(record.location) &&
        leadProduct.equals(record.product)
      ) {
        pq.offer(record);
      }
    }
    return pq;
  }

  public static void routeUsingSkillsTier2(
    List<Lead> leads,
    DateTime currentDateTime
  ) {
    Set<String> locations = new Set<String>();
    Set<String> products = new Set<String>();
    List<Lead> selectedLeads = new List<Lead>();
    String salesTeam = 'Sales Team';

    Group salesDevQueue = [
      SELECT Id
      FROM Group
      WHERE Type = 'Queue' AND Name = :salesTeam
      WITH SECURITY_ENFORCED
    ];

    //Get a list locations and products from the leads
    for (Lead record : leads) {
      if (record.OwnerId.equals(salesDevQueue.Id)) {
        if (record.Escalate_to_Tier2__c == true) {
          selectedLeads.add(record);
          locations.add(record.Preferred_Location__c);
          products.add(record.Service_of_Interest__c);
        }
      }
    }

    // get all skills that match preferred location and product of interest
    Map<Id, Skill> mappedLocationSkills = getLocationSkills(locations);
    Map<Id, Skill> mappedProductSkills = getProductSkills(products);
    List<Id> userIds = new List<Id>();
    Set<Id> skilledUsers = new Set<Id>(); //users found with the skill
    List<Worker> workers = new List<Worker>();

    for (GroupMember record : [
      SELECT UserOrGroupId
      FROM GroupMember
      WHERE Group.Name = :salesTeam AND Group.Type = 'Queue'
      WITH SECURITY_ENFORCED
    ]) {
      userIds.add(record.UserOrGroupId);
    }

    Map<String, ServiceResourceWrapper> serviceResourceMap = new Map<String, ServiceResourceWrapper>();
    //get all service resource with associated users hascode
    Map<String, Worker> mappedWorkerSkills = new Map<String, Worker>();
    //List<String> hashStrings;
    String generatedHash;

    for (serviceresource record : [
      SELECT
        Id,
        RelatedRecordId,
        (
          SELECT
            SkillId,
            Skill.MasterLabel,
            EffectiveStartDate,
            EffectiveEndDate
          FROM ServiceResourceSkills
          WHERE
            (SKill.Id IN :mappedLocationSkills.keySet()
            OR Skill.Id IN :mappedProductSkills.keySet())
            AND EffectiveStartDate < :currentDateTime
            AND EffectiveEndDate > :currentDateTime
        )
      FROM serviceresource
      WHERE RelatedRecordId IN :userIds
      WITH SECURITY_ENFORCED
    ]) {
      for (ServiceResourceSkill skillRecord : record.ServiceResourceSkills) {
        if (Constants.SKILL_PRODUCTS.contains(skillRecord.Skill.MasterLabel)) {
          if (serviceResourceMap.keySet().contains(record.RelatedRecordId)) {
            serviceResourceMap.get(record.RelatedRecordId)
              .addProduct(skillRecord.Skill.MasterLabel);
          } else {
            ServiceResourceWrapper SRWrapper = new ServiceResourceWrapper(
              record.RelatedRecordId
            );
            SRWrapper.addProduct(skillRecord.Skill.MasterLabel);
            serviceResourceMap.put(record.RelatedRecordId, SRWrapper);
          }
        } else {
          if (serviceResourceMap.keySet().contains(record.RelatedRecordId)) {
            serviceResourceMap.get(record.RelatedRecordId)
              .addLocation(skillRecord.Skill.MasterLabel);
          } else {
            ServiceResourceWrapper SRWrapper = new ServiceResourceWrapper(
              record.RelatedRecordId
            );
            SRWrapper.addLocation(skillRecord.Skill.MasterLabel);
            serviceResourceMap.put(record.RelatedRecordId, SRWrapper);
          }
        }
      }
    }

    for (String userId : serviceResourceMap.keySet()) {
      Map<String, Worker> workerhash = serviceResourceMap.get(userId)
        .getWorkerHashMap();
      mappedWorkerSkills.putAll(workerhash);
    }

    //aggregate leads by service resource user id
    Integer total;
    String userID, location, product;

    //loops through an aggregate of leads based on the total amount leads in owned by sales team user.
    for (AggregateResult record : [
      SELECT
        COUNT(Id) total,
        Preferred_Location__c,
        Service_of_Interest__c,
        OwnerId
      FROM Lead
      WHERE
        Preferred_Location__c IN :locations
        AND OwnerId IN :skilledUsers
        AND Service_of_Interest__c IN :products
      WITH SECURITY_ENFORCED
      GROUP BY OwnerId, Preferred_Location__c, Service_of_Interest__c
      ORDER BY COUNT(Id)
    ]) {
      total = (Integer) record.get('total');
      userID = (String) record.get('OwnerId');
      location = (String) record.get('Preferred_Location__c');
      product = (String) record.get('Service_of_Interest__c');

      generatedHash = Util.GenerateHash(
        new List<String>{ userID, location, product }
      );

      if (mappedWorkerSkills.containsKey(generatedHash)) {
        mappedWorkerSkills.get(generatedHash).setWorkLoad(total);
      }
    }

    //add all the workers
    workers.addAll(mappedWorkerSkills.values());
    List<Lead> leadsToUpdate = new List<Lead>();
    //assign the selected leads if aggregations were found
    String leadLocation, leadProduct;
    PriorityQueue pq;
    Worker selectedWorker;

    if (workers.size() > 0) {
      for (Lead selectedLead : selectedLeads) {
        //can optimize by using a set
        leadLocation = selectedLead.Preferred_Location__c;
        leadProduct = selectedLead.Service_of_Interest__c;

        //search aggregate results to match the best record based on lowest capacity and actual location
        pq = getProductLocationQueue(leadLocation, leadProduct, workers);

        if (pq.size() > 0) {
          selectedWorker = (Worker) pq.poll();
          selectedWorker.updateWorkLoad();
          //update lead with owner id , who has the least amount of work
          //selectedLead.OwnerId = selectedWorker.userId;
          Lead newLead = new Lead(
            Id = selectedLead.Id,
            OwnerId = selectedWorker.userId
          );
          leadsToUpdate.add(newLead);
        }
      }
      inRecursiveUpdate = true;
      update leadsToUpdate;
    }
    //}
  }
  //Add Position to the worker class as a skill
  class Worker implements Comparable {
    public Id userId;
    public Integer workLoad;
    public String location;
    public String product;
    public Worker(
      Id userId,
      Integer workLoad,
      String location,
      String product
    ) {
      this.location = location;
      this.product = product;
      this.workLoad = workLoad;
      this.userId = userId;
    }
    public void updateWorkLoad() {
      this.workLoad = this.workLoad + 1;
    }
    public void setWorkLoad(Integer value) {
      this.workLoad = value;
    }
    public Integer compareTo(Object work) {
      if (workLoad < ((Worker) work).workLoad)
        return -1;
      else if (workLoad > ((Worker) work).workLoad)
        return 1;
      return 0;
    }
  }
  class SkillComparator implements Comparator {
    public Integer compare(Object a, Object b) {
      return ((worker) a).compareTo((worker) b);
    }
  }
  //Wrapper class to wrap a serviceResource record
  class ServiceResourceWrapper {
    public String relatedRecordId;
    public Set<String> products = new Set<String>();
    public Set<String> locations = new Set<String>();
    public Map<String, Worker> workerHashMap = new Map<String, Worker>();
    public String newProduct;
    public String newLocation;

    public ServiceResourceWrapper(String relatedRecordId) {
      this.relatedRecordId = relatedRecordId;
    }

    //Adds new product and creates new workers from the existing locations and new products combination
    public void addProduct(String product) {
      this.newProduct = product;
      this.generateWorkerHashMapWithNewProduct();
      this.products.add(product);
    }

    //Adds new location and creates new workers from the existing products and new location combination
    public void addLocation(String location) {
      this.newLocation = location;
      this.generateWorkerHashMapWithNewLocation();
      this.locations.add(location);
    }

    public Map<String, Worker> getWorkerHashMap() {
      return this.workerHashMap;
    }

    //Maintains worker hash map to ensure that a worker object is created for all combination for worker and location skills for the service resource
    public void generateWorkerHashMapWithNewProduct() {
      String generatedHash;
      if (
        this.locations.size() > 0 && !this.products.contains(this.newProduct)
      ) {
        for (String location : this.locations) {
          generatedHash = Util.GenerateHash(
            new List<String>{ this.relatedRecordId, location, this.newProduct }
          );
          this.workerHashMap.put(
            generatedHash,
            new Worker(this.relatedRecordId, 0, location, this.newProduct)
          );
        }
      }
    }

    public void generateWorkerHashMapWithNewLocation() {
      String generatedHash;
      if (
        this.products.size() > 0 && !this.locations.contains(this.newLocation)
      ) {
        for (String product : this.products) {
          generatedHash = Util.GenerateHash(
            new List<String>{ this.relatedRecordId, this.newLocation, product }
          );
          this.workerHashMap.put(
            generatedHash,
            new Worker(this.relatedRecordId, 0, this.newLocation, product)
          );
        }
      }
    }
  }
}
