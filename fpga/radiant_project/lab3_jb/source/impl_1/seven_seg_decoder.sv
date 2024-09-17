module seven_seg_decoder (
	input logic reset,
	input logic [3:0] button,
	input logic [3:0] col,
	output logic [6:0] seg,
	output logic [1:0] osc
	);
	
// Instantiate internal segment variables
logic [6:0] newseg;
logic [6:0] prevseg;
/////////////////////////////////////////

// update newseg ////////////////////////////////////////////
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
		if (|col) begin
			prevseg = newseg;
		end
		else begin
			prevseg = prevseg;
		end
	end
//////////////////////////////////////////////////////////////////////////////////

endmodule