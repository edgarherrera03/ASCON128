`timescale 1ns/1ps

module diffusion_layer_tb import ascon_pack::*;
	(
	);

	type_state d_e, d_s;

	diffusion_layer DUT (
	.d_i(d_e),
	.d_o(d_s)
	);

	initial 
          begin
		d_e[0] = 64'h8859263f4c5d6e8f;
		d_e[1] = 64'h00c18e8584858607;
		d_e[2] = 64'h7f7f7f7f7f7f7f8f;
		d_e[3] = 64'h80c0848680808070;
		d_e[4] = 64'h8888888a88888888;
	  end

endmodule : diffusion_layer_tb
