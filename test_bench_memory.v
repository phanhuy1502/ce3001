`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:12:43 03/15/2015
// Design Name:   memory
// Module Name:   C:/Users/Phong/Developments/CE3001/final_project/test_bench_memory.v
// Project Name:  project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: memory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_bench_memory;

	// Inputs
	reg clk;
	reg rst;
	reg wen;
	reg [15:0] addr;
	reg [15:0] data_in;
	reg [3:0] fileid;

	// Outputs
	wire [15:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	memory uut (
		.clk(clk), 
		.rst(rst), 
		.wen(wen), 
		.addr(addr), 
		.data_in(data_in), 
		.fileid(fileid), 
		.data_out(data_out)
	);
	
	always #15 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		wen = 0;
		addr = 0;
		data_in = 0;
		fileid = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		// Add stimulus here
		
		#25 rst=1;
		#25 rst=0;
		#5;
		#30 addr=16'h1;
		#30 addr=16'h2;
		#30 addr=16'h3;
	end
      
endmodule

