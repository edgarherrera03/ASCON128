`timescale 1ns/1ps

module ascon_top import ascon_pack::*;
	(
	 input logic 	  clock_s = 1'b0,
   	 input logic 	  resetb_s,
	 input logic	  start_s,
   	 input logic [63:0]   data_s,
   	 input logic 	  data_valid_s,
   	 input logic [127:0]  key_s,
	 input logic [127:0]  nonce_s,
	 output logic [63:0]   cipher_s,
   	 output logic 	  cipher_valid_s,
   	 output logic [127:0]  tag_s,
   	 output logic 	  end_s
	);

	logic ena_xor_up_s, ena_xor_down_s, ena_reg_s, init_a_s, init_b_s, init_state_s, ena_cpt_s, ena_block_s, init_block_s;
	logic [255:0] data_xor_down_s;
	logic[1:0] conf_xor_down_s;
	logic[3:0] count_s;
	logic[2:0] block_s;
	type_state permutation_e; 
	type_state permutation_s, state_to_cipher_s;

	assign permutation_e = {64'h80400c0600000000, key_s, nonce_s};
	
	fsm_moore fsm_moore_u
	(
	.clock_i(clock_s),
	.resetb_i(resetb_s),
	.start_i(start_s),
	.data_valid_i(data_valid_s),
	.round_i(count_s),
	.block_i(block_s),
	.ena_reg_state_o(ena_reg_s),
	.cipher_valid_o(cipher_valid_s),
	.end_o(end_s),
	.init_state_o(init_state_s),
	.ena_cpt_o(ena_cpt_s),
	.ena_block_o(ena_block_s),
	.init_a_o(init_a_s),
	.init_b_o(init_b_s),
	.init_block_o(init_block_s),
	.conf_xor_down_o(conf_xor_down_s),
	.ena_xor_up_o(ena_xor_up_s),
	.ena_xor_down_o(ena_xor_down_s)
	);

	permutation_xor permutation_xor_u
	(
	.clock_i(clock_s),
	.resetb_i(resetb_s),
	.select_i(init_state_s),
	.ena_xor_up(ena_xor_up_s),
	.ena_xor_down(ena_xor_down_s),
	.ena_reg_i(ena_reg_s),
	.permutation_i(permutation_e),
	.data_xor_up(data_s),
	.round_i(count_s),
	.data_xor_down(data_xor_down_s),
	.permutation_o(permutation_s),
	.state_to_cipher(state_to_cipher_s)
	);

	counter_double_init counter_double_init_u
	(
	.clock_i(clock_s),
	.resetb_i(resetb_s),
	.ena_i(ena_reg_s),
	.init_a_i(init_a_s),
	.init_b_i(init_b_s),
	.count_o(count_s)
	);

	counter_block counter_block_u
	(
	.clock_i(clock_s),
	.resetb_i(resetb_s),
	.ena_block_i(ena_block_s),
	.init_block_i(init_block_s),
	.block_o(block_s)
	);
	//Combinatoire : choix de la valeur de data_xor_down
	always_comb begin
		data_xor_down_s = 256'h0;
		case(conf_xor_down_s)
			2'b00:begin
				data_xor_down_s={128'h0,key_s};
			end
			2'b01:begin
				data_xor_down_s={255'h0,1'b1};
			end
			2'b10:begin
				data_xor_down_s={key_s, 128'h0};
			end
			2'b11:begin 
				data_xor_down_s={128'h0,key_s};
			end  
		endcase	
	end
	
	//Registre cipher
	always_ff @(posedge clock_s, negedge resetb_s) begin 
		if(resetb_s == 1'b0) begin 
			cipher_s <= {64'h0};
		end
		else begin 
			if (cipher_valid_s == 1'b1) begin
				cipher_s <= state_to_cipher_s[0];
			end
		end
	end
	//Registre tag
	always_ff @(posedge clock_s, negedge resetb_s) begin 
		if(resetb_s == 1'b0) begin
			tag_s <= {128'h0};
		end		
		else begin 
			if(end_s == 1'b1) begin 
			tag_s <= {permutation_s[3], permutation_s[4]};
			end
		end
	end

endmodule : ascon_top

