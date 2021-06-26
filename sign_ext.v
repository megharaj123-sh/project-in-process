`timescale 1ns/1ns

module sign_ext(instr,imm_ext);

input [31:0] instr;
output reg [31:0] imm_ext;
reg [11:0]imm;

//always@(instr[6:0]) begin
always@*
begin
    case(instr[6:0]) 
        7'b0100011: //sw
                imm={instr[31:25],instr[11:7]};
        7'b0000011: //lw
                imm=instr[31:20];
        7'b0010011://addimm
                imm=instr[31:20];
        7'b1100011: //branch
                imm={instr[31],instr[7],instr[30:25],instr[11:8]};
        default:
                imm=32'b0;   
    endcase
end

always@(imm) begin
    if(imm[11]==1)
        imm_ext={20'hfffff,imm};
    else
        imm_ext={20'b0,imm};
end

endmodule