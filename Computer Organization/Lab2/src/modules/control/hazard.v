// hazard.v

// This module determines if pipeline stalls or flushing are required

// TODO: declare propoer input and output ports and implement the
// hazard detection unit

module hazard #(
  parameter DATA_WIDTH = 32
)(
    // Input
    input clk,
    input ex_taken,
    input ex_jump,
    input ex_memread,
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input [4:0] ex_rd,

    // Output
    output [1:0] flush,
    output stall
);

// Reg
reg [1:0] flush_reg;
reg stall_reg;

// Instruction field
assign flush = flush_reg;
assign stall = stall_reg;

always @(negedge clk) begin
    if (ex_taken == 1'b1 || ex_jump == 1'b1) begin
        flush_reg <= 2'b11;
    end
    else begin
        flush_reg <= 2'b00;
    end
end

always @(negedge clk) begin
    if(((id_rs1 != 1'b0 && id_rs1 == ex_rd) | (id_rs2 != 1'b0 && id_rs2 == ex_rd)) & ex_memread==1'b1) begin
        stall_reg <= 1'b1;
    end
    else begin
        stall_reg <= 1'b0;
    end
end

endmodule
