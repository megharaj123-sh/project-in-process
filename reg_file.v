`timescale 1ns / 1ns

module reg_file(clk,reg_out_1,reg_out_2,reg_addr1,reg_addr2,reg_write_addr,reg_wr,reg_din);
    input clk;
	input [4:0] reg_addr1,reg_addr2,reg_write_addr;
	input [31:0] reg_din;
	input reg_wr;
	output reg [31:0] reg_out_1,reg_out_2;
	reg [31:0] registers [31:0];
	reg [31:0] temp_din;
	wire clk_bar;
//    integer i; //comment while synthesising
    
assign clk_bar=~clk;
    
always @(reg_addr1,reg_addr2)
	begin
		reg_out_1 <= registers[reg_addr1];
		reg_out_2 <= registers[reg_addr2];
	end
	
always@(posedge clk_bar)
	begin
	   //if(reg_wr)registers[reg_write_addr]=reg_din;
	   if(reg_wr)temp_din=reg_din;
	end

//comment while synthesising 	
//always@(*)
//begin
//    for(i=0;i<32;i=i+1)
//    begin
//        $display("%d",registers[i]);
//    end
//    $display();
//end

//Need to remove this part from here and should find a different means of gettting these initial values in
initial begin
		{reg_out_1,reg_out_2} = {32'h00000001,32'h00000002};
		registers[5'b00000]<=32'h00000003;   //according to RISC-V ISA address 0 must be bound to zero value
		registers[5'b00011]<=32'hfffffffC;
        registers[5'b00100]<=32'h0000000A;
        registers[5'b11111]<=32'h0000000C;
        end

endmodule