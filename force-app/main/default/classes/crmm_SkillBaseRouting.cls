/**
 * @File Name          : crmm_SkillBaseRouting.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Jermaine Byfield
 * @Last Modified On   : 9/3/2019, 5:55:16 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/3/2019   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
Global class crmm_SkillBaseRouting {
      @ InvocableMethod
      public static void routeUsingSkills(List<String> lead) {
           List<Lead> LeadObjects = [SELECT Id, Description FROM lead WHERE Id in :lead];

     for (Lead LeadObj : LeadObjects) { 
         // Add SkillsBased PendingServiceRouting
         PendingServiceRouting psrObj = new PendingServiceRouting(
             CapacityWeight = 1,
             IsReadyForRouting = FALSE,
             RoutingModel  = 'MostAvailable',
             RoutingPriority = 1,
             RoutingType = 'SkillsBased',
             ServiceChannelId = getChannelId('Case'),
             WorkItemId = LeadObj.Id
             );
         insert psrObj;
         psrObj = [select id, IsReadyForRouting from PendingServiceRouting where id = : psrObj.id];
         
         // Now add SkillRequirement(s)
         SkillRequirement srObj = new SkillRequirement(
             RelatedRecordId = psrObj.id,
             SkillId = getSkillId(LeadObj.Description),
             SkillLevel = 5
             );
         insert srObj;
         
         // Update PendingServiceRouting as IsReadyForRouting
         psrObj.IsReadyForRouting = TRUE;
         update psrObj;
     }
     return;
  }
  
  public static String getChannelId(String channelName) {
      ServiceChannel channel = [Select Id From ServiceChannel Where DeveloperName = :channelName];
      return channel.Id;
  }
  
  public static String getSkillId(String caseDescription) {
      String skillName = 'English';
      if (caseDescription != null) {
          if (caseDescription.contains('Spanish')) {
              skillName = 'Spanish';
          } else if (caseDescription.contains('French')) {
              skillName = 'French';
          }
      }
      
      Skill skill = [Select Id From Skill Where DeveloperName = :skillName];
      return skill.Id;
  }
}