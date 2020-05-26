({
documentapplicant: function(cmp, evt, helper){
        var appEvent = $A.get("e.c:DocumentCriteriaEvent"); 
        //Set event attribute value
        appEvent.setParams({"message" : "Welcome "}); 
        appEvent.fire();
    alert(1);
        
    },
    downloadDocument : function(component, event, helper){
    alert(4);
var message = event.getParam("message1"); 
      alert('====='+message);  //Set the handler attributes based on event data 
        
var sendDataProc = component.get("v.sendData");
var dataToSend = {
"label" : "This is test updated by naresh"
}; //this is data you want to send for PDF generation



//invoke vf page js method
sendDataProc(dataToSend, function(){
//handle callback
});
},

})