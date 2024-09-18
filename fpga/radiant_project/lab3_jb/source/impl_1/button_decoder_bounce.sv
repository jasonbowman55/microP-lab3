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
	logic [7:0] state, nextstate;
	
	parameter S0 = 8'b00000001;
	parameter S1 = 8'b00000010;
	parameter S2 = 8'b00000100;
	parameter S3 = 8'b00001000;
	parameter S4 = 8'b00010000;
	parameter S5 = 8'b00100000;
	parameter S6 = 8'b01000000;
	parameter S7 = 8'b10000000;
/////////////////////////////////

// output logic at given state
	always_comb begin
		r_sel = (state == S0 || state == S4) ? 4'b0001 :
				(state == S1 || state == S5) ? 4'b0010 :
				(state == S2 || state == S6) ? 4'b0100 :
				(state == S3 || state == S7) ? 4'b1000 :
				4'b0000; // Default value
	end
///////////////////////////////
	
	
/// Cycling through states
	always_comb
		case(state)
			S0: if(|col) nextstate = S4;
				else nextstate = S1;
			S1: if(|col) nextstate = S5;
				else nextstate = S2;
			S2: if(|col) nextstate = S6;
				else nextstate = S3;
			S3: if(|col) nextstate = S7;
				else nextstate = S0;
		endcase
//////////////////////////


// logic to determine what button is pressed
	always_comb begin
		case(state)
			S4:
				case(col)
					4'b0001: button = 4'h1;
					4'b0010: button = 4'h2;
					4'b0100: button = 4'h3;
					4'b1000: button = 4'hA;
				endcase
			S5:
				case(col)
					4'b0001: button = 4'h4;
					4'b0010: button = 4'h5;
					4'b0100: button = 4'h6;
					4'b1000: button = 4'hB;
				endcase
			S6:
				case(col)
					4'b0001: button = 4'h7;
					4'b0010: button = 4'h8;
					4'b0100: button = 4'h9;
					4'b1000: button = 4'hC;
				endcase
			S7:
				case(col)
					4'b0001: button = 4'hF;
					4'b0010: button = 4'h0;
					4'b0100: button = 4'hE;
					4'b1000: button = 4'hD;
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