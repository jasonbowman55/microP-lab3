module button_decoder_bounce (
	input logic reset,
	input logic [3:0] col_sync,
	input logic int_osc,
	input logic [24:0] counter,
	output logic en,
	output logic [3:0] r_sel,
	output logic [3:0] select,
	output logic [1:0] osc
	);

// defining state variables /////
	logic [4:0] state, nextstate;
	logic [3:0] button;
	
	parameter S0 = 5'b00000;
	parameter S1 = 5'b00001;
	parameter S2 = 5'b00010;
	parameter S3 = 5'b00011;
	parameter S4 = 5'b00100;
	parameter S5 = 5'b00101;
	parameter S6 = 5'b00110;
	parameter S7 = 5'b00111;
	parameter S8 = 5'b01000;
	parameter S9 = 5'b01001;
	parameter S10 =5'b01010;
	parameter S11 = 5'b01011;
	parameter S20 = 5'b01100;
	parameter S21 = 5'b01101;
	parameter S22 = 5'b01110;
	parameter S23 = 5'b01111;
	parameter S24 = 5'b10000;
	parameter S25 = 5'b10001;
	parameter S26 = 5'b10010;
	parameter S27 = 5'b10011;
	parameter S28 = 5'b10100;
	

	logic [3:0] right;
	logic [3:0] left;
/////////////////////////////////

// setting state = 
always_ff @(posedge int_osc)
	if (!reset) state <= S0;
	else 		state <= nextstate;


/// Cycling through states dead states betwee
	always_comb
		case(state)
			// row 1
			S0: nextstate = S20; //dead states
			S20: nextstate = S21;
			S21: if(|col_sync) nextstate = S4;
				else nextstate = S1;
			S4: nextstate = S8;
			S8: if (|col_sync) nextstate = S8;
				else nextstate = S0;
			
			// row 2
			S1: nextstate = S23; //dead states
			S23: nextstate = S24;
			S24: if(|col_sync) nextstate = S5;
				else nextstate = S2;
			S5: nextstate = S9;
			S9: if (|col_sync) nextstate = S9;
				else nextstate = S1;
			
			// row 3
			S2: nextstate = S25; //dead states
			S25: nextstate = S26;
			S26: if(|col_sync) nextstate = S6;
				else nextstate = S3;
			S6: nextstate = S10;
			S10: if (|col_sync) nextstate = S10;
				else nextstate = S2;
			
			// row 4
			S3: nextstate = S27; //dead states
			S27: nextstate = S28;
			S28: if(|col_sync) nextstate = S7;
				else nextstate = S0;
			S7: nextstate = S11;
			S11: if (|col_sync) nextstate = S11;
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

// enables
	always_comb begin
		en = (state == S4 || state == S5 || state == S6 || state == S7) ? 1'b1:
		1'b0;
	end

// logic to determine what button is pressed
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
		endcase
	end
///////////////////////////////////////////	
	
always_ff @(posedge int_osc) begin
	// counter[#] controlls toggle speed
	if (en) begin
		left <= right;
		right <= button;
	end
end

// Debouncer ////////////////////////////
always_ff @(posedge int_osc) begin
	// counter[#] controlls toggle speed
	if (counter[12]) begin
		select <= right;
		osc <= 2'b01;
	end else begin
		select <= left;
		osc <= 2'b10;
	end
end
	/////////////////////////////////////////


endmodule