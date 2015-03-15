`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:37:57 02/12/2015
// Design Name:   pipelined_regfile_3stage
// Module Name:   C:/Users/Phong/Documents/CE3001/lab3/test_bench_3_stage_pipeline.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pipelined_regfile_3stage
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_bench_3_stage_pipeline;

	// Inputs
	reg clk;
	reg rst;
	reg fileid;

	wire [15:0] aluout;

	// Instantiate the Unit Under Test (UUT)
	pipelined_regfile_3stage uut (
		.clk(clk), 
		.rst(rst), 
		.aluout(aluout)
	);
	always #15 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		fileid = 0;

		// Wait 100 ns for global reset to finish
		#100;
      #25 rst=1;
		#25 rst=0;
		// Add stimulus here

	end
      
endmodule

