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
	logic [19:0] state, nextstate;
	logic [3:0] button;
	logic en;
	
	parameter S0 = 20'b00000000000000000001;
	parameter S1 = 20'b00000000000000000010;
	parameter S2 = 20'b00000000000000000100;
	parameter S3 = 20'b00000000000000001000;
	parameter S4 = 20'b00000000000000010000;
	parameter S5 = 20'b00000000000000100000;
	parameter S6 = 20'b00000000000001000000;
	parameter S7 = 20'b00000000000010000000;
	parameter S8 = 20'b00000000000100000000;
	parameter S9 = 20'b00000000001000000000;
	parameter S10 = 20'b00000000010000000000;
	parameter S11 = 20'b00000000100000000000;
	// below are all dead states
	parameter S12 = 20'b00000001000000000000;
	parameter S13 = 20'b00000010000000000000;
	parameter S14 = 20'b00000100000000000000;
	parameter S15 = 20'b00001000000000000000;
	parameter S16 = 20'b00010000000000000000;
	parameter S17 = 20'b00100000000000000000;
	parameter S18 = 20'b01000000000000000000;
	parameter S19 = 20'b10000000000000000000;
///////////////////////////////////

// next state = nextstate on every clk edge
	always_ff @(posedge clk)
		if (!reset) 
			state <= S0;
		else 	
			state <= nextstate;
///////////////////////////////////////////

// Cycling through states dead states between row scan
always_comb begin
    case(state)
        S0: 
            if (col_sync != 4'b0000) 
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
            if (col_sync != 4'b0000) 
                nextstate = S8;
            else 
                nextstate = S0;
        S1: 
            if (col_sync != 4'b0000) 
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
            if (col_sync != 4'b0000) 
                nextstate = S9;
            else 
                nextstate = S1;
        S2: 
            if (col_sync != 4'b0000) 
                nextstate = S6;
            else 
                nextstate = S16;
        S16: 
            nextstate = S17;  // Fixed typo from "nexstate"
        S17: 
            nextstate = S3;
        S6: 
            nextstate = S10;
        S10: 
            if (col_sync != 4'b0000) 
                nextstate = S10;
            else 
                nextstate = S2;
        S3: 
            if (col_sync != 4'b0000) 
                nextstate = S7;
            else 
                nextstate = S18;
        S18: 
            nextstate = S19;  // Fixed typo from ":" to ";"/
        S19: 
            nextstate = S0;
        S7: 
            nextstate = S11;
        S11: 
            if (col_sync != 4'b0000) 
                nextstate = S11;
            else 
                nextstate = S3;
        default: 
            nextstate = S0;   
    endcase
end


//////////////////////////////////////////////

always_comb begin
	case(state)
		S4, S5, S6, S7: en = 1'b1;
		default en = 1'b0;
	endcase
end


always_ff @(posedge clk) begin
	if (en) begin
		left = right;
		right = button;
	end
end
		

// logic to determine what button is pressed/
	always_comb begin
		case(state)
			S4:
				case(col_sync)
					4'b0001: button = 4'h1;
					4'b0010: button = 4'h2;
					4'b0100: button = 4'h3;
					4'b1000: button = 4'hA;
					default: button = 4'h0;
				endcase
			S5:
				case(col_sync)
					4'b0001: button = 4'h4;
					4'b0010: button = 4'h5;
					4'b0100: button = 4'h6;
					4'b1000: button = 4'hB;
					default: button = 4'h0;
				endcase
			S6:
				case(col_sync)
					4'b0001: button = 4'h7;
					4'b0010: button = 4'h8;
					4'b0100: button = 4'h9;
					4'b1000: button = 4'hC;
					default: button = 4'h0;
				endcase
			S7:
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

// assigning new seg vals when pressed //////
	//always_ff @(posedge clk) begin
		// counter[#] controlls toggle speed
	//	if (!reset) begin
	//		left <= 4'h0;
	//		right <= 4'h0; 
	//	end else if (left != button) begin
		//	if (debounce == 1'b1) begin
		//		left <= right;
		//		right <= button;
		//	end
		//end else begin
		//	left <= left;
		//	right <= button;
		//end
	//end
/////////////////////////////////////////////

// row scan based on state /////////////////////////////////////////////
always_comb begin
    case(state)
        S0, S4, S8, S12, S13: r_sel = 4'b1110;
        S1, S5, S9, S14, S15: r_sel = 4'b1101;
        S2, S6, S10, S16, S17: r_sel = 4'b1011;
        S3, S7, S11, S18, S19: r_sel = 4'b0111;
        default: r_sel = 4'b0000; // Default value
    endcase
end
////////////////////////////////////////////////////////////////////////

endmodule