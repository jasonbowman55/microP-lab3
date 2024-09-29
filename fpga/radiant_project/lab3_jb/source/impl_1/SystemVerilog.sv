// Jason Bowman
// 9-16-24
// jbowman@g.hmc.edu
// This lab combines the knowledge from the two previous labs and employs a 12 buton array of number to display oinb a dual seven semgment display

module top (
	input logic reset,
	output logic [3:0] r_sel,
	output logic clk
	);
	
	logic [24:0] clk_slow;
	
	// HSOSC instantiation //////////////////////////////////// TAKEN OUT FOR MODEL SIM
HSOSC #(.CLKHF_DIV(2'b01)) 
	hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
///////////////////////////////////////////////////////////
	always_ff @(posedge int_osc) begin
		if (!reset) begin
			clk_slow = 25'h0;
		end else begin
			clk_slow = clk_slow + 25'h1;
		end
	end

assign clk = clk_slow[15];
	
// defining state variables /////
	logic [19:0] state, nextstate;
	logic [3:0] button;
	
	parameter S0 = 12'b000000000001;
	parameter S1 = 12'b000000000010;
	parameter S2 = 12'b000000000100;
	parameter S3 = 12'b000000001000;
	parameter S4 = 12'b000000010000;
	parameter S5 = 12'b000000100000;
	parameter S6 = 12'b000001000000;
	parameter S7 = 12'b000010000000;
	parameter S8 = 12'b000100000000;
	parameter S9 = 12'b001000000000;
	parameter S10 = 12'b010000000000;
	parameter S11 = 12'b100000000000;
///////////////////////////////////

// next state = nextstate on every clk edge
	always_ff @(posedge clk)
		if (!reset) 
			state <= S0;
		else 	
			state <= nextstate;	
	
always_comb
    case(state)
        S0: if (r_sel == 4'b1111) begin
				nextstate = S4;
			end else begin
				nextstate = S1;
			end
		S4: nextstate = S8;
		S8: if (r_sel == 4'b1111) begin
				nextstate = S8;
			end else begin
				nextstate = S0;
			end
		
		
		
		
		S1: if (r_sel == 4'b1111) begin
				nextstate = S5;
			end else begin
				nextstate = S2;
			end
		S5: nextstate = S9;
		S9: if (r_sel == 4'b1111) begin
				nextstate = S9;
			end else begin
				nextstate = S1;
			end
			
			
			
			
		S2: if (r_sel == 4'b1111) begin
				nextstate = S6;
			end else begin
				nextstate = S3;
			end
		S6: nextstate = S10;
		S10: if (r_sel == 4'b1111) begin
				nextstate = S10;
			end else begin
				nextstate = S2;
			end
			
			
			
			
		S3: if (r_sel == 4'b1111) begin
				nextstate = S7;
			end else begin
				nextstate = S0;
			end
		S7: nextstate = S11;
		S11: if (r_sel == 4'b1111) begin
				nextstate = S11;
			end else begin
				nextstate = S3;
			end

        default: nextstate = S0;   
    endcase

// row scan based on state /////////////////////////////////////////////
	always_comb begin
		r_sel = (state == S0 || state == S4 || state == S8) ? 4'b1110 :
				(state == S1 || state == S5 || state == S9) ? 4'b1101 :
				(state == S2 || state == S6 || state == S10) ? 4'b1011 :
				(state == S3 || state == S7 || state == S11) ? 4'b0111 :
				4'b1111; // Default value
	end
///////////////////////////


endmodule

