module seven_seg_decoder (
	input logic reset,
	input logic [3:0] button,
	input logic [24:0] counter,
	input logic int_osc,
	input logic en,
	output logic [6:0] seg,
	output logic [1:0] osc
	);
	
// Instantiate internal segment variables
logic [6:0] newseg;
logic [6:0] prevseg;
/////////////////////////////////////////


// update newseg ///////////////////////
	always_comb begin
		case(button)
			4'h0: newseg = 7'b0000001;
			4'h1: newseg = 7'b1001111;
			4'h2: newseg = 7'b0010010;
			4'h3: newseg = 7'b0000110;
			4'h4: newseg = 7'b1001100;
			4'h5: newseg = 7'b0100100;
			4'h6: newseg = 7'b0100000;
			4'h7: newseg = 7'b0001111;
			4'h8: newseg = 7'b0000000;
			4'h9: newseg = 7'b0001100;
			4'hA: newseg = 7'b0001000;
			4'hB: newseg = 7'b1100000;
			4'hC: newseg = 7'b0110001;
			4'hD: newseg = 7'b1000010;
			4'hE: newseg = 7'b0110000;
			4'hF: newseg = 7'b0111000;
			default: newseg = 7'b1111111;
		endcase
	end
/////////////////////////////////////////


// setting and saving prevseg to be the old newseg whenever there is a button press
	always_ff @(posedge int_osc) begin
		if (!reset) begin
			prevseg <= 7'b0000001; //DELETED LINE FOR NEWSEWG
		end
		else if (counter[12]) begin
			osc <= 2'b01;
			seg <= newseg;
		end
		else if (!counter[12]) begin
			osc <= 2'b10;
			seg <= prevseg;
		end
		else if (en) begin
			prevseg <= newseg;
		end
	end
//////////////////////////////////////////////////////////////////////////////////


// osc based on counter /////////////////
//DELETED AND INTEGRATED WITH THE ONE ABOVE
/////////////////////////////////////////


endmodule