({
  AddRowRequestDetail: function (RowIndex, EmpRow, cmp) {
    EmpRow.push({
      Id: RowIndex,
      colIndex: "JN Staff " + RowIndex,
      Interestrate: "",
      LoanTerm1: "",
      LoanTerm2: "",
      LoanAmount: ""
    });
    EmpRow.sort((a, b) => a.Id - b.Id);
    cmp.set("v.RowNum", EmpRow);
  },
  RemoveRowRequestDetail: function (StartIndex, length, EmpRow, cmp) {
    EmpRow.splice(StartIndex, length);
    cmp.set("v.RowNum", EmpRow);
  }
});