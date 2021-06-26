`timescale 1ns/1ns
//`include "processor.v"

module processor_tb;
reg clk;
reg rst;
wire [31:0]data_in,data_out,address_out;
wire mem_read_ctrl,mem_write_ctrl;
parameter BOOT_ADDRESS=32'b0;

processor #(.BOOT_ADDRESS(BOOT_ADDRESS)) processor(.clk(clk),.rst(rst),.data_in(data_in),.mem_read_ctrl(mem_Read_ctrl),.mem_write_ctrl(mem_write_ctrl),.address_out(address_out),.data_out(data_out));
MEM MEM(.clk(clk),.mem_read_ctrl(mem_read_ctrl),.mem_write_ctrl(mem_write_ctrl),.mem_address(address_out),.mem_data_write(data_out),.mem_data_read(data_in));

always #20 clk=~clk;  //Need to decide the time period 

initial begin
    rst=1;
    clk=0;
    #30 rst=0;
    #400
    $finish;
end


endmodule