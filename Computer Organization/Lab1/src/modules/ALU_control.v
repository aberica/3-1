// ALU_control.v

/* This unit generates a 4-bit ALU control input (alu_func)
 * based on the 2-bit ALUOp control, funct7, and funct3 field.
 *
 * ALUOp | ALU action | notes  
 * ------|------------|---------------------
 *   00  | add        | for loads and stores
 *   01  | subtract   | for branches
 *   10  | it varies  | for R-types
 *   11  | it varies  | immediate
 *
 * R-type instructions (opcode: 0110011)
 * Name | funct3 | funct7 | funct
 * -------------------------------
 * add  |  0x0   |  0x00  |  0000
 * sub  |  0x0   |  0x20  |  1000
 * xor  |  0x4   |  0x00  |  0100
 * or   |  0x6   |  0x00  |  0110
 * and  |  0x7   |  0x00  |  0111
 * sll  |  0x1   |  0x00  |  0001
 * srl  |  0x5   |  0x00  |  0101
 * sra  |  0x5   |  0x20  |  1101
 * slt  |  0x2   |  0x00  |  0010
 * sltu |  0x3   |  0x00  |  0011
 */

`include "defines.v"

module ALU_control(
  input wire [1:0] alu_op,
  input wire [6:0] funct7,
  input wire [2:0] funct3,

  output reg [3:0] alu_func
);

wire [3:0] funct;
assign funct = {funct7[5], funct3};

// combinational logic
always @(*) begin
  case (alu_op)
    2'b00: begin                // Load/Store
      ///////////////////////////////////////////////////////////////////////
      // TODO : select operation for loads/stores
      alu_func = `OP_ADD;
      ///////////////////////////////////////////////////////////////////////
    end
    2'b01: begin                // B-types
      ///////////////////////////////////////////////////////////////////////
      // TODO : select operation for branches
      alu_func = `OP_SUB;
      ///////////////////////////////////////////////////////////////////////
    end
    2'b10: begin                // R-types
      case (funct)
        4'b0_000: alu_func = `OP_ADD;
        4'b1_000: alu_func = `OP_SUB;
        4'b0_100: alu_func = `OP_XOR;
        4'b0_110: alu_func = `OP_OR;
        4'b0_111: alu_func = `OP_AND;
        4'b0_001: alu_func = `OP_SLL;
        4'b0_101: alu_func = `OP_SRL;
        4'b1_101: alu_func = `OP_SRA;
        4'b0_010: alu_func = `OP_SLT;
        4'b0_011: alu_func = `OP_SLTU;
        default:  alu_func = `OP_EEE;  // shoud not fall here 
      endcase
    end
    2'b11: begin                // I-types
      ///////////////////////////////////////////////////////////////////////
      // TODO : select operation for I-types with immediate
      case (funct)
        4'bX_000: alu_func = `OP_ADD;
        4'bX_100: alu_func = `OP_XOR;
        4'bX_110: alu_func = `OP_OR;
        4'bX_111: alu_func = `OP_AND;
        4'bX_001: alu_func = `OP_SLL;
        4'bX_101: alu_func = `OP_SRL;
        4'bX_101: alu_func = `OP_SRA;
        4'bX_010: alu_func = `OP_SLT;
        4'bX_011: alu_func = `OP_SLTU;
        default:  alu_func = `OP_EEE;  // shoud not fall here 
      endcase
      ///////////////////////////////////////////////////////////////////////
    end
    default: alu_func = `OP_EEE;       // should not fall here
  endcase
end

endmodule
