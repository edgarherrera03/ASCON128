module permutation import ascon_pack::*;

	(
	input logic clock_i,
	input logic resetb_i, 
	input logic select_i,
	input type_state permutation_i,
	input logic [3:0] round_i,
	output type_state permutation_o
	);

	type_state state_to_pc, state_to_ps, state_to_pl, state_to_r, register_output_s;

	//Multiplexeur
	assign state_to_pc = (select_i==0) ? permutation_i : permutation_o;
	

	//Addition constante (Pc)
	constant_addition constant_addition_u
	(
	.constant_add_i(state_to_pc), 
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
	.d_o(state_to_r)
	);
	
	//Registre
	always_ff @(posedge clock_i, negedge resetb_i) begin 
		if(resetb_i == 1'b0) begin 
			register_output_s <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
		end
		else begin 
			register_output_s <= state_to_r;
		end
	end
	
	assign permutation_o = register_output_s;
	
	
endmodule : permutation
