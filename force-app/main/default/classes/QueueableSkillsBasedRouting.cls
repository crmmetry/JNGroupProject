/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-15-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-23-2021   Travis Allen   Initial Version
 **/
public with sharing class QueueableSkillsBasedRouting implements Queueable {
  List<Lead> leads = new List<Lead>();
  DateTime currentDateTime;

  public QueueableSkillsBasedRouting(
    List<Lead> leads,
    DateTime currentDateTime
  ) {
    this.leads = leads;
    this.currentDateTime = currentDateTime;
  }

  public void execute(QueueableContext context) {
    SkillsBasedRouting.routeUsingSkillsTier2(this.leads, this.currentDateTime);
  }
}
