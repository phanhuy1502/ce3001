`timescale 1ns / 1ps
`include "define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:06 03/15/2015 
// Design Name: 
// Module Name:    MEM_delay 
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
module MEM_delay(
    input clk,
    input rst,
    input [`DSIZE-1:0] aluout_in,
	 input [`ASIZE-1:0] waddr_in,
	 input write_en_in,
	 input mem_to_reg_in,
	 
    output reg [`DSIZE-1:0] aluout_out,
	 output reg [`ASIZE-1:0] waddr_out,
	 output reg write_en_out,
	 output reg mem_to_reg_out
    );
	 
	 always @ (posedge clk) begin
		if(rst)
			begin
				aluout_out		<= 0;
				waddr_out		<= 0;
				write_en_out	<= 0;
				mem_to_reg_out	<= 0;
			end
		else
			begin
				aluout_out		<= aluout_in;
				waddr_out		<= waddr_in;
				write_en_out	<= write_en_in;
				mem_to_reg_out	<= mem_to_reg_in;
			end	 
	end

endmodule