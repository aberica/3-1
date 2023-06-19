// branch_target_buffer.v

/* The branch target buffer (BTB) stores the branch target address for
 * a branch PC. Our BTB is essentially a direct-mapped cache.
 */

module branch_target_buffer #(
  parameter DATA_WIDTH = 32,
  parameter NUM_ENTRIES = 256
) (
  input clk,
  input rstn,

  // update interface
  input update,                              // when 'update' is true, we update the BTB entry
  input [DATA_WIDTH-1:0] resolved_pc,
  input [DATA_WIDTH-1:0] resolved_pc_target,

  // access interface
  input [DATA_WIDTH-1:0] pc,

  output hit,
  output [DATA_WIDTH-1:0] target_address
);

// TODO: Implement BTB
reg valid                [0:NUM_ENTRIES-1];
reg [21:0] TAG           [0:NUM_ENTRIES-1];
reg [DATA_WIDTH-1:0] BTB [0:NUM_ENTRIES-1];
wire [7:0] access_index = pc[9:2];
wire [7:0] update_index = resolved_pc[9:2];

// For debug
reg valid_updated;
reg [21:0] TAG_updated;
reg [DATA_WIDTH-1:0] BTB_updated;

// Reset and Update valid, TAG, BTB
integer i;
always @(posedge clk) begin
  if (!rstn) begin
    for (i = 0; i < NUM_ENTRIES; i = i + 1) begin
      valid[i] <= 0;
      TAG[i] <= 0;
      BTB[i] <= 0;

      valid_updated <= 0;
      TAG_updated <= 0;
      BTB_updated <= 0;
    end
  end else if (update) begin
    valid[update_index] <= 1;
    TAG[update_index] <= resolved_pc[31:10];
    BTB[update_index] <= resolved_pc_target;

    valid_updated <= 1;
    TAG_updated <= resolved_pc[31:10];
    BTB_updated <= resolved_pc_target;
  end
end

// Get hit, target_address
assign hit = valid[access_index] && (pc[31:10] == TAG[access_index]);
assign target_address = BTB[access_index];

endmodule
