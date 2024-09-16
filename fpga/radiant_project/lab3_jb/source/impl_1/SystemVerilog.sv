// Jason Bowman
// 9-16-24
// jbowman@g.hmc.edu
// This lab combines the knowledge from the two previous labs and employs a 12 buton array of number to display oinb a dual seven semgment display

module top (
	input logic reset,
	input logic [3:0] row,
	input logic [2:0] col,
	output logic [6:0] seg,
	output logic [1:0] osc
	);
// internal counter variable instantiation
	logic [24:0] counter;
	
// HSOSC logic used to increment the counter variable, allowing selection of toggle speed between displays
HSOSC #(.CLKHF_DIV(2'b01)) 
	hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

always_ff @(posedge int_osc) begin
    if (reset == 0)
		counter <= 24'b0;
    else
        counter <= counter + 1'b1;
end

// controls display toggle speed and updates corresponding inputs for binary-to-hexadecimal combinational logic
always_ff @(posedge int_osc) begin
    // counter[#] controlls toggle speed
	if (counter[12] == 0) begin
		osc[0] <= 1; // turn on left display
		osc[1] <= 0;
	end
    else begin
		osc[0] <= 0;
		osc[1] <= 1; // turn on right display
    end
end

// instantiated submodules
button_decoder ();

seven_seg_decoder ();

endmodule



module button_decoder (
	input logic [3:0] row,
	input logic [2:0] col,
	
