`timescale 1ns/1ns
`default_nettype none
`define N_TV 8
//
module testbench1 ();

	logic reset;
	logic [3:0] col_sync;
	logic [3:0] r_sel;
	logic [6:0] seg;
	logic [1:0] osc;
	logic int_osc;

	always
 	  begin
 	    int_osc = 1'b0; #5;
 	    int_osc = 1'b1; #5;
 	  end


	top dut(reset, int_osc, col_sync, r_sel, seg, osc);//


	initial begin
		reset = 1'b1; #5;
		reset = 1'b0; #5;//
		reset = 1'b1; #5;
	end

	initial begin
		col_sync = 4'b1111; #102;
		col_sync = 4'b1111; #100;
		col_sync = 4'b1110; #500;
		col_sync = 4'b1111; #100;
		col_sync = 4'b1101; #500;
		col_sync = 4'b1111; #100;
		col_sync = 4'b1011; #500;
		col_sync = 4'b1111; #100;
		col_sync = 4'b0111; #500;
		col_sync = 4'b1110; #500;
		col_sync = 4'b1111; #100;
		col_sync = 4'b1101; #500;
		col_sync = 4'b1111; #100;
		col_sync = 4'b1011; #500;
		col_sync = 4'b1111; #100;
		col_sync = 4'b0111; #500;
	end

endmodule