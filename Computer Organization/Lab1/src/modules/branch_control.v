module branch_control
(
  // current pc
  input branch,
  input check,

  output reg taken 
);

///////////////////////////////////////////////////////////////////////////////
// TODO : You need to do something!
always @(*) begin
  taken = (branch & check);
end
// 그냥 이걸로 끝...?
// beq만 구현되었다. 나머지 bne나 blt 등등은 어떻게 구현하냐
//////////////////////////////////////////////////////////////////////////////

endmodule
