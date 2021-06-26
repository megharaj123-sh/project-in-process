`timescale 1ns/1ns

module MEM(clk,mem_read_ctrl,mem_write_ctrl,mem_address,mem_data_write,mem_data_read);

input mem_read_ctrl;
input mem_write_ctrl;
input clk;
wire clk_bar;
//integer i;

//declaring these two as wires as they are being fed by the pipeline register EX_MEM 
input [31:0] mem_address;
input [31:0] mem_data_write;

output reg [31:0]mem_data_read;

//clock bar
assign clk_bar=~clk;

//defining ram within this module itself
reg [31:0] mem_ram [0:39];              //Need to decide upon the number of words in the memory

always@(posedge clk_bar)
begin
    if(mem_read_ctrl && !mem_write_ctrl)
        mem_data_read=mem_ram[mem_address];
    if(!mem_read_ctrl && mem_write_ctrl)
        mem_ram[mem_address]=mem_data_write;
end

//always@*
//for(i=0;i<40;i=i+1)
//begin
//    $display("%d",mem_ram[i]);
//end

endmodule
