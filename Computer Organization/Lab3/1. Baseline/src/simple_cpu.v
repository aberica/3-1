// simple_cpu.v
// a pipelined RISC-V microarchitecture (RV32I)

///////////////////////////////////////////////////////////////////////////////////////////
//// [*] In simple_cpu.v you should connect the correct wires to the correct ports
////     - All modules are given so there is no need to make new modules
////       (it does not mean you do not need to instantiate new modules)
////     - However, you may have to fix or add in / out ports for some modules
////     - In addition, you are still free to instantiate simple modules like multiplexers,
////       adders, etc.
///////////////////////////////////////////////////////////////////////////////////////////

module simple_cpu
#(parameter DATA_WIDTH = 32)(
  input clk,
  input rstn
);

///////////////////////////////////////////////////////////////////////////////
// TODO:  Declare all wires / registers that are needed
///////////////////////////////////////////////////////////////////////////////
// e.g., wire [DATA_WIDTH-1:0] if_pc_plus_4;
// 1) Pipeline registers (wires to / from pipeline register modules)
// 2) In / Out ports for other modules
// 3) Additional wires for multiplexers or other mdoules you instantiate
// IF stage
wire [DATA_WIDTH-1:0] if_pc_plus_4;
wire [DATA_WIDTH-1:0] if_instruction;

// ID stage
wire flush;
wire stall;

wire [DATA_WIDTH-1:0] id_PC;
wire [DATA_WIDTH-1:0] id_pc_plus_4;
wire [1:0] id_jump;
wire id_branch;
wire [1:0] id_alu_op;
wire id_alu_src;
wire id_memread;
wire id_memtoreg;
wire id_regwrite;
wire [DATA_WIDTH-1:0] id_sextimm;
wire [DATA_WIDTH-1:0] id_instruction;
wire [DATA_WIDTH-1:0] id_readdata1;
wire [DATA_WIDTH-1:0] id_readdata2;

// EX stage
output [DATA_WIDTH-1:0] ex_PC;
output [DATA_WIDTH-1:0] ex_pc_plus_4;
wire [1:0] ex_jump;
wire ex_branch;
wire [1:0] ex_aluop;
wire ex_alusrc;
wire ex_memread;
wire ex_memwrite;
wire ex_memtoreg;
wire ex_regwrite;
wire [DATA_WIDTH-1:0] ex_sextimm;
wire [6:0] ex_funct7;
wire [2:0] ex_funct3;
wire [DATA_WIDTH-1:0] ex_readdata1;
wire [DATA_WIDTH-1:0] ex_readdata2;
wire [4:0] ex_rs1;
wire [4:0] ex_rs2;
wire [4:0] ex_rd;

wire [DATA_WIDTH-1:0] ex_branch_target_adder_in_a;
wire [DATA_WIDTH-1:0] ex_branch_target_adder_result;
wire [DATA_WIDTH-1:0] ex_pc_target;

wire ex_check;
wire ex_taken;

wire [1:0] forwardA;
wire [1:0] forwardB;

wire [3:0] ex_alufunc;
wire [DATA_WIDTH-1:0] ex_readdata1_forward;
wire [DATA_WIDTH-1:0] ex_readdata2_forward;
wire [DATA_WIDTH-1:0] ex_alu_in_b;
wire [DATA_WIDTH-1:0] ex_alu_result;

reg [7:0] ex_line;


// MEM stage
wire [DATA_WIDTH-1:0] mem_pc_plus_4;
wire [DATA_WIDTH-1:0] mem_pc_target;
wire mem_taken;
wire [1:0] mem_jump;
wire mem_memread;
wire mem_memwrite;
wire mem_memtoreg;
wire mem_regwrite;
wire [DATA_WIDTH-1:0] mem_alu_result;
wire [DATA_WIDTH-1:0] mem_writedata;
wire [2:0] mem_funct3;
wire [4:0] mem_rd;

wire [DATA_WIDTH-1:0] mem_readdata;
wire mem_branch;

// WB stage
wire [DATA_WIDTH-1:0] wb_pc_plus_4;
wire [1:0] wb_jump;
wire wb_memtoreg;
wire wb_regwrite;
wire [DATA_WIDTH-1:0] wb_readdata;
wire [DATA_WIDTH-1:0] wb_alu_result;
wire [DATA_WIDTH-1:0] wb_writedata;
wire [4:0] wb_rd;

///////////////////////////////////////////////////////////////////////////////
// Instruction Fetch (IF)
///////////////////////////////////////////////////////////////////////////////

reg [DATA_WIDTH-1:0] PC;    // program counter (32 bits)

wire [DATA_WIDTH-1:0] NEXT_PC;

/* m_next_pc_adder */
adder m_pc_plus_4_adder(
  .in_a   (32'h00000004),
  .in_b   (PC),

  .result (if_pc_plus_4)
);

/* m_next_pc_mux :  Allocate NEXT_PC */
mux_4x1 m_next_pc_mux(
  .select({flush, stall}),
  .in1(if_pc_plus_4),
  .in2(PC),
  .in3(mem_pc_target),
  .in4(mem_pc_target),
  
  .out(NEXT_PC)
);

always @(posedge clk) begin
  if (rstn == 1'b0) begin
    PC <= 32'h00000000;
  end
  else PC <= NEXT_PC;
end

/* instruction: read current instruction from inst mem */
instruction_memory m_instruction_memory(
  .address    (PC),

  .instruction(if_instruction)
);

/* forward to IF/ID stage registers */
ifid_reg m_ifid_reg(
  // TODO: Add flush or stall signal if it is needed
  .clk            (clk),
  .flush          (flush),
  .stall          (stall),
  
  .if_PC          (PC),
  .if_pc_plus_4   (if_pc_plus_4),
  .if_instruction (if_instruction),

  .id_PC          (id_PC),
  .id_pc_plus_4   (id_pc_plus_4),
  .id_instruction (id_instruction)
);

//////////////////////////////////////////////////////////////////////////////////
// Instruction Decode (ID)
//////////////////////////////////////////////////////////////////////////////////

/* m_hazard: hazard detection unit */
hazard m_hazard(
  // TODO: implement hazard detection unit & do wiring
  .clk(clk),
  .mem_taken(mem_taken),
  .mem_jump(mem_jump[1]),
  .ex_memread(ex_memread),
  .id_rs1(id_instruction[19:15]),
  .id_rs2(id_instruction[24:20]),
  .ex_rd(ex_rd),

  .flush(flush),
  .stall(stall)
);

/* m_control: control unit */
control m_control(
  .opcode     (id_instruction[6:0]),

  .jump       (id_jump),
  .branch     (id_branch),
  .alu_op     (id_alu_op),
  .alu_src    (id_alu_src),
  .mem_read   (id_memread),
  .mem_to_reg (id_memtoreg),
  .mem_write  (id_memwrite),
  .reg_write  (id_regwrite)
);

/* m_imm_generator: immediate generator */
immediate_generator m_immediate_generator(
  .instruction(id_instruction),

  .sextimm    (id_sextimm)
);

/* m_register_file: register file */
register_file m_register_file(
  .clk        (clk),
  .readreg1   (id_instruction[19:15]),
  .readreg2   (id_instruction[24:20]),
  .writereg   (wb_rd),
  .wen        (wb_regwrite),
  .writedata  (wb_writedata),

  .readdata1  (id_readdata1),
  .readdata2  (id_readdata2)
);

/* forward to ID/EX stage registers */
idex_reg m_idex_reg(
  // TODO: Add flush or stall signal if it is needed
  .clk          (clk),
  .flush        (flush),
  .stall        (stall),

  .id_PC        (id_PC),
  .id_pc_plus_4 (id_pc_plus_4),
  .id_jump      (id_jump),
  .id_branch    (id_branch),
  .id_aluop     (id_alu_op),
  .id_alusrc    (id_alu_src),
  .id_memread   (id_memread),
  .id_memwrite  (id_memwrite),
  .id_memtoreg  (id_memtoreg),
  .id_regwrite  (id_regwrite),
  .id_sextimm   (id_sextimm),
  .id_funct7    (id_instruction[31:25]),
  .id_funct3    (id_instruction[14:12]),
  .id_readdata1 (id_readdata1),
  .id_readdata2 (id_readdata2),
  .id_rs1       (id_instruction[19:15]),
  .id_rs2       (id_instruction[24:20]),
  .id_rd        (id_instruction[11:7]),
  .opcode       (id_instruction[6:0]),

  .ex_PC        (ex_PC),
  .ex_pc_plus_4 (ex_pc_plus_4),
  .ex_jump      (ex_jump),
  .ex_branch    (ex_branch),
  .ex_aluop     (ex_aluop),
  .ex_alusrc    (ex_alusrc),
  .ex_memread   (ex_memread),
  .ex_memwrite  (ex_memwrite),
  .ex_memtoreg  (ex_memtoreg),
  .ex_regwrite  (ex_regwrite),
  .ex_sextimm   (ex_sextimm),
  .ex_funct7    (ex_funct7),
  .ex_funct3    (ex_funct3),
  .ex_readdata1 (ex_readdata1),
  .ex_readdata2 (ex_readdata2),
  .ex_rs1       (ex_rs1),
  .ex_rs2       (ex_rs2),
  .ex_rd        (ex_rd)
);

//////////////////////////////////////////////////////////////////////////////////
// Execute (EX) 
//////////////////////////////////////////////////////////////////////////////////

/* m_branch_target_adder: PC + imm for branch address */
mux_2x1 m_branch_target_adder_in_a(
  .select(ex_jump[0]),
  .in1(ex_PC),
  .in2(ex_readdata1),

  .out(ex_branch_target_adder_in_a)
);

adder m_branch_target_adder(
  .in_a   (ex_branch_target_adder_in_a),
  .in_b   (ex_sextimm),

  .result (ex_branch_target_adder_result)
);

mux_2x1 m_branch_target_adder_result(
  .select(ex_jump[1] || ex_taken),
  .in1(if_pc_plus_4),
  .in2(ex_branch_target_adder_result),

  .out(ex_pc_target)
);

/* m_branch_control : checks T/NT */
branch_control m_branch_control(
  .branch (ex_branch),
  .check  (ex_check),
  
  .taken  (ex_taken)
);

/* alu control : generates alu_func signal */
alu_control m_alu_control(
  .alu_op   (ex_aluop),
  .funct7   (ex_funct7),
  .funct3   (ex_funct3),

  .alu_func (ex_alufunc)
);

mux_3x1 m_ex_readdata1_forward(
  .select(forwardA),
  .in1(ex_readdata1),
  .in2(mem_alu_result),
  .in3(wb_writedata),

  .out(ex_readdata1_forward)
);

mux_3x1 m_ex_readdata2_forward(
  .select(forwardB),
  .in1(ex_readdata2),
  .in2(mem_alu_result),
  .in3(wb_writedata),

  .out(ex_readdata2_forward)
);

mux_2x1 m_ex_alu_in_b(
  .select(ex_alusrc),
  .in1(ex_readdata2_forward),
  .in2(ex_sextimm),

  .out(ex_alu_in_b)
);

/* m_alu */
alu m_alu(
  .alu_func (ex_alufunc),
  .in_a     (ex_readdata1_forward), 
  .in_b     (ex_alu_in_b), 

  .result   (ex_alu_result),
  .check    (ex_check)
);

forwarding m_forwarding(
  // TODO: implement forwarding unit & do wiring
  .PC(PC),

  .ex_rs1(ex_rs1),
  .ex_rs2(ex_rs2),

  .mem_rd(mem_rd),
  .mem_regwrite(mem_regwrite),

  .wb_rd(wb_rd),
  .wb_regwrite(wb_regwrite),

  .forwardA(forwardA),
  .forwardB(forwardB)
);


/* forward to EX/MEM stage registers */
exmem_reg m_exmem_reg(
  // TODO: Add flush or stall signal if it is needed
  .clk            (clk),
  .flush          (flush),

  .ex_pc_plus_4   (ex_pc_plus_4),
  .ex_pc_target   (ex_pc_target),
  .ex_taken       (ex_taken), 
  .ex_branch      (ex_branch),
  .ex_jump        (ex_jump),
  .ex_memread     (ex_memread),
  .ex_memwrite    (ex_memwrite),
  .ex_memtoreg    (ex_memtoreg),
  .ex_regwrite    (ex_regwrite),
  .ex_alu_result  (ex_alu_result),
  .ex_writedata   (ex_readdata2_forward),
  .ex_funct3      (ex_funct3),
  .ex_rd          (ex_rd),
  
  .mem_pc_plus_4  (mem_pc_plus_4),
  .mem_pc_target  (mem_pc_target),
  .mem_taken      (mem_taken), 
  .mem_branch     (mem_branch),
  .mem_jump       (mem_jump),
  .mem_memread    (mem_memread),
  .mem_memwrite   (mem_memwrite),
  .mem_memtoreg   (mem_memtoreg),
  .mem_regwrite   (mem_regwrite),
  .mem_alu_result (mem_alu_result),
  .mem_writedata  (mem_writedata),
  .mem_funct3     (mem_funct3),
  .mem_rd         (mem_rd)
);



//////////////////////////////////////////////////////////////////////////////////
// Memory (MEM) 
//////////////////////////////////////////////////////////////////////////////////

/* m_data_memory : main memory module */
data_memory m_data_memory(
  .clk         (clk),
  .address     (mem_alu_result),
  .write_data  (mem_writedata),
  .mem_read    (mem_memread),
  .mem_write   (mem_memwrite),
  .maskmode    (mem_funct3[1:0]),
  .sext        (mem_funct3[2]),

  .read_data   (mem_readdata)
);

/* forward to MEM/WB stage registers */
memwb_reg m_memwb_reg(
  // TODO: Add flush or stall signal if it is needed
  .clk            (clk),
  .mem_pc_plus_4  (mem_pc_plus_4),
  .mem_jump       (mem_jump),
  .mem_memtoreg   (mem_memtoreg),
  .mem_regwrite   (mem_regwrite),
  .mem_readdata   (mem_readdata),
  .mem_alu_result (mem_alu_result),
  .mem_rd         (mem_rd),

  .wb_pc_plus_4   (wb_pc_plus_4),
  .wb_jump        (wb_jump),
  .wb_memtoreg    (wb_memtoreg),
  .wb_regwrite    (wb_regwrite),
  .wb_readdata    (wb_readdata),
  .wb_alu_result  (wb_alu_result),
  .wb_rd          (wb_rd)
);

//////////////////////////////////////////////////////////////////////////////////
// Write Back (WB) 
//////////////////////////////////////////////////////////////////////////////////
mux_3x1 m_writedata(
  .select({wb_jump[1], wb_memtoreg}),
  .in1(wb_alu_result),
  .in2(wb_readdata),
  .in3(wb_pc_plus_4),

  .out(wb_writedata)
);

//////////////////////////////////////////////////////////////////////////////////
// Hardware Counters
//////////////////////////////////////////////////////////////////////////////////
wire [31:0] CORE_CYCLE;
hardware_counter m_core_cycle(
  .clk(clk),
  .rstn(rstn),
  .cond(1'b1),
  .counter(CORE_CYCLE)
);

wire [31:0] NUM_COND_BRANCHES;
hardware_counter m_num_cond_branches(
  .clk(clk),
  .rstn(rstn),
  .cond(mem_branch),
  .counter(NUM_COND_BRANCHES)
);

wire [31:0] NUM_UNCOND_BRANCHES;
hardware_counter m_num_uncond_branches(
  .clk(clk),
  .rstn(rstn),
  .cond(mem_jump[1]),
  .counter(NUM_UNCOND_BRANCHES)
);

wire [31:0] BP_INCORRECT;
hardware_counter m_bp_correct(
  .clk(clk),
  .rstn(rstn),
  .cond(flush),
  .counter(BP_INCORRECT)
);

endmodule
