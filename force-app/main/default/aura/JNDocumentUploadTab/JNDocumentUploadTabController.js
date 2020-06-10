({
  doInit: function(component, event, helper) {
    const documentTypeList = [
      [
        {
          title: "Proof of Identity",
          sub_title: "Valid identification",
          body: "driver’s licence, passport, voter registration card",
          active: false
        },
        {
          title: "Proof of Address",
          sub_title: "Valid proof of address",
          body: "recent utility bill, receipt",
          active: false
        },
        {
          title: "Proof of Income",
          sub_title: "Valid proof of income",
          body: "letter from employer, pay slips",
          active: false
        }
      ],
      [
        {
          title: "Proof of Purpose",
          sub_title: "Valid Proof of Purpose",
          body: "quote, invoice",
          active: false
        },
        {
          title: "Proof of Tax",
          sub_title: "Valid Proof of Tax",
          body: "TRN card, driver’s licence",
          active: false
        },
        {
          title: "Proof of Age",
          sub_title: "Valid proof of age",
          body:
            "driver’s licence, passport, voter registration card, birth certificate",
          active: false
        }
      ]
    ];
    component.set("v.documentTypeList", documentTypeList);
    component.set("v.maxSize", 30);
  },
  handleFilesChange: function(component, event, helper) {
    
    const MAX_FILE_SIZE = 5000000;
    let fileName = "No File Selected..";
      if(!component.get("v.leadId")){
           helper.showToast(component, {
                    severity: "error",
                    message: "Please complete step 2 & 3 before attempting a document upload."
            });
          return;
      }
    if (event.getSource().get("v.files").length > 0) {
      fileName = event.getSource().get("v.files")[0]["name"];
      const cmpName = event.getSource().get("v.name");
      
      const tabTitle = helper.getTabTitle(component, cmpName);
      component.set("v.fileName", fileName);
      let fileInput = event.getSource().get("v.files")[0];
      // get the first file using array index[0]
      let file = fileInput;
      if (file.size > MAX_FILE_SIZE) {
            helper.showToast(component, {
                    severity: "error",
                    message: "5MB is the max allowed upload size."
            });
        return;
      }
      helper.enableProgress(component, cmpName);
      helper.setCurrentSize(component, file.size);

      // create a FileReader object
      let objFileReader = new FileReader();
      // set onload function of FileReader object
      objFileReader.onload = $A.getCallback(function() {
        let fileContents = objFileReader.result;
        let base64result = fileContents.split(",")[1];

        let action = component.get("c.saveFile");
        action.setParams({
          parentId: component.get("v.leadId"),
          fileName: file.name,
          base64Data: base64result,
          contentType: file.type,
          tabTitle:tabTitle,
        });

        // set call back
        action.setCallback(this, function(response) {
          helper.disableProgress(component, cmpName);
            if(response.getState() == 'SUCCESS'){
                helper.showToast(component, {
                    severity: "confirm",
                    message: "Your document was successfully uploaded."
                });
            } else {
               helper.showToast(component, {
                    severity: "error",
                    message: "There was a error uploading this document."
          	   });
            }
           
        });
        $A.enqueueAction(action);
      });

      objFileReader.readAsDataURL(file);
    }
  }
});