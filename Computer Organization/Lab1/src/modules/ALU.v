// ALU.v

// This module performs ALU operations according to the "alu_func" value,
// which is generated by the ALU control unit.
// Note that there exist 10 R-type instructions in RV32I:
// add, sub, xor, or, and, sll, srl, sra, slt, sltu

`include "defines.v"

module ALU 
#(parameter DATA_WIDTH = 32)(
  input [DATA_WIDTH-1:0] in_a, 
  input [DATA_WIDTH-1:0] in_b,
  input [3:0] alu_func,

  output reg [DATA_WIDTH-1:0] result,
  output reg check 
);

// combinational logic 
always @(*) begin
  case (alu_func)
    `OP_ADD:  result = in_a +  in_b; 
    `OP_SUB:  result = in_a -  in_b;
    `OP_XOR:  result = in_a ^  in_b;
    `OP_OR:   result = in_a |  in_b;
    `OP_AND:  result = in_a &  in_b;
    //////////////////////////////////////////////////////////////////////////
    // TODO : Add other operations
    // - The example below is given as a hint
    // - `OP_SRA: result = $signed(in_a) >>> in_b[4:0];    
    `OP_SLL: result = in_a << in_b[4:0];
    `OP_SRL: result = in_a >> in_b[4:0];
    `OP_SRA: result = $signed(in_a) >>> in_b[4:0];
    `OP_SLT: result = ($signed(rs1) < $signed(rs2)) ? 1:0;
    `OP_SLTU: result = (rs1 < rs2) ? 1:0;
    // 크기가 다를 때나 signed가 의미가 있지 여기서는 흠... 의미가 있는건가...
    // 어차피 [31-0]으로 들어오는데... 만약 차이가 없다면 SLT와 SLTU도 똑같은건데...
    //////////////////////////////////////////////////////////////////////////
    default:  result = 32'h0000_0000;
  endcase
end

// combinational logic
always @(*) begin
  case (alu_func)
    //////////////////////////////////////////////////////////////////////////
    // TODO : Generate check signal
    `OP_SUB: check = (result == 0); // beq
    `OP_XOR: check = (result != 0); // bne
    `OP_SLT: check = result;        // blt
    `OP_BGE: check = ($signed(rs1) >= $signed(rs2)) ? 1:0;  // bge
    `OP_SLTU: check = result;       // blut
    `OP_BGEU: check = (rs1 >= rs2) ? 1:0;  // bgeu
    //////////////////////////////////////////////////////////////////////////
    default:  check = 1'b0;
  endcase
end
endmodule
