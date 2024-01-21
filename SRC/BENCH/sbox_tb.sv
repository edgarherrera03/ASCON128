`timescale 1ns/1ps

  module sbox_tb
    (
     );

   logic [4:0] sbox_e;
   logic [4:0] sbox_s;

   sbox DUT (
	     .sbox_i(sbox_e),
	     .sbox_o(sbox_s)
	     );
   initial
     begin
	sbox_e = 5'h00;
	#20;
	sbox_e = 5'h01;
	#20;
	sbox_e = 5'h02;
	#20;
	sbox_e = 5'h03;
	#20;
	sbox_e = 5'h04;
	#20;
	sbox_e = 5'h05;
	#20;
	sbox_e = 5'h06;
	#20;
	sbox_e = 5'h07;
	#20;
	sbox_e = 5'h08;
	#20;
	sbox_e = 5'h09;
	#20;
	sbox_e = 5'h0A;
	#20;
	sbox_e = 5'h0B;
	#20;
	sbox_e = 5'h0C;
	#20;
	sbox_e = 5'h0D;
	#20;
	sbox_e = 5'h0E;
	#20;
	sbox_e = 5'h0F;
	#20;
	sbox_e = 5'h10;
	#20;
	sbox_e = 5'h11;
	#20;
	sbox_e = 5'h12;
	#20;
	sbox_e = 5'h13;
	#20;
	sbox_e = 5'h14;
	#20;
	sbox_e = 5'h15;
	#20;
	sbox_e = 5'h16;
	#20;
	sbox_e = 5'h17;
	#20;
	sbox_e = 5'h18;
	#20;
	sbox_e = 5'h19;
	#20;
	sbox_e = 5'h1A;
	#20;
	sbox_e = 5'h1B;
	#20;
	sbox_e = 5'h1C;
	#20;
	sbox_e = 5'h1D;
	#20;
	sbox_e = 5'h1E;
	#20;
	sbox_e = 5'h1F;

     end
   endmodule : sbox_tb
