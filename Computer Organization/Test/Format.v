`timescale 1ns/10ps

module Format;

reg [2:0] A;

initial begin
    A = 3'b111;
    $display("%b", 3'h6);
end

always @(*) begin
    if(A == 3'h7) begin
        $display("true");
    end
    else $display("false");
end

endmodule
