`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2021 18:17:26
// Design Name: 
// Module Name: alu_control
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


module alu_control(func_field,ALUOp,ALU_SEL);

    input [9:0] func_field; // Instruction[31:25(func7),12-14(func3)]
    input [1:0] ALUOp; //comes from the Main control Unit
    output reg [3:0] ALU_SEL; //O/p of the ALU control goes to the ALU to perform the specified operation
    
	always @(*)
	   case(ALUOp)
	       2'b00: //lw,sw instn 
	            //Irrespective of the func field, it generates an add control signal[to calculate the address]
	            ALU_SEL<=4'b0010;
	       2'b01: //branch instn
                case(func_field[2:0])
                    3'b000: //beq
                        ALU_SEL<=4'b0110;
                    3'b001: //bne
                        ALU_SEL<=4'b0110;
                    3'b100: //blt
                        ALU_SEL<=4'b1000;
                    3'b101: //bge
                        ALU_SEL<=4'b1000;
                    3'b110: //bltu
                        ALU_SEL<=4'b0111;
                    3'b111: //bgeu
                        ALU_SEL<=4'b0111;
                    default:
                        ALU_SEL<=4'bz;
                 endcase
           2'b10: //R-type instruction
                    case(func_field)
                        10'b0000000000: //add 
                            ALU_SEL<=4'b0010;
                        10'b0100000000: //sub 
                            ALU_SEL<=4'b0110;
                        10'b0000000111: //AND
                            ALU_SEL<=4'b0000;
                        10'b0000000110: //OR
                            ALU_SEL<=4'b0001;
                        10'b0000000010: //slt
                            ALU_SEL<=4'b1000;
                        10'b0000000011: //sltu
                            ALU_SEL<=4'b0111;
                        default: ALU_SEL<=4'bz; 
                     endcase
            2'b11: //I -type instruction ( verify the bit value)
                    case(func_field)
                        10'bxxxxxxx000: //addimm
                           ALU_SEL<=4'b0000;
                        10'bxxxxxxx111: //ANDI
                           ALU_SEL<=4'b0111;
                        10'bxxxxxxx110: //ORI
                           ALU_SEL<=4'b1000;
                        10'bxxxxxxx010: //SLTI*
                           ALU_SEL<=4'b0010;
                        10'bxxxxxxx011: //SLTIU*
                           ALU_SEL<=4'b0011;
                        10'bxxxxxxx100: //XORI
                           ALU_SEL<=4'b1001;
                        10'b0000000001: //SLLI*
                           ALU_SEL<=4'b0100;
                        10'b0000000101: //SRLI*
                           ALU_SEL<=4'b0101;
                        10'b0100000101: //SRAI*
                           ALU_SEL<=4'b0110;
                        //10'b101010: //Set on less than
                           // ALU_SEL<=4'b0111; 
                        default:
                            ALU_SEL<=4'bz;
                     endcase   
             default: ALU_SEL<=4'bz;                                   
       endcase
endmodule
