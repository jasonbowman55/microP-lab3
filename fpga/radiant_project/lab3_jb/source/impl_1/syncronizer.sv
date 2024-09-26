module syncronizer (
	input logic reset,
	input logic [3:0] col,
	input logic clk,
	output logic [3:0] col_sync,
	output logic [24:0] counter
	);

//logic [3:0] n1;
	assign col_sync = col;
// syncronizing col inputs ////////
//always_ff @(posedge clk) begin
//	if (!reset) begin
//		col_sync <= 4'b0000;
//		n1 <= 4'b0000;
//	end
//	else begin
//		n1 <= !col;
//		col_sync <= n1;
//	end
//end
//////////////////////////////////

// Counter block //////////////////////////
always_ff @(posedge clk) begin
    if (!reset)
	counter <= 25'h0; //CHANGE
    else
        counter <= counter + 25'h1;
end
//////////////////////////////////////////
	
	
endmodule
