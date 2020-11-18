({
  addCss: function (cmpTarget, classToAdd) {
    $A.util.addClass(cmpTarget, classToAdd);
  },

  removeCss: function (cmpTarget, classToRemove) {
    $A.util.removeClass(cmpTarget, classToRemove);
  },
  toggleClass: function (cmp, id, toggleClass) {
    const cmpTarget = cmp.find(id);
    $A.util.toggleClass(cmpTarget, toggleClass);
  }
});