({
  doInit: function (cmp, event, helper) {
    var ApplicantRow = [
      {
        Id: 0,
        colIndex: "Market",
        Interestrate: "",
        LoanTerm1: "",
        LoanTerm2: "",
        LoanAmount: ""
      }
    ];
    cmp.set("v.RowNum", ApplicantRow);
  },
  addrowdata: function (cmp, event, helper) {
    const EmpRow = cmp.get("v.RowNum");
    var params = event.getParam("arguments");
    if (params) {
      var param1 = params.param1;
      for (var k in param1) {
        var EmpRowstr = JSON.stringify(EmpRow);
        var str = "JN Staff " + param1[k].Id;
        if (
          param1[k].Id == 1 &&
          param1[k].IsJNEmployee &&
          !EmpRowstr.includes(str)
        ) {
          helper.AddRowRequestDetail(param1[k].Id, EmpRow, cmp);
        }
        if (
          param1[k].Id == 2 &&
          param1[k].IsJNEmployee &&
          !EmpRowstr.includes(str)
        ) {
          helper.AddRowRequestDetail(param1[k].Id, EmpRow, cmp);
        }
        if (
          param1[k].Id == 3 &&
          param1[k].IsJNEmployee &&
          !EmpRowstr.includes(str)
        ) {
          helper.AddRowRequestDetail(param1[k].Id, EmpRow, cmp);
        }
        if (
          param1[k].Id == 1 &&
          !param1[k].IsJNEmployee &&
          EmpRowstr.includes(str)
        ) {
          helper.RemoveRowRequestDetail(param1[k].Id, 1, EmpRow, cmp);
        }
        if (
          param1[k].Id == 2 &&
          !param1[k].IsJNEmployee &&
          EmpRowstr.includes(str)
        ) {
          helper.RemoveRowRequestDetail(param1[k].Id, 1, EmpRow, cmp);
        }
        if (
          param1[k].Id == 3 &&
          !param1[k].IsJNEmployee &&
          EmpRowstr.includes(str)
        ) {
          helper.RemoveRowRequestDetail(param1[k].Id, 1, EmpRow, cmp);
        }
      }
    }
    var EmpRowstr = JSON.stringify(EmpRow);
  },
  updateRequestdetails: function (cmp, event, helper) {
    const EmpRow = cmp.get("v.RowNum");
    var Requestdetailevent = $A.get("e.c:Requestdetailevent");

    Requestdetailevent.setParams({
      RequestData: EmpRow
    });
    Requestdetailevent.fire();
  }
});
