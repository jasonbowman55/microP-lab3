// Jason Bowman
// 9-16-24
// jbowman@g.hmc.edu
// This lab combines the knowledge from the two previous labs and employs a 12 buton array of number to display oinb a dual seven semgment display

module top (
	input logic reset,
	input logic clk,
	input logic [3:0] col,
	output logic [3:0] r_sel,
	output logic [6:0] seg,
	output logic [1:0] osc
	);

logic [24:0] counter;
logic [3:0] col_sync;
logic [3:0] select;
logic [4:0] debounce;
logic [3:0] right;
logic [3:0] left;
logic en;
//logic clk; TAKEN OUT FOR MODEL SIM


always_ff @(posedge clk) begin
    // counter[#] controlls toggle speed
	if (counter[12] == 0) begin
		select <= right; // Select left DIP-switch input
		osc[0] <= 1; // turn on left display
		osc[1] <= 0;
	end
    else begin
        select <= left; // Select right DIP-switch input
		osc[0] <= 0;
		osc[1] <= 1; // turn on right display
    end
end


// instantiated submodules
button_decoder_bounce MOD1 (reset, col_sync, clk, counter, debounce, right, left, r_sel);

seven_seg_decoder MOD2 (select, seg);

syncronizer MOD3 (reset, col, clk, col_sync, counter);

debouncer MOD4 (clk, col_sync, debounce);
///////////////////////////


endmodule

