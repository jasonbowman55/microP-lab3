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
always_ff @(posedge clk) begin
    if (!reset) 
        state <= S0;
    else 
        state <= nextstate;	
end
	
always_comb begin
    case(state)
        S0: 
            if (r_sel == 4'b1111) 
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
            if (r_sel == 4'b1111) 
                nextstate = S8;
            else 
                nextstate = S0;
        S1: 
            if (r_sel == 4'b1111) 
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
            if (r_sel == 4'b1111) 
                nextstate = S9;
            else 
                nextstate = S1;
        S2: 
            if (r_sel == 4'b1111) 
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
            if (r_sel == 4'b1111) 
                nextstate = S10;
            else 
                nextstate = S2;
        S3: 
            if (r_sel == 4'b1111) 
                nextstate = S7;
            else 
                nextstate = S18;
        S18: 
            nextstate = S19;  // Fixed typo from ":" to ";"
        S19: 
            nextstate = S0;
        S7: 
            nextstate = S11;
        S11: 
            if (r_sel == 4'b1111) 
                nextstate = S11;
            else 
                nextstate = S3;
        default: 
            nextstate = S0;   
    endcase
end


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

