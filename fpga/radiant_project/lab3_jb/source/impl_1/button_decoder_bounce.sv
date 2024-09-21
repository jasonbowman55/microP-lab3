module button_decoder_bounce (
	input logic reset,
	input logic [3:0] col,
	input logic [24:0] counter,
	input logic int_osc,
	output logic en,
	output logic [3:0] r_sel,
	output logic [3:0] button
	);

// defining state variables /////
	logic [3:0] state, nextstate;
	
	parameter S0 = 4'b0000;
	parameter S1 = 4'b0001;
	parameter S2 = 4'b0010;
	parameter S3 = 4'b0011;
	parameter S4 = 4'b0100;
	parameter S5 = 4'b0101;
	parameter S6 = 4'b0110;
	parameter S7 = 4'b0111;
	parameter S8 = 4'b1000;
	parameter S9 = 4'b1001;
	parameter S10 = 4'b1010;
	parameter S11 = 4'b1011;
/////////////////////////////////
	
/// Cycling through states
	always_comb
		case(state)
			S0: if(|col) nextstate = S4;
				else nextstate = S1;
			S4: nextstate = S8;
			S8: if (|col) nextstate = S8;
				else nextstate = S0;
					
			S1: if(|col) nextstate = S5;
				else nextstate = S2;
			S5: nextstate = S9;
			S9: if (|col) nextstate = S9;
				else nextstate = S1;
					
			S2: if(|col) nextstate = S6;
				else nextstate = S3;
			S6: nextstate = S10;
			S10: if (|col) nextstate = S10;
				else nextstate = S2;
					
			S3: if(|col) nextstate = S7;
				else nextstate = S0;
			S7: nextstate = S11;
			S11: if (|col) nextstate = S11;
				else nextstate = S3;
		endcase
//////////////////////////

// output logic at given state
	always_comb begin
		r_sel = (state == S0 || state == S4 || state == S8) ? 4'b0001 :
				(state == S1 || state == S5 || state == S9) ? 4'b0010 :
				(state == S2 || state == S6 || state == S10) ? 4'b0100 :
				(state == S3 || state == S7 || state == S11) ? 4'b1000 :
				4'b0000; // Default value
	end
///////////////////////////////

// logic to determine what button is pressed
	always_comb begin
		case(state)
			S4:
				case(|col)
					4'b0001: button = 4'h1;
					4'b0010: button = 4'h2;
					4'b0100: button = 4'h3;
					4'b1000: button = 4'hA;
					default: button = 4'h0;
				endcase
			S5:
				case(|col)
					4'b0001: button = 4'h4;
					4'b0010: button = 4'h5;
					4'b0100: button = 4'h6;
					4'b1000: button = 4'hB;
					default: button = 4'h0;
				endcase
			S6:
				case(|col)
					4'b0001: button = 4'h7;
					4'b0010: button = 4'h8;
					4'b0100: button = 4'h9;
					4'b1000: button = 4'hC;
					default: button = 4'h0;
				endcase
			S7:
				case(|col)
					4'b0001: button = 4'hF;
					4'b0010: button = 4'h0;
					4'b0100: button = 4'hE;
					4'b1000: button = 4'hD;
					default: button = 4'h0;
				endcase
		endcase
	end
///////////////////////////////////////////


// Debouncer ////////////////////////////
	always_ff @(posedge int_osc) begin
		// counter[#] controlls toggle speed
		if (|col) begin
			en = 1'b1;
		end
		else begin
			en = 1'b0;
		end
	end
	/////////////////////////////////////////


endmodule