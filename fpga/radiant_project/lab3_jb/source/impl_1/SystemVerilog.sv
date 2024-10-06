// Jason Bowman
// 9-16-24
// jbowman@g.hmc.edu
// This lab combines the knowledge from the two previous labs and employs a 12 buton array of number to display oinb a dual seven semgment display

module top (
	input logic reset,
//	input logic clk, //used for simulation
	input logic [3:0] col,
	output logic [3:0] r_sel,
	output logic [6:0] seg,
	output logic [1:0] osc
	//output logic clk_debug,
	//output logic [3:0] state_debug
	//output logic clk

	);

logic [24:0]counter;
logic [3:0] col_sync;
logic [3:0] select;
logic  debounce;
logic [3:0] right;//
logic [3:0] left;logic clk;

//logic clk; TAKEN OUT FOR MODEL SIM/

// HSOSC instantiation //////////////////////////////////// TAKEN OUT FOR MODEL SIM
 LSOSC #()
         lf_osc (.CLKLFPU(1'b1), .CLKLFEN(1'b1), .CLKLF(clk));
///////////////////////////////////////////////////////

always_ff @(posedge clk) begin
    // counter[#] controlls toggle speed
	if (counter[4] == 0) begin
		select <= right;
		osc <= 10; // turn on left display
	end
    else if (counter[4] == 1) begin
        	select <= left; // turn on right display
		osc <= 01;
    end
end


// instantiated submodules
button_decoder_bounce MOD1 (reset, col_sync, clk, counter, right, left, r_sel);

seven_seg_decoder MOD2 (select, seg);

syncronizer MOD3 (reset, col, clk, col_sync, counter);

//debouncer MOD4 (reset, clk, col_sync, debounce);
///////////////////////////


endmodule

