module button_decoder_bounce (
	input logic reset,
	input logic [3:0] col_sync,
	input logic clk,
	input logic [24:0] counter,
	//input logic debounce,
	output logic [3:0] right,
	output logic [3:0] left,
	output logic [3:0] r_sel
	);

// defining state variables /////
	logic [4:0] state, nextstate;
	logic [3:0] button;
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

///////////////////////////////////

// next state = nextstate on every clk edge
	always_ff @(posedge clk)
		if (!reset) 
			state <= S0;
		else 	
			state <= nextstate;
///////////////////////////////////////////

// Cycling through states dead states between row scan//
	always_comb begin
		case(state)
			S0: 
				if (|col_sync) 
					nextstate = S4;
				else 
					nextstate = S12;
			S12: 
				nextstate = S13;
			S13: 
				nextstate = S1;
			S4: 
				nextstate = S8;
			S8: 
				if (|col_sync) 
					nextstate = S8;
				else 
					nextstate = S0;
			S1: 
				if (|col_sync) 
					nextstate = S5;
				else 
					nextstate = S14;
			S14: 
				nextstate = S15;
			S15: 
				nextstate = S2;
			S5: 
				nextstate = S9;
			S9: 
				if (|col_sync) 
					nextstate = S9;
				else 
					nextstate = S1;
			S2: 
				if (|col_sync) 
					nextstate = S6;
				else 
					nextstate = S16;
			S16: 
				nextstate = S17;  
			S17: 
				nextstate = S3;
			S6: 
				nextstate = S10;
			S10: 
				if (|col_sync) 
					nextstate = S10;
				else 
					nextstate = S2;
			S3: 
				if (|col_sync) 
					nextstate = S7;
				else 
					nextstate = S18;
			S18: 
				nextstate = S19; 
			S19: 
				nextstate = S0;
			S7: 
				nextstate = S11;
			S11: 
				if (|col_sync) 
					nextstate = S11;
				else 
					nextstate = S3;
			default: 
				nextstate = S0;   
		endcase
	end
/////////////////////////////////////////////////////////

//enable to switch seg when at certain states
	//always_comb begin
		//case(state)
			//S4, S5, S6, S7: en = 1'b1;
			//default en = 1'b0;
		//endcase
	//end
/////////////////////////////////////////////

// debouncer code////////////////////////////////////////////////////////////////
logic [6:0] debounce_counter;
//logic [3:0] r_sel;

always_ff @(posedge clk) begin
    if (!reset) begin
        debounce_counter <= 7'h0;
        en <= 1'b0;
        r_sel <= 4'b0000; // Initialize r_sel on reset
    end else begin
        // State-based r_sel assignment

        // Debounce counter logic
        if (state == S8 || state == S9 || state == S10 || state == S11) begin
            debounce_counter <= debounce_counter + 1;
        end else begin
            debounce_counter <= 7'h0; // Reset counter if not in final states
        end
        
        // Enable seg assignments if debounce_counter has reached the threshold
        if (debounce_counter == 7'b0000001) begin // Debounce parameter
            en <= 1'b1;
        end else begin
            en <= 1'b0;
        end
    end
end

///////////////////////////////////////////////////////////////////////////////////
			
// if en is true, assign new segs
	always_ff @(posedge clk) begin
		if (en) begin
			left = right;
			right = button;
		end
	end
//////////////////////////////////

// logic to determine what button is pressed
	always_comb begin
		case(state)
			S8:
				case(col_sync)
					4'b0001: button = 4'h1;
					4'b0010: button = 4'h2;
					4'b0100: button = 4'h3;
					4'b1000: button = 4'hA;
					default: button = 4'h0;
				endcase
			S9:
				case(col_sync)
					4'b0001: button = 4'h4;
					4'b0010: button = 4'h5;
					4'b0100: button = 4'h6;
					4'b1000: button = 4'hB;
					default: button = 4'h0;
				endcase
			S10:
				case(col_sync)
					4'b0001: button = 4'h7;
					4'b0010: button = 4'h8;
					4'b0100: button = 4'h9;
					4'b1000: button = 4'hC;
					default: button = 4'h0;
				endcase
			S11:
				case(col_sync)
					4'b0001: button = 4'hF;
					4'b0010: button = 4'h0;
					4'b0100: button = 4'hE;
					4'b1000: button = 4'hD;
					default: button = 4'h0;
				endcase
			default: button = 4'h0;
		endcase
	end
///////////////////////////////////////////////

// row scan based on state /////////////////////////////////////////////
always_comb begin
    case(state)
        S0, S4, S8, S12, S13: r_sel = 4'b1110;
        S1, S5, S9, S14, S15: r_sel = 4'b1101;
        S2, S6, S10, S16, S17: r_sel = 4'b1011;
        S3, S7, S11, S18, S19: r_sel = 4'b0111;
        default: r_sel = 4'b0000;
    endcase
end
////////////////////////////////////////////////////////////////////////

endmodule