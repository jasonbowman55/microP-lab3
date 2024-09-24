`timescale 1ns/1ns
`default_nettype none
`define N_TV 8
//
module testbench1 ();

	logic reset;
	logic [3:0] col;
	logic [3:0] r_sel;
	logic [6:0] seg;
	logic [1:0] osc;
	logic clk;

	always
 	  begin
 	    clk = 1'b0; #5;
 	    clk = 1'b1; #5;
 	  end


	SystemVerilog duttop(reset, clk, col, r_sel, seg, osc);


	initial begin
		reset = 1'b1; #5;
		reset = 1'b0; #5;
		reset = 1'b1; #5;
	end

	initial begin
		col = 4'b0001; #500;
		col = 4'b0010; #500;
		col = 4'b0100; #500;
		col = 4'b1000; #500;
	end

endmodule