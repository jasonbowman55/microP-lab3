module syncronizer (
	input logic reset,
	output logic int_osc,
	output logic [24:0] counter
	);
		
// HSOSC instantiation ////////////////////////////////////
HSOSC #(.CLKHF_DIV(2'b01)) 
	hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
///////////////////////////////////////////////////////////
	
	
// Counter block //////////////////////////
always_ff @(posedge int_osc) begin
    if (!reset)
		counter <= 25'b0000000000000000000000000;
    else
        counter <= counter + 25'b0000000000000000000000001;
end
//////////////////////////////////////////
	
	
endmodule