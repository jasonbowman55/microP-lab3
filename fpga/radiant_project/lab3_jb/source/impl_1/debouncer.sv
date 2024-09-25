module debouncer (
	input logic reset,
	input logic clk,
	input logic [3:0] col_sync,
	output logic [4:0] debounce
	);
	
	always_ff @(posedge clk) begin
		if (!reset) begin
			debounce = 5'h0;
		end else if (|col_sync) begin
			debounce = debounce + 5'h1;
		end else begin
			debounce = debounce;
		end
	end
		
endmodule