`timescale 1ns/1ns
//`include "reg_file.v"

module ID(clk,Ra,Rb,Rd,reg_write_data,reg_wr,reg_read_data1,reg_read_data2,instr,imm_ext);

input clk;
input [4:0]Ra;
input [4:0]Rb;
input [4:0]Rd;                      //right now this Rd is directly being sent to the register file but it should actually be the output of a mux
input [31:0]reg_write_data;         //even this
input reg_wr;
input [31:0] instr;//Design philosophy: all the input control signals to a stage are cosidered to be wired inputs
output [31:0]reg_read_data1;
output [31:0]reg_read_data2;
output [31:0] imm_ext;

reg_file reg_file(.clk(clk),.reg_out_1(reg_read_data1),.reg_out_2(reg_read_data2),.reg_addr1(Ra),.reg_addr2(Rb),.reg_write_addr(Rd),.reg_wr(reg_wr),.reg_din(reg_write_data));
sign_ext sign_ext(instr,imm_ext);

endmodule