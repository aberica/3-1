// idex_reg.v
// This module is the ID/EX pipeline register.


module idex_reg #(
  parameter DATA_WIDTH = 32
)(
  // TODO: Add flush or stall signal if it is needed

  //////////////////////////////////////
  // Inputs
  //////////////////////////////////////
  input clk,
  input flush,
  input stall,

  input [DATA_WIDTH-1:0] id_PC,
  input [DATA_WIDTH-1:0] id_pc_plus_4,
  // ex control
  input [1:0] id_jump,
  input id_branch,
  input [1:0] id_aluop,
  input id_alusrc,
  // mem control
  input id_memread,
  input id_memwrite,
  // wb control
  input id_memtoreg,
  input id_regwrite,
  input [DATA_WIDTH-1:0] id_sextimm,
  input [6:0] id_funct7,
  input [2:0] id_funct3,
  input [DATA_WIDTH-1:0] id_readdata1,
  input [DATA_WIDTH-1:0] id_readdata2,
  input [4:0] id_rs1,
  input [4:0] id_rs2,
  input [4:0] id_rd,
  input [6:0] opcode,

  //////////////////////////////////////
  // Outputs
  //////////////////////////////////////
  output reg [DATA_WIDTH-1:0] ex_PC,
  output reg [DATA_WIDTH-1:0] ex_pc_plus_4,

  // ex control
  output reg ex_branch,
  output reg [1:0] ex_aluop,
  output reg ex_alusrc,
  output reg [1:0] ex_jump,

  // mem control
  output reg ex_memread,
  output reg ex_memwrite,

  // wb control
  output reg ex_memtoreg,
  output reg ex_regwrite,

  output reg [DATA_WIDTH-1:0] ex_sextimm,
  output reg [6:0] ex_funct7,
  output reg [2:0] ex_funct3,
  output reg [DATA_WIDTH-1:0] ex_readdata1,
  output reg [DATA_WIDTH-1:0] ex_readdata2,
  output reg [4:0] ex_rs1,
  output reg [4:0] ex_rs2,
  output reg [4:0] ex_rd
);

// TODO: Implement ID/EX pipeline register module

always @(posedge clk) begin
  if (flush == 1'b1 || stall == 1'b1) begin
    ex_PC <= 32'h00000000;
    ex_pc_plus_4 <= 32'h00000000;

    ex_branch <= 1'b0;
    ex_aluop <= 2'b00;
    ex_alusrc <= 1'b0;
    ex_jump <= 2'b00;

    // mem control
    ex_memread <= 1'b0;
    ex_memwrite <= 1'b0;

    // wb control
    ex_memtoreg <= 1'b0;
    ex_regwrite <= 1'b0;

    ex_sextimm <= 32'h00000000;
    ex_funct7 <= 7'b000000;
    ex_funct3 <= 3'b000;
    ex_readdata1 <= 32'h00000000;
    ex_readdata2 <= 32'h00000000;
    ex_rs1 <= 5'b0000;
    ex_rs2 <= 5'b0000;
    ex_rd <= 5'b0000;
  end
  else begin
    ex_PC <= id_PC;
    ex_pc_plus_4 <= id_pc_plus_4;

    ex_branch <= id_branch;
    ex_aluop <= id_aluop;
    ex_alusrc <= id_alusrc;
    ex_jump <= id_jump;

    // mem control
    ex_memread <= id_memread;
    ex_memwrite <= id_memwrite;

    // wb control
    ex_memtoreg <= id_memtoreg;
    ex_regwrite <= id_regwrite;

    ex_sextimm <= id_sextimm;
    ex_funct7 <= id_funct7;
    ex_funct3 <= id_funct3;
    case (opcode)
      7'b0110111: ex_readdata1 <= 0;            // LUI
      7'b0010111: ex_readdata1 <= id_PC;        // AUIPC
      default   : ex_readdata1 <= id_readdata1; // default
    endcase
    ex_readdata2 <= id_readdata2;
    ex_rs1 <= id_rs1;
    ex_rs2 <= id_rs2;
    ex_rd <= id_rd;
  end
end

endmodule
