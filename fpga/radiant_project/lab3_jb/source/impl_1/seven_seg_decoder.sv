module seven_seg_decoder (
	input logic [3:0] select,
	output logic [6:0] seg
	);
// update seg ///////////////////////
	always_comb begin
		case(select)
    			4'h0: seg = 7'b1000000; // 0000001 flipped
    			4'h1: seg = 7'b1111001; // 1001111 flipped
    			4'h2: seg = 7'b0100100; // 0010010 flipped
    			4'h3: seg = 7'b0111000; // 0000110 flipped
    			4'h4: seg = 7'b0011010; // 1001100 flipped
    			4'h5: seg = 7'b0010010; // 0100100 flipped
    			4'h6: seg = 7'b0000001; // 0100000 flipped
    			4'h7: seg = 7'b1111000; // 0001111 flipped
    			4'h8: seg = 7'b1111111; // 0000000 flipped
    			4'h9: seg = 7'b0011000; // 0001100 flipped
    			4'hA: seg = 7'b0000100; // 0001000 flipped
    			4'hB: seg = 7'b0000011; // 1100000 flipped
    			4'hC: seg = 7'b1000011; // 0110001 flipped
    			4'hD: seg = 7'b0100001; // 1000010 flipped
    			4'hE: seg = 7'b0001110; // 0110000 flipped
    			4'hF: seg = 7'b0000111; // 0111000 flipped
    			default: seg = 7'b1111111; // All bits high
		endcase
	end
/////////////////////////////////////
endmodule