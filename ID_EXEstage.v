`include "define.v"

module ID_EXE_stage (
	
	input  clk,  rst, 
	
	input [`DSIZE-1:0] aluin1_in,
	input [`DSIZE-1:0] aluin2_in,
	input [`DSIZE-1:0] rdata2_in,
	input [`DSIZE-1:0] imm_in,
	input [`ASIZE-1:0] waddr_in,
	input write_en_in,
	input branch_in,
	input mem_write_in,
	input mem_read_in,
	input mem_to_reg_in,
	input [2:0] aluop_in,
	
	output reg [`DSIZE-1:0] aluin1_out,
	output reg [`DSIZE-1:0] aluin2_out,
	output reg [`DSIZE-1:0] rdata2_out,
	output reg [`DSIZE-1:0] imm_out,
	output reg [`ASIZE-1:0] waddr_out,
	output reg write_en_out,
	output reg branch_out,
	output reg mem_write_out,
	output reg mem_read_out,
	output reg mem_to_reg_out,
	output reg [2:0] aluop_out
);



//here we have not taken write enable (wen) as it is always 1 for R and I type instructions.
//ID_EXE register to save the values.



always @ (posedge clk) begin
	if(rst)
	begin
		aluin1_out 			<= 0;
		aluin2_out 			<= 0;
		rdata2_out			<= 0;
		imm_out 				<= 0;
		waddr_out 			<= 0;
		write_en_out		<= 0;
		branch_out			<= 0;
		mem_write_out		<= 0;
		mem_read_out		<= 0;
		mem_to_reg_out		<= 0;
		aluop_out			<= 0;
	end
   else
	begin
		aluin1_out 			<= aluin1_in;
		aluin2_out 			<= aluin2_in;
		rdata2_out			<= rdata2_in;
		imm_out 				<= imm_in;
		waddr_out 			<= waddr_in;
		write_en_out		<= write_en_in;
		branch_out			<= branch_in;
		mem_write_out		<= mem_write_in;
		mem_read_out		<= mem_read_in;
		mem_to_reg_out		<= mem_to_reg_in;
		aluop_out			<= aluop_in;
	end
 
end
endmodule


