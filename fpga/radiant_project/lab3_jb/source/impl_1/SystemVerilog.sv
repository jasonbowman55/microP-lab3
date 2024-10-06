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
<<<<<<< HEAD
	output logic [1:0] osc,
	//output logic clk_debug,
	//output logic [3:0] state_debug
	output logic clk
=======
	output logic [1:0] osc
	//output logic clk_debug,
	//output logic [3:0] state_debug
	//output logic debug_clk//
>>>>>>> a2ca23015e4dd29db3c50d4224e5e04c9fc90304

	);

logic [24:0]counter;
logic [3:0] col_sync;
logic [3:0] select;
logic  debounce;
logic [3:0] right;
logic [3:0] left;logic clk;
<<<<<<< HEAD
=======
//logic [24:0] clk_slow;

//assign clk_debug = clk;
//logic int_osc;

//assign debug_clk = clk;
>>>>>>> a2ca23015e4dd29db3c50d4224e5e04c9fc90304

//logic clk; TAKEN OUT FOR MODEL SIM/

// HSOSC instantiation //////////////////////////////////// TAKEN OUT FOR MODEL SIM
<<<<<<< HEAD
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
=======
LSOSC #() 
	lf_osc (.CLKLFPU(1'b1), .CLKLFEN(1'b1), .CLKLF(clk));
///////////////////////////////////////////////////////

	//always_ff @(posedge int_osc) begin
		//if (!reset) begin
			//clk_slow = 25'h0;
		//end else begin
			//clk_slow = clk_slow + 1;
		//end
	//end
	
	//assign clk = clk_slow[9];



always_ff @(posedge clk) begin
    // counter[#] controlls toggle speed
	if (counter[4] == 0) begin
		select <= right; // Select left DIP-switch input
		osc[0] <= 1; // turn on left display
		osc[1] <= 0;
	end
    else if (counter[4] == 1) begin //CHANGE
        	select <= left; // Select right DIP-switch input
		osc[0] <= 0;
		osc[1] <= 1; // turn on right display
>>>>>>> a2ca23015e4dd29db3c50d4224e5e04c9fc90304
    end
end


// instantiated submodules
button_decoder_bounce MOD1 (reset, col_sync, clk, counter, right, left, r_sel);

seven_seg_decoder MOD2 (select, seg);

syncronizer MOD3 (reset, col, clk, col_sync, counter);

<<<<<<< HEAD
//debouncer MOD4 (reset, clk, col_sync, debounce);
=======
debouncer MOD4 (reset, clk, col_sync, debounce);
>>>>>>> a2ca23015e4dd29db3c50d4224e5e04c9fc90304
///////////////////////////


endmodule

