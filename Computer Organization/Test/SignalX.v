`timescale 1ns/10ps

module SignalX;

reg [3:0] A;
initial begin
    A = 4'b0x1x;
    $display("%b", A);
    if(A[0] == 0) $display("t1");
    if(A[0] == 1) $display("t2");
    
    if(A == 4'b0011) $display("t3");
end
endmodule