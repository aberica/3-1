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
  output reg [DATA_WIDTH-1:0] id_PC,
  output reg [DATA_WIDTH-1:0] id_pc_plus_4,
  output reg [DATA_WIDTH-1:0] id_instruction
);

// TODO: Implement IF/ID pipeline register module
always @(posedge clk) begin
  if (flush == 1'b1) begin
    id_PC <= 32'h00000000;
    id_pc_plus_4 <= 32'h00000000;
    id_instruction <= 32'h00000000; //addi x0, x0, 0
  end
  else if (stall != 1'b1) begin
    id_PC <= if_PC;
    id_pc_plus_4 <= if_pc_plus_4;
    id_instruction <= if_instruction;
  end
end

endmodule
