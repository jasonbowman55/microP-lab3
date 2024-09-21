// Jason Bowman
// 9-16-24
// jbowman@g.hmc.edu
// This lab combines the knowledge from the two previous labs and employs a 12 buton array of number to display oinb a dual seven semgment display

module top (
	input logic reset,
	input logic [3:0] col,
	output logic [3:0] r_sel,
	output logic [6:0] seg,
	output logic [1:0] osc
	);


// instantiated submodules
button_decoder_bounce MOD1 (reset, col, counter, int_osc, en, r_sel, button);

seven_seg_decoder MOD2 (reset, button, counter, int_osc, en, seg, osc);

syncronizer MOD3 (reset, int_osc, counter);
///////////////////////////


endmodule

