public with sharing class NumberToWordsConverterClass {
  static String[] upto_ninteen_19 = new List<string>{
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen'
  };
  static String[] tensRange_10 = new List<string>{
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety'
  };
  static String[] currencyDenomitor = new List<string>{
    '',
    'thousand',
    'million',
    'billion',
    'trillion'
  };

  public static String convert_Less_Than_100_Number_To_Words(
    integer numberValueTobeConverted
  ) {
    if (numberValueTobeConverted < 20) {
      return upto_ninteen_19[numberValueTobeConverted];
    }
    if (numberValueTobeConverted == 100) {
      return 'One Hundred';
    }
    for (
      integer counterValue = 0;
      counterValue < tensRange_10.size();
      counterValue++
    ) {
      String numberToReturn = tensRange_10[counterValue];
      integer numberVal = 20 + 10 * counterValue;
      if ((numberVal + 10) > numberValueTobeConverted) {
        if (Math.Mod(numberValueTobeConverted, 10) != 0) {
          return numberToReturn +
            ' ' +
            upto_ninteen_19[Math.Mod(numberValueTobeConverted, 10)];
        }
        return numberToReturn;
      }
    }
    return ' ';
  }

  public static String convert_Less_Than_1000_Number_To_Words(
    integer numberValueTobeConverted
  ) {
    String stringOfWord = '';
    integer remainingValue = numberValueTobeConverted / 100;
    integer remainderModValue = Math.mod(numberValueTobeConverted, 100);
    if (remainingValue > 0) {
      stringOfWord = upto_ninteen_19[remainingValue] + ' hundred';
      if (remainderModValue > 0) {
        stringOfWord += ' ';
      }
    }
    if (remainderModValue > 0) {
      stringOfWord += convert_Less_Than_100_Number_To_Words(remainderModValue);
    }
    return stringOfWord;
  }

  public static String Number_To_Words(long numberValue_To_be_Converted) {
    if (numberValue_To_be_Converted <= 100) {
      return convert_Less_Than_100_Number_To_Words(
        numberValue_To_be_Converted.intValue()
      );
    }

    if (numberValue_To_be_Converted < 1000) {
      return convert_Less_Than_1000_Number_To_Words(
        numberValue_To_be_Converted.intValue()
      );
    }

    for (
      integer loopCounter = 0;
      loopCounter < currencyDenomitor.size();
      loopCounter++
    ) {
      integer restToPower = loopCounter - 1;
      integer powerVal = (integer) Math.pow(1000, loopCounter);

      if (powerVal > numberValue_To_be_Converted) {
        integer basicDenomitor = (integer) Math.pow(1000, restToPower);
        integer signleDigit =
          (integer) numberValue_To_be_Converted / basicDenomitor;
        integer remainderValue =
          (integer) numberValue_To_be_Converted -
          (signleDigit * basicDenomitor);
        String returnString =
          convert_Less_Than_1000_Number_To_Words(signleDigit) +
          ' ' +
          currencyDenomitor[restToPower];
        if (remainderValue > 0) {
          returnString += ', ' + Number_To_Words(remainderValue);
        }
        return returnString;
      }
    }
    return ' ';
  }
}
