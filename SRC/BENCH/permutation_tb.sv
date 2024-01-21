`timescale 1ns/1ps

module permutation_tb import ascon_pack::*;
	(
	);
	
	logic clock_s,resetb_s, select_s;
	logic[3:0] round_s;
	type_state permutation_e, permutation_s;

	permutation DUT (
		.clock_i(clock_s),
		.resetb_i(resetb_s),	
		.select_i(select_s),
		.round_i(round_s),
		.permutation_i(permutation_e),
		.permutation_o(permutation_s)
		);


	//Clock generation
	initial
	begin
		clock_s = 0;
		forever #5 clock_s = ~ clock_s ;
	end

	initial
     		begin
			round_s = 0;
			select_s = 0;
			resetb_s = 0; 
			permutation_e[0]=64'h1fc9a149abfd3af5;
			permutation_e[1]=64'hdbf3ecfb9b64a1c2;
			permutation_e[2]=64'h755af9d2d12f5d05;
			permutation_e[3]=64'h6654c154e6e248f1;
			permutation_e[4]=64'h169557420d2a6714;
			
			#10
			resetb_s = 1;

     		end

endmodule : permutation_tb
