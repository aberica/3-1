// ifid_reg.v
// This module is the IF/ID pipeline register.


module ifid_reg #(
  parameter DATA_WIDTH = 32
)(
  // TODO: Add flush or stall signal if it is needed

  //////////////////////////////////////
  // Inputs
  //////////////////////////////////////
  input clk,
  input flush,
  input stall,

  input [DATA_WIDTH-1:0] if_PC,
  input [DATA_WIDTH-1:0] if_pc_plus_4,
  input [DATA_WIDTH-1:0] if_instruction,

  //////////////////////////////////////
  // Outputs
  //////////////////////////////////////
  output [DATA_WIDTH-1:0] id_PC,
  output [DATA_WIDTH-1:0] id_pc_plus_4,
  output [DATA_WIDTH-1:0] id_instruction
);

// TODO: Implement IF/ID pipeline register module
  // Reg
  reg [DATA_WIDTH-1:0] id_PC_reg;
  reg [DATA_WIDTH-1:0] id_pc_plus_4_reg;
  reg [DATA_WIDTH-1:0] id_instruction_reg;


  // Assign
  assign id_PC = id_PC_reg;
  assign id_pc_plus_4 = id_pc_plus_4_reg;
  assign id_instruction = id_instruction_reg;
  // assign id_PC = if_PC;
  // assign id_pc_plus_4 = if_pc_plus_4;
  // assign id_instruction = if_instruction;


  always @(posedge clk) begin
    if (flush==1'b1) begin
      id_PC_reg <= 32'h00000000;
      id_pc_plus_4_reg <= 32'h00000000;
      id_instruction_reg <= 32'h00000013; //addi x0, x0, 0
    end
    else if(stall!=1'b1) begin
      id_PC_reg <= if_PC;
      id_pc_plus_4_reg <= if_pc_plus_4;
      id_instruction_reg <= if_instruction;
    end
  end

endmodule
