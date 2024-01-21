module counter_block
	(
	 input logic		clock_i,
	 input logic		resetb_i,
	 input logic		ena_block_i,
	 input logic		init_block_i,
	 output logic [2:0]	block_o
	 );

	logic [2:0]			block_s;

	always @(posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin
			block_s <= 0;
		end
		else begin
			if (ena_block_i == 1'b1) begin
				if (init_block_i == 1'b1)
					block_s <= 0;
				else
					block_s <= block_s + 1;
			end
		end
	end // always @ (posedge clock_i, negedge resetb_i)

	assign block_o = block_s;
	
endmodule // counter_block

