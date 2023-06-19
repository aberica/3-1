`timescale 1ns/10ps

module SeqAlloc;

reg clk;
always begin
  #5 clk = ~clk;
  // $display(clk);
end

reg[3:0] A, B, C;
initial begin
    clk = 1'b0;
    A=4'b0000;
    #200
    $finish;
end
always @(posedge clk) begin
    A<=A+1'b1;
end
always @(posedge clk) begin
    B<=A;
end
always @(posedge clk) begin
    C<=B;
end

always @(posedge clk) begin
    $display("%4b, %4b, %4b", A, B, C);
end

endmodule
