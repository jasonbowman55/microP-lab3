module syncronizer (
	input logic reset,
	input logic [3:0] col,
	output logic clk,
	output logic [3:0] col_sync,
	output logic [24:0] counter
	);
		
// HSOSC instantiation ////////////////////////////////////
//HSOSC #(.CLKHF_DIV(2'b01)) 
	//hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
///////////////////////////////////////////////////////////
	
logic [3:0] n1;
	
// syncronizing col inputs ////////
always_ff @(posedge clk) begin
	if (!reset) begin
		col_sync <= 4'b0000;
		n1 <= 4'b0000;
	end
	else begin
		n1 <= col;
		col_sync <= n1;
	end
end
//////////////////////////////////

// Counter block //////////////////////////
always_ff @(posedge clk) begin
    if (!reset)
		counter <= 0;
    else
        counter <= counter + 1;
end
//////////////////////////////////////////
	
	
endmodule