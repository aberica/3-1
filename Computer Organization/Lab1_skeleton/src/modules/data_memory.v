// data_memory.v

module data_memory #(
  parameter DATA_WIDTH = 32, MEM_ADDR_SIZE = 8
)(
  input  clk,
  input  mem_write,
  input  mem_read,
  input  [1:0] maskmode,
  input  sext,
  input  [DATA_WIDTH-1:0] address,
  input  [DATA_WIDTH-1:0] write_data,

  output reg [DATA_WIDTH-1:0] read_data
);

  // memory
  reg [DATA_WIDTH-1:0] mem_array [0:2**MEM_ADDR_SIZE-1]; // change memory size
  initial $readmemh("data/data_memory.mem", mem_array);
  // wire reg for writedata
  wire [MEM_ADDR_SIZE-1:0] address_internal; // 256 = 8-bit address

  assign address_internal = address[MEM_ADDR_SIZE+1:2]; // 256 = 8-bit address

  // update at negative edge
  always @(negedge clk) begin 
    if (mem_write == 1'b1) begin
      ////////////////////////////////////////////////////////////////////////
      // TODO : Perform writes (select certain bits from write_data)
      // according to maskmode
      case (maskmode) 
        2'd0: mem_array[address][DATA_WIDTH-1:0] = write_data[7:0]; // byte
        2'd1: begin                                                 // half-word
          mem_array[address+1][DATA_WIDTH-1:0] = write_data[15:8];
          mem_array[address][DATA_WIDTH-1:0] = write_data[7:0];
        end
        2'd2: begin                                                 // word
          mem_array[address+3][DATA_WIDTH-1:0] = write_data[31:24];
          mem_array[address+2][DATA_WIDTH-1:0] = write_data[23:16];
          mem_array[address+1][DATA_WIDTH-1:0] = write_data[15:8];
          mem_array[address][DATA_WIDTH-1:0] = write_data[7:0];
        end
      endcase
      ////////////////////////////////////////////////////////////////////////
    end
  end

  // combinational logic
  always @(*) begin
    if (mem_read == 1'b1) begin
      ////////////////////////////////////////////////////////////////////////
      // TODO : Perform reads (select bits according to sext & maskmode)
      case ({sext, maskmode})
        3'b0_00: read_data = $signed(mem_array[address]);
        3'b0_01: read_data = $signed({mem_array[address+1], mem_array[address]});
        3'b0_10: read_data = $signed({mem_array[address+3], mem_array[address+2], mem_array[address+1], mem_array[address]});

        3'b1_00: read_data = mem_array[address];
        3'b1_01: read_data = {mem_array[address+1], mem_array[address]};
        3'b1_10: read_data = {mem_array[address+3], mem_array[address+2], mem_array[address+1], mem_array[address]};
      endcase
      ////////////////////////////////////////////////////////////////////////
    end else begin
      read_data = 32'h0000_0000;
    end
  end

endmodule
