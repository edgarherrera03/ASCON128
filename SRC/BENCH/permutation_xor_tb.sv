`timescale 1ns/1ps

module permutation_xor_tb import ascon_pack::*;
	(
	);

	logic clock_s, resetb_s, select_s, ena_xor_up_s, ena_xor_down_s, ena_reg_s;
	logic[3:0] round_s;
	logic[63:0] data_xor_up_s; 
	logic[255:0] data_xor_down_s;
	type_state permutation_e, permutation_s, state_to_cipher_s;

	permutation_xor DUT (
		.clock_i(clock_s),
		.resetb_i(resetb_s),	
		.select_i(select_s),
		.ena_xor_up(ena_xor_up_s),
		.ena_xor_down(ena_xor_down_s),
		.round_i(round_s),
		.ena_reg_i(ena_reg_s),
		.data_xor_up(data_xor_up_s),
		.data_xor_down(data_xor_down_s),
		.permutation_i(permutation_e),
		.permutation_o(permutation_s),
		.state_to_cipher(state_to_cipher_s)
		);

	//Clock generation
	initial
	begin
		clock_s = 0;
		forever #5 clock_s = ~ clock_s ;
	end
	
	//Stimluli
	initial
     	begin
		round_s = 0;
		select_s = 0;
		resetb_s = 0;
		ena_xor_up_s = 0;
		ena_xor_down_s = 0;
		data_xor_up_s = 64'h0;
		data_xor_down_s= 256'h0;
		ena_reg_s=1;
		permutation_e[0]=64'h80400c0600000000;
		permutation_e[1]=64'h0001020304050607;
		permutation_e[2]=64'h08090a0b0c0d0e0f;
		permutation_e[3]=64'h0011223344556677;
		permutation_e[4]=64'h8899aabbccddeeff;

		#10
		resetb_s =1;
		select_s=1;

		#10
		round_s=1;
		select_s=0;
		#10
		round_s=2;
		#10
		round_s=3;
		#10
		round_s=4;
		#10
		round_s=5;
		#10
		round_s=6;
		#10
		round_s=7;
		#10
		round_s=8;
		#10
		round_s=9;
		#10
		round_s=10;
		#10
		round_s=11;
		ena_xor_down_s = 1;
		data_xor_down_s=256'h000102030405060708090a0b0c0d0e0f;
		#10
		round_s=6;
		ena_xor_down_s = 0;
		ena_xor_up_s = 1;
		data_xor_up_s = 64'h3230323380000000;
				

		 
     	end
endmodule : permutation_xor_tb
