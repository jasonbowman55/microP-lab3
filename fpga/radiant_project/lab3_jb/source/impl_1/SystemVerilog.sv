// Jason Bowman
// 10-6-24 (finished)
// jbowman@hmc.edu
// This code employs a 16-segment keypad and a dual 7 segment display to show both the most recent button press and previous button press. This code adjusts for button debouncing and uses next state logic in the fsm module to complete this task.

module top (
	input logic reset,
	input logic [3:0] col_sync,
	output logic [3:0] rows,
	output logic [6:0] seg,
	output logic [1:0] power 
);

// initialize inter-module logic
	logic [6:0] right;
	logic [6:0] left;
	logic [24:0] counter;
	logic [6:0] select;
 ///////////////////////////////

// Internal low-speed oscillator//////////////////////////////////
   LSOSC #() 
         lf_osc (.CLKLFPU(1'b1), .CLKLFEN(1'b1), .CLKLF(int_osc));
//////////////////////////////////////////////////////////////////

// Counter block //////////////////////
	always_ff @(posedge int_osc) begin
		if (!reset)
		counter <= 25'h0;
		else
			counter <= counter + 25'h1;
	end
///////////////////////////////////////	 

// time-multiplexer for 7-seg display///////
	always_ff @(posedge int_osc) begin
		// counter[#] controlls toggle speed
		if (!reset) begin
			select <= 7'b1111111;
			power <= 2'b00;
		end
		else if (counter[4] == 0) begin
			select <= right;
			power <= 2'b01; // turn on left display
		end
			else if (counter[4] == 1) begin
				select <= left; // turn on right display
			power <= 2'b10;
		end
	end
///////////////////////////////////////////

// sub-module instantiations////////////////////////////////////////////////
	button_decoder_bounce fsm (reset, col_sync, int_osc, right, left, rows);
	seven_seg_decoder segs (select, seg);
////////////////////////////////////////////////////////////////////////////	
endmodule

//*********************************
// the following module handles the fsm, button decoding, debouncing, output assignments, and row scanning
//*********************************

module button_decoder_bounce (
	input logic reset,
	input logic [3:0] col_sync,
	input logic clk,
	output logic [6:0] right,
	output logic [6:0] left,
	output logic [3:0] r_sel
	);

// defining state variables /////
	logic [4:0] state, nextstate;
	logic [6:0] button;
	logic en;

	parameter S0 = 5'b00000; // State 0
	parameter S1 = 5'b00001; // State 1
	parameter S2 = 5'b00010; // State 2
	parameter S3 = 5'b00011; // State 3
	parameter S4 = 5'b00100; // State 4
	parameter S5 = 5'b00101; // State 5
	parameter S6 = 5'b00110; // State 6
	parameter S7 = 5'b00111; // State 7
	parameter S8 = 5'b01000; // State 8
	parameter S9 = 5'b01001; // State 9
	parameter S10 = 5'b01010; // State 10
	parameter S11 = 5'b01011; // State 11
	parameter S12 = 5'b01100; // State 12 (dead)
	parameter S13 = 5'b01101; // State 13 (dead)
	parameter S14 = 5'b01110; // State 14 (dead)
	parameter S15 = 5'b01111; // State 15 (dead)
	parameter S16 = 5'b10000; // State 16 (dead)
	parameter S17 = 5'b10001; // State 17 (dead)
	parameter S18 = 5'b10010; // State 18 (dead)
	parameter S19 = 5'b10011; // State 19 (dead)
	parameter S20 = 5'b10100; // State 20 (dead)
	parameter S21 = 5'b10101; // State 21 (dead)
	parameter S22 = 5'b10110; // State 22 (dead)
	parameter S23 = 5'b10111; // State 23 (dead)
/////////////////////////////////

// next state = nextstate on every clk edge
	always_ff @(posedge clk)
		if (!reset) 
			state <= S0;
		else 	
			state <= nextstate;
///////////////////////////////////////////

// debounce and enable seg update logic
	logic [9:0] dbON;
	logic [12:0] dbOFF;
///////////////////////////////////////

// fsm ///////////////////////////////////////////////
	always_comb begin
		case(state)
			S0: 
				if (col_sync != 4'b1111) 
					nextstate = S4;
				else 
					nextstate = S12;
			S12: 
				nextstate = S13;
			S13: 
				nextstate = S1;
			S4:
				if (dbON == 10'b1111111111)
					nextstate = S20;
				else
					nextstate = S4;
			S20: nextstate = S8;
			S8: 
				if (col_sync != 4'b1111)
					nextstate = S8;
				else if (dbOFF == 13'b1111111111111)
					nextstate = S0;
			S1: 
				if (col_sync != 4'b1111)
					nextstate = S5;
				else 
					nextstate = S14;
			S14: 
				nextstate = S15;
			S15: 
				nextstate = S2;
			S5:
				if (dbON == 10'b1111111111)
					nextstate = S21;
				else
					nextstate = S5;
			S21: nextstate = S9;
			S9: 
				if (col_sync != 4'b1111)
					nextstate = S9;
				else if (dbOFF == 13'b1111111111111)
					nextstate = S1;
			S2: 
				if (col_sync != 4'b1111)
					nextstate = S6;
				else 
					nextstate = S16;
			S16: 
				nextstate = S17;  
			S17: 
				nextstate = S3;
			S6:
				if (dbON == 10'b1111111111)
					nextstate = S22;
				else
					nextstate = S6;
			S22: nextstate = S10;
			S10: 
				if (col_sync != 4'b1111)
					nextstate = S10;
				else if (dbOFF == 13'b1111111111111)
					nextstate = S2;
			S3: 
				if (col_sync != 4'b1111)
					nextstate = S7;
				else 
					nextstate = S18;
			S18: 
				nextstate = S19; 
			S19: 
				nextstate = S0;
			S7:
				if (dbON == 10'b1111111111)
					nextstate = S23;
				else
					nextstate = S7;
			S23: nextstate = S11;
			S11: 
				if (col_sync != 4'b1111)
					nextstate = S11;
				else if (dbOFF == 13'b1111111111111)
					nextstate = S3;
			default: 
				nextstate = S0;   
		endcase
	end
/////////////////////////////////////////////////////

// debouncer /////////////////////////////////////////////////////////////////////////////////////////////////////
always_ff @(posedge clk) begin
    if (!reset) begin
        dbON <= 10'h0;
        dbOFF <= 13'h0;
        en <= 1'b0;
    end else begin
        if (state == S4 || state == S5 || state == S6 || state == S7) begin
            dbON <= dbON + 1;
            dbOFF <= 13'h0;
        end else if ((state == S8 || state == S9 || state == S10 || state == S11) && (col_sync == 4'b1111)) begin
            dbOFF <= dbOFF + 1;
            dbON <= 10'h0;
        end else begin
            dbON <= 10'h0;
            dbOFF <= 13'h0;
        end
    end
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
// assign new assignmets if debounced
	always_ff @(posedge clk) begin
		if (dbON == 8'b11111111) begin
			left = right;
			right = button;
		end
	end
/////////////////////////////////////

// button decoder /////////////////////////////////
always_comb begin
    case(state)
        S4:
            case(col_sync)
                4'b1110: button = 4'b0001; // 4'h1
                4'b1101: button = 4'b0010; // 4'h2
                4'b1011: button = 4'b0011; // 4'h3
                4'b0111: button = 4'b1100; // 4'hC
            endcase
        S5:
            case(col_sync)
                4'b1110: button = 4'b0100; // 4'h4
                4'b1101: button = 4'b0101; // 4'h5
                4'b1011: button = 4'b0110; // 4'h6
                4'b0111: button = 4'b1101; // 4'hD
            endcase
        S6:
            case(col_sync)
                4'b1110: button = 4'b0111; // 4'h7
                4'b1101: button = 4'b1000; // 4'h8
                4'b1011: button = 4'b1001; // 4'h9
                4'b0111: button = 4'b1110; // 4'hE
            endcase
        S7:
            case(col_sync)
                4'b1110: button = 4'b1010; // 4'hA
                4'b1101: button = 4'b0000; // 4'h0
                4'b1011: button = 4'b1011; // 4'hB
                4'b0111: button = 4'b1111; // 4'hF
            endcase
        default: button = 4'b0000; // 4'h0
    endcase
end
///////////////////////////////////////////////////

// row scan based on state /////////////////////////////////////////////
always_comb begin
    case(state)
        S0, S4, S8, S12, S13, S20: r_sel = 4'b1110;
        S1, S5, S9, S14, S15, S21: r_sel = 4'b1101;
        S2, S6, S10, S16, S17, S22: r_sel = 4'b1011;
        S3, S7, S11, S18, S19, S23: r_sel = 4'b0111;
        default: r_sel = 4'b1111;
    endcase
end
////////////////////////////////////////////////////////////////////////
endmodule

//*********************************
// the following module handles output val -> 7seg input decoding
//*********************************

module seven_seg_decoder (
	input logic [6:0] select,
	output logic [6:0] seg
	);
// 7-seg decoder ////////////////////////////////////////
	always_comb begin
		case(select)
			4'b0000: seg = 7'b1000000;
			4'b0001: seg = 7'b1111001;
			4'b0010: seg = 7'b0100100;
			4'b0011: seg = 7'b0110000;
			4'b0100: seg = 7'b0011001;
			4'b0101: seg = 7'b0010010;
			4'b0110: seg = 7'b0000010;
			4'b0111: seg = 7'b1111000;
			4'b1000: seg = 7'b0000000;
			4'b1001: seg = 7'b0011000;
			4'b1010: seg = 7'b0001000;
			4'b1011: seg = 7'b0000011;
			4'b1100: seg = 7'b1000110;
			4'b1101: seg = 7'b0100001;
			4'b1110: seg = 7'b0000110;
			4'b1111: seg = 7'b0001110;
			default: seg = 7'b0111111;
		endcase
	end
/////////////////////////////////////////////////////////
endmodule