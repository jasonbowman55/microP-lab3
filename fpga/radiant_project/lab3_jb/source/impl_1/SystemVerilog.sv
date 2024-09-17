// Jason Bowman
// 9-16-24
// jbowman@g.hmc.edu
// This lab combines the knowledge from the two previous labs and employs a 12 buton array of number to display oinb a dual seven semgment display

module top (
	input logic reset,
	input logic [2:0] col,
	input logic [24:0] counter,
	input logic button_press,
	input logic[6:0] newseg,
	input logic[6:0] prevseg,
	output logic [6:0] seg,
	output logic [1:0] osc,
	output logic [3:0] r_sel
	);

// controls display toggle speed and updates corresponding inputs for binary-to-hexadecimal combinational logic
always_ff @(posedge int_osc) begin
    // counter[#] controlls toggle speed
	if (counter[12] == 0) begin
		seg <= newseg;
		osc <= 2'b01;
	end
    else begin
		seg <= prevseg;
		osc <= 2'b10;
    end
end
//////////////////////////////////////////////////////////////////


// instantiated submodules
button_decoder MOD1 (reset, col, r_sel, button);

seven_seg_decoder MOD2 (reset, button, seg, osc);

count_osc_sel_button MOD3 (reset, col, int_osc, counter, osc, button_press, r_sel);

endmodule
//////////////////////////////////////////////////
//===============================================
//////////////////////////////////////////////////
module button_decoder (
	input logic reset,
	input logic [2:0] col,
	input logic [3:0] r_sel,
	output logic [3:0] button
	);
	
	assign button = 4'b0001;
	
endmodule
//////////////////////////////////////////////////
//===============================================
//////////////////////////////////////////////////
module seven_seg_decoder (
	input logic reset,
	input logic [3:0] button,
	input logic int_osc,
	input logic [24:0] counter,
	input logic button_press,
	output logic [1:0] osc,
	output logic [6:0] seg,
	output logic[6:0] newseg,
	output logic[6:0] prevseg
	);
	
	
// Instantiate internal segment variables
//////////////////////////////////////////////////////////////////


// update newseg////////////////////////////////////////////
	always_comb begin
		case(button)
			4'b0000: newseg = 7'b0000001;
			4'b0001: newseg = 7'b1001111;
			4'b0010: newseg = 7'b0010010;
			4'b0011: newseg = 7'b0000110;
			4'b0100: newseg = 7'b1001100;
			4'b0101: newseg = 7'b0100100;
			4'b0110: newseg = 7'b0100000;
			4'b0111: newseg = 7'b0001111;
			4'b1000: newseg = 7'b0000000;
			4'b1001: newseg = 7'b0001100;
			4'b1010: newseg = 7'b0001000;
			4'b1011: newseg = 7'b1100000;
			4'b1100: newseg = 7'b0110001;
			4'b1101: newseg = 7'b1000010;
			4'b1110: newseg = 7'b0110000;
			4'b1111: newseg = 7'b0111000;
			default: newseg = 7'b1111111;
		endcase
	end
/////////////////////////////////////////////////////////////////


// setting and saving prevseg to be the old newseg whenever there is a button press
	always_ff @(posedge int_osc) begin
		if (button_press) begin
			prevseg = newseg;
		end
		else begin
			prevseg = prevseg;
		end
	end
//////////////////////////////////////////////////////////////////////////////////

endmodule
//////////////////////////////////////////////////
//===============================================
//////////////////////////////////////////////////
module count_osc_sel_button(
	input logic reset,
	input logic [2:0] col,
	output logic int_osc,
	output logic [24:0] int_counter,
	output logic [1:0] osc,
	output logic button_press,
	output logic [3:0] r_sel
	);
	
	
	
// HSOSC instantiation ////////////////////////////////////
HSOSC #(.CLKHF_DIV(2'b01)) 
	hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
///////////////////////////////////////////////////////////
	
// Counter block //////////////////////////////////////////
always_ff @(posedge int_osc) begin
    if (!reset)
		int_counter <= 24'b0;
    else
        int_counter <= int_counter + 1'b1;
end

assign counter = int_counter;
///////////////////////////////////////////////////////////

// row select (toggle through rows)////////////////////////
always_comb begin
	case(int_counter[6:5])
		2'b00: r_sel = 4'b0001;
		2'b01: r_sel = 4'b0010;
		2'b10: r_sel = 4'b0100;
		2'b11: r_sel = 4'b1000;
		default r_sel = 4'bxxxx;
	endcase
end
///////////////////////////////////////////////////////////

// oscillator block ///////////////////////////////////////
always_ff @(posedge int_osc) begin
    // counter[#] controlls toggle speed
	if (!int_counter[12]) begin
		osc <= 2'b01;
	end
    else begin
		osc <= 2'b10;
    end
end
///////////////////////////////////////////////////////////

// button press detector //////////////////////////////////
always_ff @(posedge int_osc) begin
    // counter[#] controlls toggle speed
	if (|col) begin
		button_press = 1'b1;
	end
    else begin
		button_press = 1'b0;
    end
end
///////////////////////////////////////////////////////////

endmodule

