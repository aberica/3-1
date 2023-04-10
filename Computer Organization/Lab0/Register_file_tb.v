/**
 * SNU ECE Computer Organization
 *
 * Register_file_tb.v : test bench for the Register_file module
 */

`timescale 1ns / 100ps
module Register_file_tb;


wire [15:0] DATA_A, DATA_B;

reg [2:0] ADDR_A, ADDR_B;
reg [15:0] DATA_IN;
reg WR, CLK, RSTn;


/////////////////////////////////////
// TODO : change the "PORTNAME" and "MODULENAME" to appropriate names
/////////////////////////////////////
Register_file register 
( 
  .CLK(CLK),
  .RSTn(RSTn),
  .WR(WR),
  .ADDR_A(ADDR_A),
  .ADDR_B(ADDR_B),
  .DATA_IN(DATA_IN),
  .DATA_A(DATA_A),
  .DATA_B(DATA_B)
);
/////////////////////////////////////

integer i;

initial forever
  #5 CLK = ~CLK;

initial
begin

  CLK=1;

  RSTn = 1;
  #2  RSTn = 0;
  WR=0;
  #20   RSTn = 1;
  $display($time, " ********************** ");
  $display($time, " ** Start Simulation ** ");
  $display($time, " ********************** ");

  $display($time, " *** Register File **** ");
  $display($time, " ********************** ");
  for (i=0;i<8;i=i+1) begin
    $display($time, " Reg[%d]: %h (%b)", i, register.reg_array[i], register.reg_array[i]);
  end

  ////////// WRITE /////////

  $display($time, " ********************************* ");
  $display($time, " ** Write Data to Register File ** ");
  $display($time, " ********************************* ");
  ADDR_A = 3'b000;     // Select R0
  ADDR_B = 3'b001;     // Select R1

  #20   DATA_IN = 16'h1234;

  #20   WR = 1;     // Write to R1
  #10   WR = 0;

  $display($time, " [WRITE] Reg[1]: %h", register.reg_array[1]);
  if (register.reg_array[1] == 16'h1234) begin
    $display($time, " [WRITE] Correctly Write!");
  end
  else begin
    $display($time, " [WRITE] Incorrectly Written to Reg[1]..");
    $display($time, " [WRITE] True result is Reg[1]: 0x1234");
  end

  #20   ADDR_B = 3'b111;   // Select R7

  #20   DATA_IN = 16'h5678;

  #20   WR = 1;     // Write to R7
  #10   WR = 0;


  $display($time);
  $display($time, " [WRITE] Reg[7]: %h", register.reg_array[7]);
  if (register.reg_array[7] == 16'h5678) begin
    $display($time, " [WRITE] Correctly Write!");
  end
  else begin
    $display($time, " [WRITE] Incorrectly Written to Reg[7]..");
    $display($time, " [WRITE] True result is Reg[7]: 0x5678");
  end


  ///////////////////////////



  /////////// READ //////////

  $display($time, " ********************************** ");
  $display($time, " ** Read Data from Register File ** ");
  $display($time, " ********************************** ");
  #20   ADDR_A = 3'b100;   // Read R4
  ADDR_B = 4'b0101;   // Read R5
  #1
  $display($time, " [READ] Reg[4]: %h", DATA_A);
  if (DATA_A == 16'h0000) begin
    $display($time, " [READ] Correctly Read!");
  end
  else begin
    $display($time, "[READ] Incorrectly Read from Reg[4]..");
    $display($time, "[READ] True result is Reg[4]: 0x0000");
  end
  $display($time);
  $display($time, " [READ] Reg[5]: %h", DATA_B);
  if (DATA_B == 16'h0000) begin
    $display($time, " [READ] Correctly Read!");
  end
  else begin
    $display($time, " [READ] Incorrectly Read from Reg[5]..");
    $display($time, " [READ] True result is Reg[5]: 0x0000");
  end
  

  #20   ADDR_A = 3'b111;   // Read R7
  #1
  $display($time);
  $display($time, " [READ] Reg[7]: %h", DATA_A);
  if (DATA_A == 16'h5678) begin
    $display($time, " [READ] Correctly Read!");
  end
  else begin
    $display($time, " [READ] Incorrectly Read from Reg[7]..");
    $display($time, "[READ] True result is Reg[7]: 0x5678");
  end

  #20   ADDR_B = 3'b001;   // Read R1
  #1
  $display($time);
  $display($time, " [READ] Reg[1]: %h", DATA_B);
  if (DATA_B == 16'h1234) begin
    $display($time, " [READ] Correctly Read!");
  end
  else begin
    $display($time, " [READ] Incorrectly Read from Reg[1]..");
    $display($time, " [READ] True result is Reg[1]: 0x1234");
  end

  ////////////////////////////
  $display($time, " *********************** ");
  $display($time, " ** Finish Simulation ** ");
  $display($time, " *********************** ");
  $display($time, " *** Register File ***** ");
  $display($time, " *********************** ");
  for (i=0;i<8;i=i+1) begin
    $display($time, " Reg[%d]: %h (%b)", i, register.reg_array[i], register.reg_array[i]);
  end


  #20   RSTn = 0;
  #20   RSTn = 1;

  #40
  $finish;
end

// dump the state of the desgin
// VCD (Value Change Dump) is a standard dump format defined in Verilog
initial begin
  $dumpfile("Register_file.vcd");
  $dumpvars(0, Register_file_tb);
end

endmodule
