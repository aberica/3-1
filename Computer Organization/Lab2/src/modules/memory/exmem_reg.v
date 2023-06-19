//exmem_reg.v


module exmem_reg #(
  parameter DATA_WIDTH = 32
)(
  // TODO: Add flush or stall signal if it is needed

  //////////////////////////////////////
  // Inputs
  //////////////////////////////////////
  input clk,

  input [DATA_WIDTH-1:0] ex_pc_plus_4,
  input [DATA_WIDTH-1:0] ex_pc_target,
  input ex_taken,
  // mem control
  input ex_memread,
  input ex_memwrite,
  // wb control
  input [1:0] ex_jump,
  input ex_memtoreg,
  input ex_regwrite,
  input [DATA_WIDTH-1:0] ex_alu_result,
  input [DATA_WIDTH-1:0] ex_writedata,
  input [2:0] ex_funct3,
  input [4:0] ex_rd,
  
  //////////////////////////////////////
  // Outputs
  //////////////////////////////////////
  output [DATA_WIDTH-1:0] mem_pc_plus_4,
  output [DATA_WIDTH-1:0] mem_pc_target,
  output mem_taken,

  // mem control
  output mem_memread,
  output mem_memwrite,

  // wb control
  output [1:0] mem_jump,
  output mem_memtoreg,
  output mem_regwrite,
  
  output [DATA_WIDTH-1:0] mem_alu_result,
  output [DATA_WIDTH-1:0] mem_writedata,
  output [2:0] mem_funct3,
  output [4:0] mem_rd
);

// TODO: Implement EX / MEM pipeline register module
  // Reg
  reg [DATA_WIDTH-1:0] mem_pc_plus_4_reg;
  reg [DATA_WIDTH-1:0] mem_pc_target_reg;
  reg mem_taken_reg;

  // mem control
  reg mem_memread_reg;
  reg mem_memwrite_reg;

  // wb control
  reg [1:0] mem_jump_reg;
  reg mem_memtoreg_reg;
  reg mem_regwrite_reg;
  
  reg [DATA_WIDTH-1:0] mem_alu_result_reg;
  reg [DATA_WIDTH-1:0] mem_writedata_reg;
  reg [2:0] mem_funct3_reg;
  reg [4:0] mem_rd_reg;


  // Assign
  assign mem_pc_plus_4 = mem_pc_plus_4_reg;
  assign mem_pc_target = mem_pc_target_reg;
  assign mem_taken = mem_taken_reg;

  // mem control
  assign mem_memread = mem_memread_reg;
  assign mem_memwrite = mem_memwrite_reg;

  // wb control
  assign mem_jump = mem_jump_reg;
  assign mem_memtoreg = mem_memtoreg_reg;
  assign mem_regwrite = mem_regwrite_reg;

  assign mem_alu_result = mem_alu_result_reg;
  assign mem_writedata = mem_writedata_reg;
  assign mem_funct3 = mem_funct3_reg;
  assign mem_rd = mem_rd_reg;

  always @(posedge clk) begin
    mem_pc_plus_4_reg <= ex_pc_plus_4;
    mem_pc_target_reg <= ex_pc_target;
    mem_taken_reg <= ex_taken;

    // mem control
    mem_memread_reg <= ex_memread;
    mem_memwrite_reg <= ex_memwrite;

    // wb control
    mem_jump_reg <= ex_jump;
    mem_memtoreg_reg <= ex_memtoreg;
    mem_regwrite_reg <= ex_regwrite;

    mem_alu_result_reg <= ex_alu_result;
    mem_writedata_reg <= ex_writedata;
    mem_funct3_reg <= ex_funct3;
    mem_rd_reg <= ex_rd;
  end

endmodule
