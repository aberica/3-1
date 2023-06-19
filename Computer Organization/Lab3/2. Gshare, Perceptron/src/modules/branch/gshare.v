// gshare.v

/* The Gshare predictor consists of the global branch history register (BHR)
 * and a pattern history table (PHT). Note that PC[1:0] is not used for
 * indexing.
 */

module gshare #(
  parameter DATA_WIDTH = 32,
  parameter COUNTER_WIDTH = 2,
  parameter NUM_ENTRIES = 256
) (
  input clk,
  input rstn,

  // update interface
  input update,
  input actually_taken,
  input [DATA_WIDTH-1:0] resolved_pc,

  // access interface
  input [DATA_WIDTH-1:0] pc,

  output pred
);

// TODO: Implement gshare branch predictor
reg [7:0] BHR;
reg [COUNTER_WIDTH-1:0] PHT [0:NUM_ENTRIES-1];
wire [7:0] access_index = BHR ^ pc[9:2];
wire [7:0] update_index = BHR ^ resolved_pc[9:2];

// Update BHR
always @(posedge clk) begin
  if (!rstn) begin
    BHR <= 0;
    
  end else if (update) begin
    BHR <= {BHR[6:0], actually_taken};
  end
end

// Update PHT
integer i;
always @(posedge clk) begin
  if (!rstn) begin
    for (i = 0; i < NUM_ENTRIES; i = i + 1) begin
      PHT[i] <= 2'b01;
    end
  end else if (update) begin
    if (actually_taken) begin
      if (PHT[update_index] < 2'b11) 
        PHT[update_index] <= PHT[update_index] + 1;

    end else begin
      if (PHT[update_index] > 2'b00) 
        PHT[update_index] <= PHT[update_index] - 1;
    end
    
  end
end

// Get pred
assign pred = PHT[access_index][COUNTER_WIDTH-1];

endmodule