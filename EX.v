`timescale 1ns/1ns
//`include "alu.v"
//`include "alu_control.v"

module EX(A,B,imm_ext,Instr,ALUSrc,is_Branch,ALUOp,Result,Branch_taken,pc,target_pc);
input ALUSrc,is_Branch;
input [31:0]A,B,Instr;
input [1:0]ALUOp;
input [31:0]imm_ext,pc;
output [31:0]Result;
output [31:0]target_pc;
output reg Branch_taken;
wire [3:0]ALU_ctrl;
wire [31:0]operand2;
wire zero;

alu_control alu_control(.func_field({Instr[31:25],Instr[14:12]}),.ALUOp(ALUOp),.ALU_SEL(ALU_ctrl)); //Only the func field bits can be transferred from the processor module
ALU_32bit alu(.ALU_SEL(ALU_ctrl),.A(A),.B(operand2),.ALU_OUT(Result),.carry(),.zero(zero),.negative(),.overflow(),.underflow());

//Adder for branch target address calculation
assign target_pc= pc + (imm_ext<<1);//imm is twice the number of instructions we want to jump

//Is branch taken?
    always @(*)
    begin
        case (Instr[14:12])//funct3
            3'b000: Branch_taken = is_Branch & zero;//eq
            3'b001: Branch_taken = is_Branch & ~zero;//ne
            3'b100: Branch_taken = is_Branch & Result[0];//lt
            3'b101: Branch_taken = is_Branch & ~Result[0];//ge
            3'b110: Branch_taken = is_Branch & Result[0];//ltu
            3'b111: Branch_taken = is_Branch & ~Result[0];//geu
            default: Branch_taken = 1'b0;
        endcase
    end

//mux to choose between register read value and immediate
assign operand2=ALUSrc?imm_ext:B;

endmodule