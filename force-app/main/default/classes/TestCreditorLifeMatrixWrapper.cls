/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4186     16/12/2020      Ishwari G.(thinqloud)  Test Class for CreditorLideMatrixWrapper
 **/
@isTest
public with sharing class TestCreditorLifeMatrixWrapper {
  @isTest
  public static void testWrapper1() {
    List<Creditor_Life_Matrix__mdt> creditorMatrixList = [
      SELECT
        Label,
        X0_5__c,
        X1__c,
        X1_5__c,
        X2__c,
        X2_5__c,
        X3__c,
        X3_5__c,
        X4__c,
        X4_5__c,
        X5__c,
        X5_5__c,
        X6__c,
        X6_5__c,
        X7__c,
        X7_5__c,
        X8__c,
        X8_5__c,
        X9__c,
        X9_5__c,
        X10__c
      FROM Creditor_Life_Matrix__mdt
    ];

    Test.startTest();
    CreditorLifeMatrixWrapper wrapper = new CreditorLifeMatrixWrapper(
      creditorMatrixList[0]
    );
    Decimal rating = wrapper.getCreditRating(30, 2.00);
    Test.stopTest();
  }

  @isTest
  public static void testWrapper2() {
    List<Creditor_Life_Matrix__mdt> creditorMatrixList = [
      SELECT
        Label,
        X0_5__c,
        X1__c,
        X1_5__c,
        X2__c,
        X2_5__c,
        X3__c,
        X3_5__c,
        X4__c,
        X4_5__c,
        X5__c,
        X5_5__c,
        X6__c,
        X6_5__c,
        X7__c,
        X7_5__c,
        X8__c,
        X8_5__c,
        X9__c,
        X9_5__c,
        X10__c
      FROM Creditor_Life_Matrix__mdt
    ];

    Test.startTest();
    CreditorLifeMatrixWrapper wrapper = new CreditorLifeMatrixWrapper(
      creditorMatrixList[0]
    );
    Decimal rating = wrapper.getCreditRating(46, 9.37);
    Test.stopTest();
  }
  @isTest
  public static void testWrapper3() {
    List<Creditor_Life_Matrix__mdt> creditorMatrixList = [
      SELECT
        Label,
        X0_5__c,
        X1__c,
        X1_5__c,
        X2__c,
        X2_5__c,
        X3__c,
        X3_5__c,
        X4__c,
        X4_5__c,
        X5__c,
        X5_5__c,
        X6__c,
        X6_5__c,
        X7__c,
        X7_5__c,
        X8__c,
        X8_5__c,
        X9__c,
        X9_5__c,
        X10__c
      FROM Creditor_Life_Matrix__mdt
    ];

    Test.startTest();
    CreditorLifeMatrixWrapper wrapper = new CreditorLifeMatrixWrapper(
      creditorMatrixList[0]
    );
    Decimal rating = wrapper.getCreditRating(46, 10.00);
    Test.stopTest();
  }
  @isTest
  public static void testWrapper4() {
    List<Creditor_Life_Matrix__mdt> creditorMatrixList = [
      SELECT
        Label,
        X0_5__c,
        X1__c,
        X1_5__c,
        X2__c,
        X2_5__c,
        X3__c,
        X3_5__c,
        X4__c,
        X4_5__c,
        X5__c,
        X5_5__c,
        X6__c,
        X6_5__c,
        X7__c,
        X7_5__c,
        X8__c,
        X8_5__c,
        X9__c,
        X9_5__c,
        X10__c
      FROM Creditor_Life_Matrix__mdt
    ];

    Test.startTest();
    CreditorLifeMatrixWrapper wrapper = new CreditorLifeMatrixWrapper(
      creditorMatrixList[0]
    );
    try {
      Decimal rating = wrapper.getCreditRating(46, 12.00);
    } catch (Exception e) {
      Boolean expectedExceptionThrown = e.getMessage()
          .contains(Constants.INVALID_TENURE)
        ? true
        : false;
      System.AssertEquals(expectedExceptionThrown, true);
    }

    Test.stopTest();
  }
}
