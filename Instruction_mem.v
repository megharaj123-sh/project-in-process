`timescale 1ns/1ns

module Instruction_mem(clk,address,instr);

input clk;
input [10:0]address;
output reg[31:0]instr;
reg [31:0] instruction_memory [0:39]; //capable of storing 40 instructions, each 32 bits wide
//reg [10:0]prev_addr;

initial $readmemb("ISA1.txt",instruction_memory);//instructions already stored at 'instrn_mem.h', now load them into the instruction_memory

always@(posedge clk)
begin
     //prev_addr<=address;
     instr <= instruction_memory[address];// value .. Mapping from +4 to +1
end

endmodule
