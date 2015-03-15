`include "define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:04:20 02/12/2015 
// Design Name: 
// Module Name:    PIPE2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module EXE_MEM_stage(
	input clk,
	input rst,
	
	input [`DSIZE-1:0] aluout_in,
	input [`DSIZE-1:0] rdata2_in,
	input [`ASIZE-1:0] waddr_in,
	input write_en_in,
	input mem_write_in,
	input mem_read_in,
	input mem_to_reg_in,
	
	output reg [`DSIZE-1:0] aluout_out,
	output reg [`DSIZE-1:0] rdata2_out,
	output reg [`ASIZE-1:0] waddr_out,
	output reg write_en_out,
	output reg mem_write_out,
	output reg mem_read_out,
	output reg mem_to_reg_out
   );
	 
	always @ (posedge clk) begin
		if(rst)
		begin
			aluout_out 		<= 0;
			rdata2_out 		<= 0;
			waddr_out		<= 0;
			write_en_out 	<= 0;
			mem_write_out 	<= 0;
			mem_read_out	<= 0;
			mem_to_reg_out <= 0;
		end
		else
		begin
			aluout_out	 	<= aluout_in;
			rdata2_out 		<= rdata2_in;
			waddr_out		<= waddr_in;
			write_en_out 	<= write_en_in;
			mem_write_out 	<= mem_write_in;
			mem_read_out	<= mem_read_in;
			mem_to_reg_out <= mem_to_reg_in;
		end
	 
	end

endmodule
