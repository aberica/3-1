// perceptron.v

/* The perceptron predictor uses the simplest form of neural networks
 * (perceptron), instead of using two-bit counters.  Note that PC[1:0] is not
 * used when indexing into the table of perceptrons.
 *
 * D. Jimenez and C. Lin. "Dynamic Branch Prediction with Perceptrons" HPCA 2001.
 */

module perceptron #(
  parameter DATA_WIDTH = 32,
  parameter HIST_LEN = 25, // Since x0 is always 1, 26 weights will reside in the perceptron table 
  parameter NUM_ENTRIES = 32
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

// TODO: Implement the perceptron branch predictor
// NOTE: DO NOT CHANGE the local parameters
localparam INDEX_WIDTH     = $clog2(NUM_ENTRIES);
localparam THRESHOLD       = $rtoi($floor(1.93 * HIST_LEN + 14));
localparam WEIGHT_BITWIDTH = 1 + $clog2(THRESHOLD + 1);
localparam WEIGHT_MAX      = $signed({1'b0, {WEIGHT_BITWIDTH-1{1'b1}}});
localparam WEIGHT_MIN      = $signed({1'b1, {WEIGHT_BITWIDTH-1{1'b0}}});
localparam OUTPUT_BITWIDTH = 1 + $clog2((HIST_LEN + 1) * WEIGHT_MAX + 1);

reg [HIST_LEN-1:0] BHR;
reg signed [WEIGHT_BITWIDTH-1:0] P_TABLE [NUM_ENTRIES-1:0][HIST_LEN:0];
reg signed [OUTPUT_BITWIDTH:0] y;
reg signed [OUTPUT_BITWIDTH:0] resolved_y;
wire resolved_pred;
wire [4:0] access_index = pc[6:2];
wire [4:0] update_index = resolved_pc[6:2];

// Update BHR
always @(posedge clk) begin
  if (!rstn) begin
    BHR <= 0;
  end else if (update) begin
    BHR <= {BHR[HIST_LEN-2:0], actually_taken};
  end
end

// Reset and Update P_TABLE
integer i, j, k, m, n;
always @(posedge clk) begin
  if (!rstn) begin
    for (i = 0; i < NUM_ENTRIES; i++) 
      for (j = 0; j <= HIST_LEN; j++) 
        P_TABLE[i][j] <= 0;
        
  end else if (update) begin
    if (resolved_pred != actually_taken || (-THRESHOLD <= resolved_y && resolved_y <= THRESHOLD)) begin

      if (actually_taken) begin
        if (P_TABLE[update_index][0] < WEIGHT_MAX)
          P_TABLE[update_index][0] <= P_TABLE[update_index][0] + 1;
      end else begin
        if (P_TABLE[update_index][0] > WEIGHT_MIN)
          P_TABLE[update_index][0] <= P_TABLE[update_index][0] - 1;
      end

      for (k = 1; k <= HIST_LEN; k++) begin
        if (actually_taken == BHR[k-1]) begin
          if (P_TABLE[update_index][k] < WEIGHT_MAX)
            P_TABLE[update_index][k] <= P_TABLE[update_index][k] + 1;
        end else begin
          if (P_TABLE[update_index][k] > WEIGHT_MIN)
              P_TABLE[update_index][k] <= P_TABLE[update_index][k] - 1;
        end
      end

    end
  end
end

always @(*) begin
  resolved_y = P_TABLE[update_index][0];
  for (m = 1; m <= HIST_LEN; m++) begin
    resolved_y = BHR[m-1] ? resolved_y + P_TABLE[update_index][m] : resolved_y - P_TABLE[update_index][m];
  end
end
assign resolved_pred = resolved_y[OUTPUT_BITWIDTH] ? 0 : 1;

always @(*) begin
  y = P_TABLE[access_index][0];
  for (n = 1; n <= HIST_LEN; n++) begin
    y = BHR[n-1] ? y + P_TABLE[access_index][n] : y - P_TABLE[access_index][n];
  end
end

assign pred = y[OUTPUT_BITWIDTH] ? 0 : 1;

endmodule
