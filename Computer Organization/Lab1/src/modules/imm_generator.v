// imm_generator.v

module imm_generator #(
  parameter DATA_WIDTH = 32
)(
  input [31:0] instruction,

  output reg [DATA_WIDTH-1:0] sextimm
);

wire [6:0] opcode;
assign opcode = instruction[6:0];

always @(*) begin
  case (opcode)
    //////////////////////////////////////////////////////////////////////////
    // TODO : Generate sextimm using instruction
    7'b0010011: // I-type
    case(instruction[14:12])
      3'h3: sextimm = instruction[31:20]; // sltiu
      default: sextimm = $signed(instruction[31:20]); 
    endcase
    7'b0000011: sextimm = $signed(instruction[31:20]); //Load
    7'b0100011: sextimm = $signed({instruction[31:25], instruction[11:7]}); //Store
    7'b1100011: sextimm = $signed({instruction[31], instruction[7], instruction[30:24], instruction[11:8], 1'b0}); //Branch
    7'b1101111: sextimm = $signed({instruction[31], instruction[19:12], instruction[20], instruction[31:21], 1'b0}); //JAL
    7'b1100111: sextimm = $signed({instruction[31:20]}); //JALR
    //////////////////////////////////////////////////////////////////////////
    default:    sextimm = 32'h0000_0000;
  endcase
end


endmodule
