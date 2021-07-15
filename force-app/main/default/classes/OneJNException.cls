/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 07-15-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   07-14-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
public class OneJNException extends Exception {
  /**
   * @description : to generate the JSON containing the details of exception
   * @author Ishwari Gaikwad(Thinqloud) | 07-14-2021
   * @param e
   * @param eventName
   * @return String
   **/
  public String getExceptionJson(
    Exception e,
    String eventName,
    String replayId
  ) {
    String stackTrace = e.getStackTraceString().substringBefore('\n');
    String className = stackTrace.substringAfter('.').substringBefore('.');
    String methodName = stackTrace.substringBefore(':')
      .substringAfter(className)
      .substringAfter('.');
    Map<String, String> jsonData = new Map<String, String>();
    jsonData.put('ProcessName', className);
    jsonData.put('MethodName', methodName);
    jsonData.put('ErrorMessage', e.getMessage());
    jsonData.put('StackTrace', e.getStackTraceString());
    jsonData.put('EventType', eventName);
    jsonData.put('ReplayId', replayId);

    String json = JSON.serialize(jsonData);
    return json;
  }
}
