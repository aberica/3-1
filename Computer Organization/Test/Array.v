`timescale 1ns/10ps

module Array;

reg [2:0] arr[0:10];

integer i;
initial begin
    for(i = 0; i<8; i=i+1) begin
        arr[i] = i;
    end
    
    for(i = 0; i<8; i=i+1) begin
        $display("%b", arr[i]);
    end

    $display("---------");
    $display("b", arr[0:1]);

    $display("---------");

end

endmodule