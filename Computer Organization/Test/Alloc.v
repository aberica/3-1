`timescale 1ns/10ps

module Alloc;

reg [5:0] Out;
reg [3:0] In1;

initial begin
    In1 = 3'b100;
    Out[2:1] = In1;

    $display("%b", Out);
end


endmodule