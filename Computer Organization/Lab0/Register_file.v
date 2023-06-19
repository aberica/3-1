/**
 * SNU ECE Computer Organization
 *
 * Register_file.v
 */

module Register_file (
  input CLK,
  input RSTn,
  input WR,
  input [2:0] ADDR_A,
  input [2:0] ADDR_B,
  input [15:0] DATA_IN,

  output [15:0] DATA_A,
  output [15:0] DATA_B
);

////////////////////////////////////////////
reg [15:0] reg_array [7:0];

//reset operation and write operation are sequential
always@(!RSTn or WR) begin
	//TODO : reset
	if(!RSTn) begin
		reg_array[0] <= 16'h0000;
		reg_array[1] <= 16'h0000;
		reg_array[2] <= 16'h0000;
		reg_array[3] <= 16'h0000;
		reg_array[4] <= 16'h0000;
		reg_array[5] <= 16'h0000;
		reg_array[6] <= 16'h0000;
		reg_array[7] <= 16'h0000;
	end

	//TODO : write
	if(WR) begin
		reg_array[ADDR_A] <= DATA_IN;
		reg_array[ADDR_B] <= DATA_IN;
	end
end

//read operation is combinational
//TODO : read
assign DATA_A = reg_array[ADDR_A];
assign DATA_B = reg_array[ADDR_B];

////////////////////////////////////////////
endmodule
