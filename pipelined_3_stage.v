`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_3stage(clk, rst, aluout);

input clk;				
											
input	rst;
wire fileid; 
 
wire [`ISIZE-1:0]PCOUT;

wire [`DSIZE-1:0] INST;
output [`DSIZE-1:0] aluout;				
								
 	 
//Program counter
wire [`ISIZE-1:0]PCIN;

PC1 pc(.clk(clk),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));//PCOUT is your PC value and PCIN is your next PC

wire [`ISIZE-1:0]nextpc;
assign nextpc = PCOUT + 16'b1; //increments PC to PC +1


//instruction memory
memory im( .clk(clk),
			  .rst(rst),
			  .wen(1'b0),
			  .addr(PCOUT),
			  .data_in(16'b0),
			  .fileid(4'b0),
			  .data_out(INST));//note that memory read is having one clock cycle delay as memory is a slow operation

//here we are not taking the multiplexers for initialization as initialization is done within reg file itself.
wire [`ASIZE-1:0] opcode = INST[15:12];
wire [`ASIZE-1:0] rs = INST[7:4];
wire [`ASIZE-1:0] rt = INST[3:0];
wire [`ASIZE-1:0] imm = INST[3:0];
wire [`ASIZE-1:0] rd = INST[11:8];
//ID stage
wire reg_dst_ID;
wire branch_ID;
wire mem_write_ID;
wire mem_read_ID;
wire mem_to_reg_ID;
wire write_en_ID;
wire alu_src_ID;
wire [2:0] aluop;
wire [`ASIZE-1:0] waddr_ID;

control C0 (.inst(opcode),
				.reg_dst(reg_dst_ID),
				.write_en(write_en_ID),
				.alu_src(alusrc),
				.branch(branch_ID),
				.mem_write(mem_write_ID),
				.mem_to_reg(mem_to_reg_ID),
				.aluop(aluop));

wire write_en_WB;
wire [`ASIZE-1:0] waddr_WB;
wire [`ASIZE-1:0] readaddr1 = rs;
wire [`ASIZE-1:0] readaddr2 = (reg_dst_ID)? rd : rt;
//MUX selecting RegDst:
// if(RegDst = 0) => rt/imm
// else => rd
wire [`DSIZE-1:0] rdata1;
wire [`DSIZE-1:0] rdata2;
wire [`DSIZE-1:0] writeback_data;

regfile  RF0 (.clk(clk),
					.rst(rst),
					.wen(write_en_WB),
					.raddr1(readaddr1),
					.raddr2(readaddr2),
					.waddr(waddr_WB),
					.wdata(writeback_data),
					.rdata1(rdata1),
					.rdata2(rdata2)
					);//note that waddr needs to come from pipeline register 


//sign extension for immediate needs to be done for I type instuction.
//you can add that here
wire [`DSIZE-1:0] imm_extended;

assign imm_extended = {{13{imm[3]}},{imm[2:0]}};
wire [`DSIZE-1:0] aluin1_ID = rdata1;
wire [`DSIZE-1:0] aluin2_ID = (alusrc)?imm_extended:rdata2;

wire [`ISIZE-1:0] nextpc_EXE;
wire [`DSIZE-1:0] aluin1_EXE;
wire [`DSIZE-1:0] aluin2_EXE;
wire [`DSIZE-1:0] rdata2_EXE;
wire [`DSIZE-1:0] imm_EXE;
wire [`ASIZE-1:0] waddr_EXE;
wire [2:0] aluop_EXE;
wire branch_EXE;
wire mem_write_EXE;
wire mem_read_EXE;
wire mem_to_reg_EXE;
wire write_en_EXE;
wire [`DSIZE-1:0] aluout_EXE;

wire aluzero;
ID_EXE_stage id_exe_pipe(.clk(clk),
								 .rst(rst),
								 .nextpc_in(nextpc),
								 .aluin1_in(aluin1_ID),
								 .aluin2_in(aluin2_ID),
								 .rdata2_in(rdata2),
								 .waddr_in(rd),
								 .imm_in(imm_extended),
								 
								 .write_en_in(write_en_ID),
								 .branch_in(branch_ID),
								 .mem_write_in(mem_write_ID),
								 .mem_read_in(mem_read_ID),
								 .mem_to_reg_in(mem_to_reg_ID),
								 .aluop_in(aluop),
								 
								 .nextpc_out(nextpc_EXE),
								 .waddr_out(waddr_EXE),
								 .imm_out(imm_EXE),
								 .aluin1_out(aluin1_EXE),
								 .aluin2_out(aluin2_EXE),
								 .rdata2_out(rdata2_EXE),

								 .write_en_out(write_en_EXE),
								 .branch_out(branch_EXE),
								 .mem_write_out(mem_write_EXE),
								 .mem_read_out(mem_read_EXE),
								 .mem_to_reg_out(mem_to_reg_EXE),
								 .aluop_out(aluop_EXE)
								 );

//EXE STAGE
//address adder
wire [`ISIZE-1:0] newaddr = nextpc_EXE + imm_EXE;
//pcsrc signal
wire pc_src = branch_EXE & aluzero;
assign PCIN = (pc_src)? newaddr: nextpc;
//alu
alu ALU0 (  .a(aluin1_EXE),
				.b(aluin2_EXE),
				.op(aluop_EXE),
				.imm(imm_EXE),
				.zero(aluzero),
				.out(aluout_EXE));//ALU takes its input from pipeline register

wire [`DSIZE-1:0] aluout_MEM;
wire [`DSIZE-1:0] rdata2_MEM;
wire [`DSIZE-1:0] mem_data_MEM;
wire [`ASIZE-1:0] waddr_MEM;
wire write_en_MEM;
wire mem_write_MEM;
wire mem_read_MEM;
wire mem_to_reg_MEM;

//EXE_MEM pipeline
EXE_MEM_stage exe_mem_pipe(.clk(clk),
									.rst(rst),
									//bus data in
									.aluout_in(aluout_EXE),
									.rdata2_in(rdata2_EXE),
									.waddr_in(waddr_EXE),
									//control signal out
									.write_en_in(write_en_EXE),
									.mem_write_in(mem_write_EXE),
									.mem_read_in(mem_read_EXE),
									.mem_to_reg_in(mem_to_reg_EXE),
									//bus data out
									.aluout_out(aluout_MEM),
									.rdata2_out(rdata2_MEM),
									.waddr_out(waddr_MEM),
									//control signal out
									.write_en_out(write_en_MEM),
									.mem_write_out(mem_write_MEM),
									.mem_read_out(mem_read_MEM),
									.mem_to_reg_out(mem_to_reg_MEM)
									);

//Delay for reading in memory
wire [`DSIZE-1:0] aluout_delayed_MEM;
wire [`DSIZE-1:0] rdata2_delayed_MEM;
wire [`ASIZE-1:0] waddr_delayed_MEM;
wire write_en_delayed_MEM;
wire mem_write_delayed_MEM;
wire mem_read_delayed_MEM;
wire mem_to_reg_delayed_MEM;

//data memory
memory dm(.clk(clk),
			 .rst(rst),
			 .wen(mem_write_MEM),
			 .addr(aluout_MEM),
			 .data_in(rdata2_MEM),
			 .fileid(4'b0),
			 .data_out(mem_data_MEM)
			 );
MEM_delay delay(.clk(clk),
					 .rst(rst),
					 .aluout_in(aluout_MEM),
					 .waddr_in(waddr_MEM),
					 
					 .write_en_in(write_en_MEM),
					 .mem_to_reg_in(mem_to_reg_MEM),
					 
					 .aluout_out(aluout_delayed_MEM),
					 .waddr_out(waddr_delayed_MEM),
					 
					 .write_en_out(write_en_delayed_MEM),
					 .mem_to_reg_out(mem_to_reg_delayed_MEM)
					 );
//Writeback stage
wire mem_to_reg_WB;
wire [`DSIZE-1:0] mem_data_WB;
wire [`DSIZE-1:0] aluout_WB;

MEM_WB_stage mem_wb_pipe(
    .clk(clk),
    .rst(rst),
	 
    .mem_data_in(mem_data_MEM),
    .aluout_in(aluout_delayed_MEM),
	 .waddr_in(waddr_delayed_MEM),
	 
	 .write_en_in(write_en_delayed_MEM),
	 .mem_to_reg_in(mem_to_reg_delayed_MEM),
	 
    .mem_data_out(mem_data_WB),
    .aluout_out(aluout_WB),
	 .waddr_out(waddr_WB),
	 
	 .write_en_out(write_en_WB),
	 .mem_to_reg_out(mem_to_reg_WB)
    );

	//mux memtoreg
assign writeback_data = (mem_to_reg_WB) ? aluout_WB : mem_data_WB;

endmodule


