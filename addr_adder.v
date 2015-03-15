`timescale 1ns / 1ps
`include "define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:52:06 03/15/2015 
// Design Name: 
// Module Name:    addr_adder 
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
module adder(
	input [`DSIZE-1:0] a,
	input [`DSIZE-1:0] b,
	output reg [`DSIZE-1:0] out
    );
	 always@*
	 begin
		out = a + b;
	 end


endmodule
