`timescale 1ns/10ps

module And;

reg A, B, C;

initial begin
    A=1'b1;
    B=1'b1;
    C=1'b1;

    if(A==1'b1 && B==1'b1) begin
        $display("correct\n");
    end
end

endmodule
