/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 04-22-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-20-2021   Travis Allen   Initial Version
 **/
global class SkillsBasedRouting {
  public static final String TAG = 'SkillsBasedRouting';
  // public static void routeUsingSkillsTier1(Set<Id> leads) {
  //   //get Sales Development queue id
  //   Group salesDevQueue = [
  //     SELECT Id
  //     FROM Group
  //     WHERE Type = 'Queue' AND Name = 'Sales Development Team'
  //   ];
  //   for (Lead leadObj : [
  //     SELECT Id, Preferred_Location__c, OwnerId
  //     FROM Lead
  //     WHERE Id IN :leads AND OwnerID = :salesDevQueue.Id
  //   ]) {
  //     if (leadObj.Preferred_Location__c != null && leadObj.Service_of_Interest__c!=null) {
  //       PendingServiceRouting pendingSrvRouting = new PendingServiceRouting(
  //         CapacityWeight = 1,
  //         IsReadyForRouting = false,
  //         RoutingModel = 'LeastActive',
  //         RoutingPriority = 1,
  //         RoutingType = 'SkillsBased',
  //         ServiceChannelId = getChannelId('New_lead'),
  //         WorkItemId = leadObj.Id
  //       );
  //       System.debug('JNSkillsRouting' + pendingSrvRouting);
  //       insert pendingSrvRouting;
  //       pendingSrvRouting = [
  //         SELECT Id, IsReadyForRouting
  //         FROM PendingServiceRouting
  //         WHERE Id = :pendingSrvRouting.id
  //       ];

  //       // Now add SkillRequirement(s)
  //       SkillRequirement srObj = new SkillRequirement(
  //         RelatedRecordId = pendingSrvRouting.id,
  //         SkillId = getSkillIdForPreferredLocation(
  //           leadObj.Preferred_Location__c
  //         ),
  //         SkillLevel = 1
  //       );
  //       //new skill requirement for Product
  //       SkillRequirement srObj = new SkillRequirement(
  //         RelatedRecordId = pendingSrvRouting.id,
  //         SkillId = getSkillIdForProductOfInterest(
  //           leadObj.Service_of_Interest__c
  //         ),
  //         SkillLevel = 1
  //       );
  //       insert srObj;
  //       System.debug('Current Skill: ' + srObj);
  //       // Update PendingServiceRouting as IsReadyForRouting
  //       pendingSrvRouting.IsReadyForRouting = true;
  //       update pendingSrvRouting;
  //     }
  //   }
  //   return;
  // }

  private static String getChannelId(String channelName) {
    ServiceChannel channel = [
      SELECT Id
      FROM ServiceChannel
      WHERE DeveloperName = :channelName
    ];
    return channel.Id;
  }
  //Get Skill Id based on preferred location
  private static String getSkillIdForPreferredLocation(
    String preferredLocation
  ) {
    Skill skill = [SELECT Id FROM Skill WHERE MasterLabel = :preferredLocation];
    return skill.Id;
  }
  //Get Skill Id based on product
  private static String getSkillIdForProductOfInterest(String product) {
    Skill skill = [SELECT Id FROM Skill WHERE MasterLabel = :product];
    return skill.Id;
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
  private static String getQueueId(String name) {
    return [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND NAME = :name]
    .Id;
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
    System.debug('All Workers: ' + workers);
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
  public static void routeUsingSkillsTier2(List<Lead> leads) {
    //PriorityQueue pq = new PriorityQueue(new SkillComparator(), Worker.class);
    Set<String> locations = new Set<String>();
    Set<String> products = new Set<String>();
    List<Lead> selectedLeads = new List<Lead>();
    String salesTeam = 'Sales Team';

    Group salesDevQueue = [
      SELECT Id
      FROM Group
      WHERE Type = 'Queue' AND Name = :salesTeam
    ];

    //Get a list locations and products from the leads
    for (Lead record : leads) {
      if (record.OwnerId.equals(salesDevQueue.Id)) {
        if (record.Escalate_to_Tier2__c == true) {
          System.debug(TAG + ' Lead Selected for tier 2 routing');
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
    ]) {
      System.debug(TAG + ' User is a tier 2 member');
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
          SELECT SkillId, Skill.MasterLabel
          FROM ServiceResourceSkills
          WHERE
            SKill.Id IN :mappedLocationSkills.keySet()
            OR Skill.Id IN :mappedProductSkills.keySet()
        )
      FROM serviceresource
      WHERE RelatedRecordId IN :userIds
    ]) {
      System.debug(
        record.RelatedRecordId + ' User is a matched skilled tier 2 member'
      );

      skilledUsers.add(record.RelatedRecordId);

      System.debug(
        TAG +
        'Service Resource Skill List: ' +
        record.ServiceResourceSkills
      );

      for (ServiceResourceSkill skillRecord : record.ServiceResourceSkills) {
        System.debug(TAG + ' Name Of Skill ' + skillRecord.Skill.MasterLabel);
        if (Constants.SKILL_LOCATIONS.contains(skillRecord.Skill.MasterLabel)) {
          if (serviceResourceMap.keySet().contains(record.RelatedRecordId)) {
            serviceResourceMap.get(record.RelatedRecordId)
              .addLocation(skillRecord.Skill.MasterLabel);
          } else {
            ServiceResourceWrapper SRWrapper = new ServiceResourceWrapper(
              record.RelatedRecordId
            );
            SRWrapper.addLocation(skillRecord.Skill.MasterLabel);
            serviceResourceMap.put(record.RelatedRecordId, SRWrapper);
            System.debug(TAG + ' Service Resource Wrapper ' + SRWrapper);
          }
        } else {
          System.debug(TAG + ' Skill is a Product ');
          if (serviceResourceMap.keySet().contains(record.RelatedRecordId)) {
            serviceResourceMap.get(record.RelatedRecordId)
              .addProduct(skillRecord.Skill.MasterLabel);
          } else {
            System.debug(TAG + ' Skill is new product ');
            ServiceResourceWrapper SRWrapper = new ServiceResourceWrapper(
              record.RelatedRecordId
            );
            SRWrapper.addProduct(skillRecord.Skill.MasterLabel);
            serviceResourceMap.put(record.RelatedRecordId, SRWrapper);
            System.debug(TAG + ' Service Resource Wrapper ' + SRWrapper);
          }
        }
      }
    }

    System.debug(
      TAG +
      'Ids for Service Resources Found: ' +
      serviceResourceMap.keySet()
    );

    for (String userId : serviceResourceMap.keySet()) {
      Map<String, Worker> workerhash = serviceResourceMap.get(userId)
        .getWorkerHashMap();
      System.debug(TAG + ' Worker map ' + workerhash);
      mappedWorkerSkills.putAll(workerhash);
    }

    //aggregate leads by service resource user id
    Integer total;
    String userID, location, product;

    System.debug('Skilled Workers: ' + skilledUsers);
    System.debug('Skilled Locations: ' + locations);

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

    //assign the selected leads if aggregations were found
    String leadLocation, leadProduct;
    PriorityQueue pq;
    Worker selectedWorker;

    System.debug(TAG + ' Amount of workers ' + workers.size());

    if (workers.size() > 0) {
      for (Lead selectedLead : selectedLeads) {
        //can optimize by using a set
        leadLocation = selectedLead.Preferred_Location__c;
        leadProduct = selectedLead.Service_of_Interest__c;

        //search aggregate results to match the best record based on lowest capacity and actual location
        pq = getProductLocationQueue(leadLocation, leadProduct, workers);

        if (pq.size() > 0) {
          selectedWorker = (Worker) pq.poll();
          System.debug(TAG + ' Found work ' + selectedWorker);
          selectedWorker.updateWorkLoad();
          //update lead with owner id , who has the least amount of work
          selectedLead.OwnerId = selectedWorker.userId;
        }
      }
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

    public ServiceResourceWrapper(String relatedRecordId) {
      this.relatedRecordId = relatedRecordId;
    }

    public void addProduct(String product) {
      System.debug(TAG + ' Start of add product nmethod ');
      this.newProduct = product;
      this.generateWorkerHashMap();
      this.products.add(product);
      System.debug(TAG + ' End of add product nmethod ');
    }

    public void addLocation(String location) {
      this.locations.add(location);
    }

    public Map<String, Worker> getWorkerHashMap() {
      return this.workerHashMap;
    }

    public void generateWorkerHashMap() {
      String generatedHash;
      if (locations.size() > 0) {
        for (String location : locations) {
          if (!products.contains(newProduct)) {
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
    }
  }
}
