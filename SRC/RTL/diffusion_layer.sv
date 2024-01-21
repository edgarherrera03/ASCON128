`timescale 1ns/1ps

module diffusion_layer import ascon_pack::*;
	(
	input type_state d_i,
	output type_state d_o
	);


	assign d_o[0]=d_i[0]^{d_i[0][18:0], d_i[0][63:19]}^{d_i[0][27:0], d_i[0][63:28]};
	assign d_o[1]=d_i[1]^{d_i[1][60:0], d_i[1][63:61]}^{d_i[1][38:0], d_i[1][63:39]};
	assign d_o[2]=d_i[2]^{d_i[2][0], d_i[2][63:1]}^{d_i[2][5:0], d_i[2][63:6]};
	assign d_o[3]=d_i[3]^{d_i[3][9:0], d_i[3][63:10]}^{d_i[3][16:0], d_i[3][63:17]};
	assign d_o[4]=d_i[4]^{d_i[4][6:0], d_i[4][63:7]}^{d_i[4][40:0], d_i[4][63:41]};

endmodule : diffusion_layer
