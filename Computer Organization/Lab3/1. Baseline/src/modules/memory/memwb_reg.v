// memwb_reg.v
// This module is the MEM/WB pipeline register.


module memwb_reg #(
  parameter DATA_WIDTH = 32
)(
  // TODO: Add flush or stall signal if it is needed

  //////////////////////////////////////
  // Inputs
  //////////////////////////////////////
  input clk,
  input flush,

  input [DATA_WIDTH-1:0] mem_pc_plus_4,

  // wb control
  input [1:0] mem_jump,
  input mem_memtoreg,
  input mem_regwrite,
  
  input [DATA_WIDTH-1:0] mem_readdata,
  input [DATA_WIDTH-1:0] mem_alu_result,
  input [4:0] mem_rd,
  
  //////////////////////////////////////
  // Outputs
  //////////////////////////////////////
  output reg [DATA_WIDTH-1:0] wb_pc_plus_4,

  // wb control
  output reg [1:0] wb_jump,
  output reg wb_memtoreg,
  output reg wb_regwrite,
  
  output reg [DATA_WIDTH-1:0] wb_readdata,
  output reg [DATA_WIDTH-1:0] wb_alu_result,
  output reg [4:0] wb_rd
);

// TODO: Implement MEM/WB pipeline register module

always @(posedge clk) begin
  if (flush == 1'b1) begin
    wb_pc_plus_4 <= 32'h00000000;

    // wb control
    wb_jump <= 2'b00;
    wb_memtoreg <= 1'b0;
    wb_regwrite <= 1'b0;

    wb_readdata <= 32'h00000000;
    wb_alu_result <= 32'h00000000;
    wb_rd <= 5'b00000;
  end
  else begin
    wb_pc_plus_4 <= mem_pc_plus_4;

    // wb control
    wb_jump <= mem_jump;
    wb_memtoreg <= mem_memtoreg;
    wb_regwrite <= mem_regwrite;

    wb_readdata <= mem_readdata;
    wb_alu_result <= mem_alu_result;
    wb_rd <= mem_rd;
  end
end

endmodule
