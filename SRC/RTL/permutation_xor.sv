module permutation_xor import ascon_pack::*;

	(
	input logic clock_i,
	input logic resetb_i, 
	input logic select_i,
	input logic ena_xor_up,
	input logic ena_xor_down,
	input logic ena_reg_i,
	input type_state permutation_i,
	input logic [63:0] data_xor_up,
	input logic [3:0] round_i,
	input logic [255:0] data_xor_down,
	output type_state permutation_o,
	output type_state state_to_cipher  //Valeur en sortie du Xor up qui nous permet de recupérer les Ci
	);

	type_state state_to_xor_up, state_to_ps, state_to_pl, state_to_xor_down, state_to_r, register_output_s;

	//Multiplexeur
	assign state_to_xor_up = (select_i==1) ? permutation_i : permutation_o;
	
	//Xor_up
	assign state_to_cipher[0] = (ena_xor_up==1)? data_xor_up ^ state_to_xor_up[0] : state_to_xor_up[0];
	assign state_to_cipher[1] = state_to_xor_up[1];
	assign state_to_cipher[2] = state_to_xor_up[2];
	assign state_to_cipher[3] = state_to_xor_up[3];
	assign state_to_cipher[4] = state_to_xor_up[4];

	//Addition constante (Pc)
	constant_addition constant_addition_u
	(
	.constant_add_i(state_to_cipher), 
	.round_i(round_i),
	.constant_add_o(state_to_ps)
	);

	//Sbox (Ps)
	substitution_layer substitution_layer_u 
	(
	.substitution_i(state_to_ps),
	.substitution_o(state_to_pl)
	);

	//Diffusion (Pl)
	diffusion_layer diffusion_layer_u
	(
	.d_i(state_to_pl),
	.d_o(state_to_xor_down)
	);

	//Xor_down
	
	assign state_to_r[0] = state_to_xor_down[0];
	assign state_to_r[1] = (ena_xor_down==1)? data_xor_down[255:192] ^ state_to_xor_down[1] : state_to_xor_down[1];
	assign state_to_r[2] = (ena_xor_down==1)? data_xor_down[191:128] ^ state_to_xor_down[2] : state_to_xor_down[2];
	assign state_to_r[3] = (ena_xor_down==1)? data_xor_down[127:64] ^ state_to_xor_down[3] : state_to_xor_down[3];
	assign state_to_r[4] = (ena_xor_down==1)? data_xor_down[63:0] ^ state_to_xor_down[4] : state_to_xor_down[4];
	
	//Registre
	always_ff @(posedge clock_i, negedge resetb_i) begin 
		if(resetb_i == 1'b0) begin 
			register_output_s <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
		end
		else if (ena_reg_i == 1'b1) begin
				register_output_s <= state_to_r;
			end
		else begin
			register_output_s <= state_to_xor_up; //Nous permet de mettre en stand by le programme tant qu'on est dans un état wait
		end
	end
	
	assign permutation_o = register_output_s;
	
	
endmodule : permutation_xor
