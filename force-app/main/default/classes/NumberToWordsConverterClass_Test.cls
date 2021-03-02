@isTest
public class NumberToWordsConverterClass_Test {
  @isTest
  public static void testNumberLessThan100() {
    String result = NumberToWordsConverterClass.Number_To_Words(76);
    System.assertEquals('seventy six', result);
    String result1 = NumberToWordsConverterClass.Number_To_Words(100);
    System.assertEquals('One Hundred', result1);
    String result2 = NumberToWordsConverterClass.Number_To_Words(55);
    System.assertEquals('fifty five', result2);
  }

  @isTest
  public static void testNumberLessThan1000() {
    String result = NumberToWordsConverterClass.Number_To_Words(7667);
    System.assertEquals('seven thousand, six hundred sixty seven', result);
  }
}
