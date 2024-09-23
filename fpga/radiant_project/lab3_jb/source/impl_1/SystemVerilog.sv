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

logic [24:0] counter;
logic [3:0] col_sync;
logic [3:0] select;
logic int_osc;
logic en;

// instantiated submodules
button_decoder_bounce MOD1 (reset, col_sync, int_osc, counter, en, r_sel, select, osc);

seven_seg_decoder MOD2 (select, seg);

syncronizer MOD3 (reset, col, int_osc, col_sync, counter);
///////////////////////////


endmodule

