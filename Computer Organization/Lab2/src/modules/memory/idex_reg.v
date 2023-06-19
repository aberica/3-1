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

  //////////////////////////////////////
  // Outputs
  //////////////////////////////////////
  output [DATA_WIDTH-1:0] ex_PC,
  output [DATA_WIDTH-1:0] ex_pc_plus_4,

  // ex control
  output ex_branch,
  output [1:0] ex_aluop,
  output ex_alusrc,
  output [1:0] ex_jump,

  // mem control
  output ex_memread,
  output ex_memwrite,

  // wb control
  output ex_memtoreg,
  output ex_regwrite,

  output [DATA_WIDTH-1:0] ex_sextimm,
  output [6:0] ex_funct7,
  output [2:0] ex_funct3,
  output [DATA_WIDTH-1:0] ex_readdata1,
  output [DATA_WIDTH-1:0] ex_readdata2,
  output [4:0] ex_rs1,
  output [4:0] ex_rs2,
  output [4:0] ex_rd
);

// TODO: Implement ID/EX pipeline register module
// Reg
reg [DATA_WIDTH-1:0] ex_PC_reg;
reg [DATA_WIDTH-1:0] ex_pc_plus_4_reg;

// ex control
reg ex_branch_reg;
reg [1:0] ex_aluop_reg;
reg ex_alusrc_reg;
reg [1:0] ex_jump_reg;

// mem control
reg ex_memread_reg;
reg ex_memwrite_reg;

// wb control
reg ex_memtoreg_reg;
reg ex_regwrite_reg;

reg [DATA_WIDTH-1:0] ex_sextimm_reg;
reg [6:0] ex_funct7_reg;
reg [2:0] ex_funct3_reg;
reg [DATA_WIDTH-1:0] ex_readdata1_reg;
reg [DATA_WIDTH-1:0] ex_readdata2_reg;
reg [4:0] ex_rs1_reg;
reg [4:0] ex_rs2_reg;
reg [4:0] ex_rd_reg;


// Assign
assign ex_PC = ex_PC_reg;
assign ex_pc_plus_4 = ex_pc_plus_4_reg;

assign ex_branch = ex_branch_reg;
assign ex_aluop = ex_aluop_reg;
assign ex_alusrc = ex_alusrc_reg;
assign ex_jump = ex_jump_reg;

// mem control
assign ex_memread = ex_memread_reg;
assign ex_memwrite = ex_memwrite_reg;

// wb control
assign ex_memtoreg = ex_memtoreg_reg;
assign ex_regwrite = ex_regwrite_reg;

assign ex_sextimm = ex_sextimm_reg;
assign ex_funct7 = ex_funct7_reg;
assign ex_funct3 = ex_funct3_reg;
assign ex_readdata1 = ex_readdata1_reg;
assign ex_readdata2 = ex_readdata2_reg;
assign ex_rs1 = ex_rs1_reg;
assign ex_rs2 = ex_rs2_reg;
assign ex_rd = ex_rd_reg;

always @(posedge clk) begin
  if (flush == 1'b1 || stall == 1'b1) begin
    ex_PC_reg <= 32'h00000000;
    ex_pc_plus_4_reg <= 32'h00000000;

    ex_branch_reg <= 1'b0;
    ex_aluop_reg <= 2'b00;
    ex_alusrc_reg <= 1'b0;
    ex_jump_reg <= 2'b00;

    // mem control
    ex_memread_reg <= 1'b0;
    ex_memwrite_reg <= 1'b0;

    // wb control
    ex_memtoreg_reg <= 1'b0;
    ex_regwrite_reg <= 1'b0;

    ex_sextimm_reg <= 32'h00000000;
    ex_funct7_reg <= 7'b000000;
    ex_funct3_reg <= 3'b000;
    ex_readdata1_reg <= 32'h00000000;
    ex_readdata2_reg <= 32'h00000000;
    ex_rs1_reg <= 5'b0000;
    ex_rs2_reg <= 5'b0000;
    ex_rd_reg <= 5'b0000;
  end
  else if(stall != 1'b1) begin
    ex_PC_reg <= id_PC;
    ex_pc_plus_4_reg <= id_pc_plus_4;

    ex_branch_reg <= id_branch;
    ex_aluop_reg <= id_aluop;
    ex_alusrc_reg <= id_alusrc;
    ex_jump_reg <= id_jump;

    // mem control
    ex_memread_reg <= id_memread;
    ex_memwrite_reg <= id_memwrite;

    // wb control
    ex_memtoreg_reg <= id_memtoreg;
    ex_regwrite_reg <= id_regwrite;

    ex_sextimm_reg <= id_sextimm;
    ex_funct7_reg <= id_funct7;
    ex_funct3_reg <= id_funct3;
    ex_readdata1_reg <= id_readdata1;
    ex_readdata2_reg <= id_readdata2;
    ex_rs1_reg <= id_rs1;
    ex_rs2_reg <= id_rs2;
    ex_rd_reg <= id_rd;
  end
end

endmodule
