`timescale 1ns/1ns
//`include "IF.v"
//`include "ID.v"
//`include "control_unit.v"
//`include "EX.v"
//`include "MEM.v"
//`include "WB.v"

//RAndom 

module processor #(parameter BOOT_ADDRESS=32'b0)
                  (clk,rst,data_in,mem_read_ctrl,mem_write_ctrl,address_out,data_out);

input clk,rst;
input [31:0]data_in;
output wire mem_read_ctrl,mem_write_ctrl;
output wire [31:0]address_out,data_out;

//pipeline registers for storing data
wire [31:0]IF_ID_wire[0:1];                    //index0=instruction ,index1=pc 
reg [31:0]IF_ID[0:1];

wire [31:0]ID_EX_wire[0:4];                    //index0=instruction ,index1=Read_out_1 ,index2=Read_out2 , index3=imm_ext , index4=pc
reg [31:0]ID_EX[0:4];

wire [31:0]EX_MEM_wire[0:2];                   //index0=UNUSED ,index1=ALUresult ,index2=UNUSED
reg [31:0]EX_MEM[0:2];                         //index0=instruction ,index1=ALUresult ,index2=MEM_data_in_for_ld

wire [31:0]MEM_WB_wire[0:2];                   //index0=UNUSED ,index1=UNUSED ,index2=MEM_read_data
reg [31:0]MEM_WB[0:2];                         //index0=instruction ,index1=ALUresult ,index2=MEM_read_data

//pipeline registers for storing control signals;
wire ID_EX_ctrl_wire[0:8];                          //index0=ALU_src, index1 and 2=ALUOp, index3=mem_write, index4=mem_Read, index5=mem_to_reg, index6=Reg_write, index7='  ' ,index8=Branch: Ordering Philosophy is based on the ascending order of their entry point into a stage
reg ID_EX_ctrl[0:8];
reg EX_MEM_ctrl[0:3];                               //index0=mem_write, index1=mem_Read, index2=mem_to_reg, index3=Reg_write
wire Branch_taken;
wire [31:0]target_pc;
reg MEM_WB_ctrl[0:1];                               //index0=mem_to_reg, index1=Reg_write

//temporary
wire [31:0]temp1;

//Every stage gets a new output only the at negedge of the clk.
IF #(.BOOT_ADDRESS(BOOT_ADDRESS))IF(.clk(clk),.rst(rst),.instr(IF_ID_wire[0]),.pc(IF_ID_wire[1]),.target_pc(target_pc),.Branch_taken(Branch_taken));    //outputs of a module cannot be driven by the 'reg' types
control_unit control(.Op(IF_ID[0][6:0]),.RegWrite(ID_EX_ctrl_wire[6]),.ALUOp({ID_EX_ctrl_wire[1],ID_EX_ctrl_wire[2]}),.MemRead(ID_EX_ctrl_wire[4]),.MemWrite(ID_EX_ctrl_wire[3]),.MemtoReg(ID_EX_ctrl_wire[5]),.is_Branch(ID_EX_ctrl_wire[8]),.ALUSrc(ID_EX_ctrl_wire[0]));
ID ID(.clk(clk),.Ra(IF_ID[0][19:15]),.Rb(IF_ID[0][24:20]),.Rd(MEM_WB[0][11:7]),.reg_write_data(temp1),.reg_wr(MEM_WB_ctrl[1]),.reg_read_data1(ID_EX_wire[1]),.reg_read_data2(ID_EX_wire[2]),.instr(IF_ID[0]),.imm_ext(ID_EX_wire[3]));
EX EX(.A(ID_EX[1]),.B(ID_EX[2]),.imm_ext(ID_EX[3]),.Instr(ID_EX[0]),.ALUSrc(ID_EX_ctrl[0]),.is_Branch(ID_EX_ctrl[8]),.ALUOp({ID_EX_ctrl[1],ID_EX_ctrl[2]}),.Result(EX_MEM_wire[1]),.Branch_taken(Branch_taken),.pc(ID_EX[4]),.target_pc(target_pc));
//MEM MEM(.mem_read_ctrl(EX_MEM_ctrl[1]),.mem_write_ctrl(EX_MEM_ctrl[0]),.mem_address(EX_MEM[1]),.mem_data_write(EX_MEM[2]),.mem_data_read(MEM_WB_wire[2]));
WB WB(.mem_to_reg(MEM_WB_ctrl[0]),.Mem_read_out(MEM_WB[2]),.ALUresult(MEM_WB[1]),.out(temp1));


assign mem_read_ctrl=EX_MEM_ctrl[1];
assign mem_write_ctrl=EX_MEM_ctrl[0];
assign address_out=EX_MEM[1];
assign data_out=EX_MEM[2];
assign MEM_WB_wire[2]=data_in;

//As soon as a particular stage produces result the output needs to be stored into a pipeline register.
//synchronous reset
always@(posedge clk) begin
            if(rst)
            begin
                {IF_ID[0],IF_ID[1]}<={32'bz,32'bz};
                {ID_EX[0],ID_EX[1],ID_EX[2],ID_EX[3]}<={32'bz,32'bz,32'bz,32'bz};
                {EX_MEM[0],EX_MEM[1],EX_MEM[2]}<={32'bz,32'bz,32'bz};
                {MEM_WB[0],MEM_WB[1],MEM_WB[2]}<={32'bz,32'bz,32'bz};
                {ID_EX_ctrl[0],ID_EX_ctrl[1],ID_EX_ctrl[2],ID_EX_ctrl[3],ID_EX_ctrl[4],ID_EX_ctrl[5],ID_EX_ctrl[6],ID_EX_ctrl[7],ID_EX_ctrl[8]}<={1'bz,1'bz,1'bz,1'bz,1'bz,1'bz,1'bz,1'bz};
                {EX_MEM_ctrl[0],EX_MEM_ctrl[1],EX_MEM_ctrl[2],EX_MEM_ctrl[3]}<={1'bz,1'bz,1'bz,1'bz};
                {MEM_WB_ctrl[0],MEM_WB_ctrl[1]}<={1'bz,1'bz};
            end
            else begin
            {IF_ID[0],IF_ID[1]}<={IF_ID_wire[0],IF_ID_wire[1]};
            {ID_EX[0],ID_EX[1],ID_EX[2],ID_EX[3],ID_EX[4]}<={IF_ID[0],ID_EX_wire[1],ID_EX_wire[2],ID_EX_wire[3],IF_ID[1]};
            {EX_MEM[0],EX_MEM[1],EX_MEM[2]}<={ID_EX[0],EX_MEM_wire[1],ID_EX[2]};
            {MEM_WB[0],MEM_WB[1],MEM_WB[2]}<={EX_MEM[0],EX_MEM[1],MEM_WB_wire[2]};
        
            {ID_EX_ctrl[0],ID_EX_ctrl[1],ID_EX_ctrl[2],ID_EX_ctrl[3],ID_EX_ctrl[4],ID_EX_ctrl[5],ID_EX_ctrl[6],ID_EX_ctrl[8]}<={ID_EX_ctrl_wire[0],ID_EX_ctrl_wire[1],ID_EX_ctrl_wire[2],ID_EX_ctrl_wire[3],ID_EX_ctrl_wire[4],ID_EX_ctrl_wire[5],ID_EX_ctrl_wire[6],ID_EX_ctrl_wire[8]};
            {EX_MEM_ctrl[0],EX_MEM_ctrl[1],EX_MEM_ctrl[2],EX_MEM_ctrl[3]}<={ID_EX_ctrl[3],ID_EX_ctrl[4],ID_EX_ctrl[5],ID_EX_ctrl[6]};
            {MEM_WB_ctrl[0],MEM_WB_ctrl[1]}<={EX_MEM_ctrl[2],EX_MEM_ctrl[3]};
            end
            
            if(Branch_taken) begin
                {IF_ID[0],IF_ID[1]}<={32'bz,32'bz};
                {ID_EX[0],ID_EX[1],ID_EX[2],ID_EX[3]}<={32'bz,32'bz,32'bz,32'bz};
                {ID_EX_ctrl[0],ID_EX_ctrl[1],ID_EX_ctrl[2],ID_EX_ctrl[3],ID_EX_ctrl[4],ID_EX_ctrl[5],ID_EX_ctrl[6],ID_EX_ctrl[7],ID_EX_ctrl[8]}<={1'bz,1'bz,1'bz,1'bz,1'bz,1'bz,1'bz,1'bz};
            end
end

endmodule

