module branch_control
(
  // current pc
  input branch,
  input check,

  output reg taken 
);

///////////////////////////////////////////////////////////////////////////////
// TODO : You need to do something!
assign taken = (branch & check);
// 그냥 이걸로 끝...?
//////////////////////////////////////////////////////////////////////////////

endmodule