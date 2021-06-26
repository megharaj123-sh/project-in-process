`timescale 1ns/1ns
`include "MEM.v"

module MEM_tb;

reg clk;
reg mem_read_ctrl;
reg mem_write_ctrl;
reg [2:0] mem_address;
reg [2:0] mem_data_write;
wire [2:0] mem_data_read;

MEM uut(.clk(clk),.mem_read_ctrl(mem_read_ctrl),.mem_write_ctrl(mem_write_ctrl),.mem_address(mem_address),.mem_data_read(mem_data_read),.mem_data_write(mem_data_write));

always #20 clk=~clk;

initial begin
    clk<=1;
    $dumpfile("MEM_tb.vcd");
    $dumpvars(0,MEM_tb);  
    mem_read_ctrl<=0;
    mem_write_ctrl<=1;
    mem_address<=3'b000;
    mem_data_write<=3'b010;
    #20 
    mem_read_ctrl<=0;
    mem_write_ctrl<=1;
    mem_address<=3'b001;
    mem_data_write<=3'b101;
    #60
    mem_read_ctrl<=1;
    mem_write_ctrl<=0;
    mem_address<=3'b000;
    mem_data_write<=3'b010;
    #100
    mem_read_ctrl<=1;
    mem_write_ctrl<=0;
    mem_address<=3'b001;
    mem_data_write<=3'b010;
end

endmodule
