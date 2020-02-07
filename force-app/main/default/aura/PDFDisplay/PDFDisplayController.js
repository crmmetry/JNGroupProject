({
 downloadDocument : function(component, event, helper){

  var sendDataProc = component.get("v.sendData");
  var dataToSend = "\'<b><h1> hey nick </h1></b>\
'";

  //invoke vf page js method
  sendDataProc(dataToSend, function(){
              //handle callback
  });
 }
})