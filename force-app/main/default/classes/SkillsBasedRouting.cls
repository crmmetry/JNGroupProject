Global class SkillsBasedRouting {
    public static void JNSkillsRouting(Set<Id> leads) {
        List<Lead> leadObjects = [SELECT Id, Preferred_Location__c,OwnerId   FROM Lead WHERE Id in :leads];
        System.debug('JNSkillsRouting' + leadObjects);
        for (Lead leadObj : leadObjects) {
            // Add SkillsBased PendingServiceRouting
            if(leadObj.OwnerId.equals(getQueueId('Sales Team'))){
            PendingServiceRouting pendingSrvRouting = new PendingServiceRouting(
                CapacityWeight = 1,
                IsReadyForRouting = FALSE,
                RoutingModel  = 'MostAvailable',
                RoutingPriority = 1,
                RoutingType = 'SkillsBased',
                ServiceChannelId = getChannelId('New_lead'),
                WorkItemId = leadObj.Id
            );
                System.debug('JNSkillsRouting' + pendingSrvRouting);
            INSERT pendingSrvRouting;
            pendingSrvRouting = [SELECT Id, IsReadyForRouting FROM 
                                 PendingServiceRouting WHERE Id = : pendingSrvRouting.id];
            
            // Now add SkillRequirement(s)
            SkillRequirement srObj = new SkillRequirement(
                RelatedRecordId = pendingSrvRouting.id,
                SkillId = getSkillId(leadObj.Preferred_Location__c ),
                SkillLevel = 5
            );
            insert srObj;
            
            // Update PendingServiceRouting as IsReadyForRouting
            pendingSrvRouting.IsReadyForRouting = TRUE;
            update pendingSrvRouting;
        }
        }
        return;
    }
    
    private static String getChannelId(String channelName) {
        ServiceChannel channel = [Select Id From ServiceChannel Where DeveloperName = :channelName];
        return channel.Id;
    }
    
    private static String getSkillId(String preferedLocation) {
        Skill skill = [Select Id From Skill Where DeveloperName = :preferedLocation];
        return skill.Id;
    }
    private static String getQueueId(String name) {
        return [select Id,Name from Group where  Type = 'Queue' AND NAME = :name].Id;

    }
}