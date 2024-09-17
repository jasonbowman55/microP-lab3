// Jason Bowman
// 9-16-24
// jbowman@g.hmc.edu
// This lab combines the knowledge from the two previous labs and employs a 12 buton array of number to display oinb a dual seven semgment display

module top (
	input logic reset,
	input logic [2:0] col,
	input logic [24:0] counter,
	input logic button_press,
	input logic[6:0] newseg,
	input logic[6:0] prevseg,
	output logic [6:0] seg,
	output logic [1:0] osc,
	output logic [3:0] r_sel
	);


// instantiated submodules
button_decoder_bounce MOD1 (reset, col, counter, en, r_sel, button);

row_scanner_bounce MOD2 (reset, col, en, r_sel, counter, button.

seven_seg_decoder MOD3 (reset, button, counter, en, seg, osc);

syncronizer MOD4 (reset, col, int_osc, counter, osc, button_press, r_sel);
//////////////////////////


endmodule

