({
  doinit: function (component, event, helper) {
    const JNGIPremiumMap = {
      interested: "",
      includeInLoan: "",
      premium: null
    };
    component.set("v.JNGIPremium", JNGIPremiumMap);
  },

  onJNGIPremiumChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.JNGIPremiumContainer"),
      component.get("v.JNGIPremium")
    );
    component.set("v.JNGIPremiumContainer", data);
  },

  onInterestedInJNGIChange: function (component, event, helper) {
    console.log("Interest");
    const selected = event.getSource().get("v.value");
    if (selected === "Yes") {
      console.log("Yes");
      component.set("v.interestedInPremiumFlag", false);
    } else {
      console.log("No");
      component.set("v.interestedInPremiumFlag", true);
      let jngiPremium = component.get("v.JNGIPremium");
      jngiPremium.premium = 0;
      jngiPremium.includeInLoan = null;
      component.set("v.JNGIPremium", jngiPremium);
    }
    let jngiPremium = component.get("v.JNGIPremium");
    jngiPremium.interested = selected;
    console.log(selected);
    // console.log("JNGI PREMIUM: ", JSON.stringify(jngiPremium));
    component.set("v.JNGIPremium", jngiPremium);
    // //disable fields based on whether applicant is interested in JNGI Programme or not
    // if(jngiPremium.interested === 'Yes'){
    //     console.log("DISABLE LOGIC REACHED");
    //     component.set("v.interestedInPremiumFlag", false);
    // } else {
    //     console.log('ELSE BLOCK');
    //     component.set("v.interestedInPremiumFlag", true);
    //     component.find("includePremium").set("v.value", ' ');
    //     let jngiPremium = component.get("v.JNGIPremium");
    //     jngiPremium.premium = 0;
    //     jngiPremium.includeInLoan = null;
    //     component.set("v.JNGIPremium", jngiPremium);
    // }
    // console.log(selected);
  },

  onIncludePremiumChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let jngiPremium = component.get("v.JNGIPremium");
    jngiPremium.includeInLoan = selected;
    component.set("v.JNGIPremium", jngiPremium);
    console.log(selected);
  },

  onInterestedInCreditorLifeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onCoverageTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onIncludeCoverageChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onWaveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onIncludeWaveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onRepaymentMethodChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  }
});
