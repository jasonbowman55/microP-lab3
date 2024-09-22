module seven_seg_decoder (
	input logic reset,
	input logic [3:0] select,
	input logic int_osc,
	input logic en,
	output logic [6:0] seg
	);
	
// Instantiate internal segment variables

/////////////////////////////////////////

// update newseg ///////////////////////
	always_comb begin
		case(select)
			4'h0: seg = 7'b0000001;
			4'h1: seg = 7'b1001111;
			4'h2: seg = 7'b0010010;
			4'h3: seg = 7'b0000110;
			4'h4: seg = 7'b1001100;
			4'h5: seg = 7'b0100100;
			4'h6: seg = 7'b0100000;
			4'h7: seg = 7'b0001111;
			4'h8: seg = 7'b0000000;
			4'h9: seg = 7'b0001100;
			4'hA: seg = 7'b0001000;
			4'hB: seg = 7'b1100000;
			4'hC: seg = 7'b0110001;
			4'hD: seg = 7'b1000010;
			4'hE: seg = 7'b0110000;
			4'hF: seg = 7'b0111000;
			default: seg = 7'b1111111;
		endcase
	end
/////////////////////////////////////////




endmodule