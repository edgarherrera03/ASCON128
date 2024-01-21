`timescale 1ns/1ps

module constant_addition_tb import ascon_pack::*;
  (
   );

   logic[3:0] round_s;
   type_state constant_add_s, constant_add_e;

   constant_addition DUT (
	.round_i(round_s),
	.constant_add_i(constant_add_e),
	.constant_add_o(constant_add_s)
		     );

   initial
     begin
	round_s = 0;
	constant_add_e[0]=64'h8899aabbccddeeff;
	constant_add_e[1]=64'h0011223344556677;
	constant_add_e[2]=64'h08090a0b0c0d0e0f;
	constant_add_e[3]=64'h0001020304050607;
	constant_add_e[4]=64'h80400c0600000000;
	
     end
   endmodule : constant_addition_tb
