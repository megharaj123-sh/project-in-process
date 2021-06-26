`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2021 13:31:16
// Design Name: 
// Module Name: control_unit
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


module control_unit(Op,RegWrite,ALUOp,MemRead,MemWrite,MemtoReg,is_Branch,ALUSrc);


input [6:0]Op;  // instruction[6:0]     

output reg RegWrite;
output reg [1:0] ALUOp;
output reg MemRead;
output reg MemWrite;
output reg MemtoReg;
output reg is_Branch; //later used to compute PCSrc
output reg ALUSrc;

//always @(Op)
always@*
begin
    case(Op)
        7'b0110011: //R type
            begin
            RegWrite<=1;
            ALUOp<=2'b10;
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=0;
            is_Branch<=0;  
            ALUSrc<=0;
            end
        7'b0000011: //lw type
            begin
            RegWrite<=1;
            ALUOp<=2'b00;
            MemRead<=1;
            MemWrite<=0;
            MemtoReg<=1;
            is_Branch<=0;  
            ALUSrc<=1;
            end
         7'b0100011: //S type
            begin
            RegWrite<=0;
            ALUOp<=2'b00;
            MemRead<=0;
            MemWrite<=1;
            MemtoReg<=1'bx;
            is_Branch<=0;  
            ALUSrc<=1; 
            end
        7'b1100011: //SB type
            begin
            RegWrite<=0;
            ALUOp<=2'b01;
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=1'bx;
            is_Branch<=1;  
            ALUSrc<=0; 
            end 
        7'b0010011: //I-format (verify  the values of the signals )
            begin
            RegWrite<=1;
            ALUOp<=2'b11; //(verify bit value)
            MemRead<=0;
            MemWrite<=0;
            MemtoReg<=1;
            is_Branch<=0;  
            ALUSrc<=0; 
            end 
         default:
            begin
            RegWrite<=1'bx;
            ALUOp<=2'bxx;
            MemRead<=1'bx;
            MemWrite<=1'bx;
            MemtoReg<=1'bx;
            is_Branch<=1'bx;  
            ALUSrc<=1'bx; 
            end
               
     endcase

end

endmodule
