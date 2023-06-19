// forwarding.v

// This module determines if the values need to be forwarded to the EX stage.

// TODO: declare propoer input and output ports and implement the
// forwarding unit

module forwarding #(
  parameter DATA_WIDTH = 32
)(
    // Input
    input [DATA_WIDTH-1:0] PC,

    input [4:0] ex_rs1,
    input [4:0] ex_rs2,

    input [4:0] mem_rd,
    input mem_regwrite,

    input [4:0] wb_rd,
    input wb_regwrite,

    // Output
    output [1:0] forwardA,
    output [1:0] forwardB
);

// Reg
reg [1:0] forwardA_reg;
reg [1:0] forwardB_reg;

// Assign
assign forwardA = forwardA_reg;
assign forwardB = forwardB_reg;

always @(*) begin
    if (PC < 32'h0000_000C) begin
        forwardA_reg <= 2'b00;
    end
    else if (ex_rs1 != 5'b00000 & ex_rs1 == mem_rd & mem_regwrite == 1'b1) begin
        forwardA_reg <= 2'b01;
    end
    else if (ex_rs1 != 5'b00000 & ex_rs1 == wb_rd & wb_regwrite == 1'b1) begin
        forwardA_reg <= 2'b10;
    end
    else begin
        forwardA_reg <= 2'b00;
    end
end

always @(*) begin
    if (PC < 32'h0000_000C) begin
        forwardB_reg = 2'b00;
    end
    else if (ex_rs2 != 5'b00000 & ex_rs2 == mem_rd & mem_regwrite == 1'b1) begin
        forwardB_reg = 2'b01;
    end
    else if (ex_rs2 != 5'b00000 & ex_rs2 == wb_rd & wb_regwrite == 1'b1) begin
        forwardB_reg = 2'b10;
    end
    else begin
        forwardB_reg = 2'b00;
    end
end

endmodule
