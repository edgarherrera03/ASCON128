`timescale 1ns/1ps

module ascon_top_tb import ascon_pack::*; ();

   // inputs for ASCON
   logic 	  clock_s = 1'b0;
   logic 	  resetb_s, start_s;
   logic [63:0]   data_s;
   logic 	  data_valid_s;
   logic [127:0]  key_s;
   logic [127:0]  nonce_s;

   // outputs of ASCON
   logic [63:0]   cipher_s;
   logic 	  cipher_valid_s;
   logic [127:0]  tag_s;
   logic 	  end_s;

   ascon_top ascon_top_u
     (
      .clock_s(clock_s),
      .resetb_s(resetb_s),
      .start_s(start_s),
      .data_s(data_s),
      .data_valid_s(data_valid_s),
      .key_s(key_s),
      .nonce_s(nonce_s),
      .cipher_s(cipher_s),
      .cipher_valid_s(cipher_valid_s),
      .tag_s(tag_s),
      .end_s(end_s)
      );
   
   // Clock generation
	initial begin : clock_gen
      	forever #10 clock_s = ~ clock_s;
  		end

   	initial begin : main

      	key_s = 128'h000102030405060708090a0b0c0d0e0f;
      	nonce_s = 128'h00112233445566778899aabbccddeeff;
      	resetb_s   = 1'b0;
      	start_s = 1'b0;
      	data_valid_s = 1'b0;
      	data_s = 64'h0;

      	#100;
      	resetb_s   = 1'b1;
      	#20;
	//Début du programme
      	start_s = 1'b1; 
      	#20;
      	start_s = 1'b0;
	#240;
	//Xor avec A1
	data_valid_s=1'b1;
	data_s=64'h3230323380000000;
	#20;
	data_valid_s= 1'b0;
	#100;
	//Xor avec P1	
	data_valid_s = 1'b1;	
	data_s=64'h436f6e636576657a;
	#20;
	data_valid_s= 1'b0;
	#100;
	//Xor avec P2
	data_valid_s = 1'b1;
	data_s=64'h204153434f4e2065;
	#20;
	data_valid_s= 1'b0;
	#100;
	//Xor avec P3	
	data_valid_s = 1'b1;
	data_s=64'h6e2053797374656d;
	#20;
	data_valid_s = 1'b0;
	#100;
	//Xor avec P4
	data_valid_s = 1'b1;
	data_s=64'h566572696c6f6780;
	#20;
	data_valid_s = 1'b0;
	#240;
	data_valid_s = 1'b1;
	#20;
	data_valid_s = 1'b0;
   end
endmodule : ascon_top_tb
