module debouncer (
	input logic reset,
	input logic clk,
	input logic [3:0] col_sync,
	output logic debounce
	);
	


	always_ff @(posedge clk) begin
		if (!reset) begin
			debounce = 1'b0;
		end else if (|col_sync) begin
			if (debounce < 1'b1) begin
				debounce = debounce + 1'b1;
			end
		end else begin
			debounce = 1'b0;
		end
	end
		
endmodule