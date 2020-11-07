/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_FinServ_EmploymentTest {
  @IsTest
  private static void testTrigger() {
    // Force the dlrs_FinServ_EmploymentTrigger to be invoked, fails the test if org config or other Apex code prevents this.
    dlrs.RollupService.testHandler(new FinServ__Employment__c());
  }
}
