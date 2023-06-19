`timescale 1ns/10ps

module Wire;

reg A_r, B_r;
wire A_w, B_w, C_w;

initial begin
    A_r = 1'b0;
    B_r = 1'b0;
end

assign A_w = A_r;
assign B_w = B_r;
assign C_w = A_w|B_w;

always @(*) begin
    $display(C_w);
end

endmodule