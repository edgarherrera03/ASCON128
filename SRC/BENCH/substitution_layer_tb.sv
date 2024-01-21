`timescale 1ns/1ps

module substitution_layer_tb import ascon_pack::*;
	(
	);
	
	type_state substitution_e, substitution_s;
	
	substitution_layer DUT (
	.substitution_i(substitution_e),
	.substitution_o(substitution_s)
	);

	initial
	  begin
		substitution_e[0] = 64'h80400c0600000000;
		substitution_e[1] = 64'h0001020304050607;
		substitution_e[2] = 64'h08090a0b0c0d0eff;
		substitution_e[3] = 64'h0011223344556677;
		substitution_e[4] = 64'h8899aabbccddeeff;
	  end

endmodule : substitution_layer_tb
