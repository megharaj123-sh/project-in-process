`timescale 1ns / 1ns

module ALU_32bit( 
//port declarations
                input [3:0]ALU_SEL,
                input [31:0]A,B,
                output reg [31:0]ALU_OUT,
                output  carry,
	             output  zero,negative,overflow,underflow

        );
		
		wire [32:0] tmp;
		assign tmp = {1'b0,A} + {1'b0,B};
                assign carry = tmp[32]; // Carryout flag
		assign zero = ~(|ALU_OUT); //zero flag
		assign negative = (ALU_OUT[31] == 1 && (ALU_SEL == 4'b0110));
		assign overflow = ({carry,ALU_OUT[31]} == 2'b01);
		assign underflow = ({carry,ALU_OUT[31]} == 2'b10);
		
	always@(*)
	begin
	
	case(ALU_SEL)

         0: ALU_OUT<= A & B;
         1: ALU_OUT<= A | B;
         2: ALU_OUT<= A + B;
         6: ALU_OUT<= A - B;
         7: ALU_OUT<= A < B ? 32'b1 : 32'b0; //sltu
         8: ALU_OUT<= (A[31] ^ B[31])? {31'b0,A[31]}:{31'b0,(A<B)}; //slt
         12: ALU_OUT<= -(A|B); //nor
         default: ALU_OUT<=32'bx;


		  /* 4'b0000: // AdditionOK
           ALU_OUT <= A + B ; 
		   
        4'b0001: // SubtractionOK
           ALU_OUT <= B - A ;
		   
        4'b0010: // setlessthan
           ALU_OUT <= (A<B)?32'd1:32'd0;
           
        4'b0011: // setlessthan unsigned
           ALU_OUT <= (A>B)?32'd1:32'd0;
           
        4'b0100: // Logical shift left
           ALU_OUT <= A<<1;
		   
        4'b0101: // Logical shift right
           ALU_OUT <= A>>1;
		   
        4'b0110: // shiftrightarithmetic(if the bits are signed,otherwise it is same as right shift)
           ALU_OUT <= A>>>1;
		    
        4'b0111: // logicl and 
           ALU_OUT <= A & B;
		   
        4'b1000: //  Logical or 
           ALU_OUT <= A | B;
		   
        4'b1001: //  Logical xor 
           ALU_OUT <= A ;
		   
		   
          default: ALU_OUT <= A + B; 
          */

        endcase
    end

endmodule	
