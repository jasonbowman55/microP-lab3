module debouncer (
	input logic reset,
	input logic clk,
	input logic [3:0] col_sync,
	output logic [2:0] debounce
	);
	


	always_ff @(posedge clk) begin // not using debounce for debugging purposes
		if (!reset) begin
			debounce = 1'b0;
		end else if (|col_sync) begin
			if (debounce < 3'b111) begin
				debounce = debounce + 1'b1;
			end
		end else begin
			debounce = 3'b0;
		end
	end
		
endmodule