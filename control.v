//control unit for write enable and ALU control

`include "define.v"
module control(
	input [3:0] inst, 

	output reg reg_dst,
	output reg write_en,
	output reg alu_src,
	output reg branch,
	output reg mem_write,
	output reg mem_read,
	output reg mem_to_reg,
	output reg [2:0] aluop
	);

	always@(*)
	begin
		reg_dst = 0;
		alu_src = 0;
		branch = 0;
		write_en = 0;
		mem_write = 0;
		mem_read = 0;
		mem_to_reg = 1;
		aluop = inst[2:0];
		case(inst)
			`LW:
				begin
					mem_read = 1;
					alu_src = 1;
					write_en = 1;
					mem_to_reg = 0;
					aluop = `ADD;
				end
			`SW:
				begin
					reg_dst = 1;
					mem_write = 1;
					alu_src = 1;
					aluop = `ADD;
				end
			`BEQ:
				begin
					reg_dst = 1;
					branch = 1;
					aluop = `SUB;
				end
			//default case for alu operation
			default:
				begin
					write_en=1;
					mem_to_reg=1;
				end
		endcase
	end


  
endmodule
