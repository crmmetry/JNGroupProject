({
    convertToMB: function(bytes){
        return bytes/1e+6;
    },
    setCurrentSize: function(component, size){
        const maxSize = component.get("v.maxSize");
        const currentSize = component.get("v.currentSize");
        const convertedMB = this.convertToMB(size);
        let total = convertedMB + currentSize;
        
        if(total <= maxSize ) {
            total = parseInt(total);
            component.set("v.currentSize", total);
            return true;
        }
        return false;
    },
    enableProgress: function(component, name){
        const row = name.split("_")[0];
        const index = name.split("_")[1];
        let list = component.get("v.documentTypeList");
        list[row][index].active = true;
        component.set("v.documentTypeList", list);
    },
        getTabTitle: function(component, name){
        const row = name.split("_")[0];
        const index = name.split("_")[1];
            let list = component.get("v.documentTypeList");
        return list[row][index].title;
    },
   disableProgress: function(component, name){
        const row = name.split("_")[0];
        const index = name.split("_")[1];
        let list = component.get("v.documentTypeList");
        list[row][index].active = false;
       component.set("v.documentTypeList", list);
    },
   showToast: function(component, data) {
    const siteLead = component.get("v.SiteLead");

      //user must complete step 2 and 3 first
      const severity = data.severity; 
      const title = data.title; 
      const message = data.message; 
      const toastContainer = component.find("toastContainer");
      toastContainer.displayMessage(severity, title, message);
    
  },
})