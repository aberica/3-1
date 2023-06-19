`timescale 1ns/10ps

module Equal;

reg [3:0] A;

initial begin
    A = 4'b1110;
    if(A != 0) $display("True");
    else $display("False");
end

endmodule