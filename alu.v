`include "define.v"// defines


module alu(
   a,   //1st operand
   b,   //2nd operand
   op,   //3-bit operation
   imm,   //4-bit immediate operand for shift/rotate
	zero, //zero signal to control branch
   out   //output
   );


   
   input [`DSIZE-1:0] a, b;
   input [2:0] op;
   input [`DSIZE-1:0] imm;
	output zero;
   output [`DSIZE-1:0] out;
   
	reg zero;
	reg [`DSIZE-1:0] out; 
      
always @(a or b or op or imm)
begin
   case(op)
       `ADD: out = a+b;
       `SUB: out = a - b;
       `AND: out = a & b;
       `XOR:  out = a^b;
       `SLL: out = a << imm;
       `SRL: out = a >> imm;
       `COM: out = a<=b;
       `MUL: out = a*b;       

   endcase
	zero = out==0;
end

endmodule
   
       
