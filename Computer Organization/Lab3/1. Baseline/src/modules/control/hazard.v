// hazard.v

// This module determines if pipeline stalls or flushing are required

// TODO: declare propoer input and output ports and implement the
// hazard detection unit

module hazard #(
  parameter DATA_WIDTH = 32
)(
    // Input
    input clk,
    input mem_taken,
    input mem_jump,
    input ex_memread,
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input [4:0] ex_rd,

    // Output
    output reg flush,
    output reg stall
);

always @(negedge clk) begin
    if (mem_taken == 1'b1 || mem_jump == 1'b1) begin
        flush <= 1'b1;
    end
    else begin
        flush <= 1'b0;
    end
end

always @(negedge clk) begin
    if(((id_rs1 != 1'b0 && id_rs1 == ex_rd) || (id_rs2 != 1'b0 && id_rs2 == ex_rd)) && ex_memread==1'b1) begin
        stall <= 1'b1;
    end
    else begin
        stall <= 1'b0;
    end
end

endmodule
