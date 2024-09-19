module syncronizer (
	input logic reset,
	output logic int_osc,
	output logic [24:0] counter
	);
	
	
// HSOSC instantiation ////////////////////////////////////
initial begin
    int_osc = 1'b0;  // Initialize the clock to 0
end

always begin
    #50 int_osc = ~int_osc; // Toggle every 50 time units to create clock
end							 // CREATING A CLOCK SIGNAL FOOR MODEL SIM

///////////////////////////////////////////////////////////
	
	
// Counter block //////////////////////////
always_ff @(posedge int_osc) begin
    if (!reset)
		counter <= 25'b0;
    else
        counter <= counter + 25'h1;
end
//////////////////////////////////////////
	
	
endmodule