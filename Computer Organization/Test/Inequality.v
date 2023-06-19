`timescale 1ns/10ps

module Inequality;

reg signed [2:0] A;
localparam param = -10;


initial begin
    A = 3'b011;
    $display("%b", A);
end

always @(*) begin
    if(A >= param) $display("true");
    else $display("false");
end

endmodule
