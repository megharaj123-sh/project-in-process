`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2021 20:09:29
// Design Name: 
// Module Name: alu_control_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_control_tb;

reg clk;
wire [3:0] ALU_SEL;
reg [9:0] func_field;
reg [1:0] ALUOp;

alu_control uut(.clk(clk),.func_field(func_field),.ALUOp(ALUOp),.ALU_SEL(ALU_SEL));

always #20 clk=~clk;

initial begin
    clk<=1;
    ALUOp<=2'b00;
    func_field<=10'b0000000000;
    
    #30
    func_field<=10'b0100000000;
    ALUOp<=2'b01;
 
    #40   
    ALUOp<=2'b10;
    func_field<=10'b0000000000;
    
    #50
    func_field<=10'b0100000000;
    
    #50 
    func_field<=10'b0000000111;   
    
    #50
    func_field<=10'b0000000110;
    
    $finish;
    end
endmodule