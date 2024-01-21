module fsm_moore
  (
   input logic 	      clock_i,
   input logic 	      resetb_i,
   input logic 	      start_i,
   input logic 	      data_valid_i,
   input logic [3:0]  round_i,
   input logic [2:0]  block_i,
   output logic       ena_reg_state_o,
   output logic       cipher_valid_o,
   output logic       end_o,
   output logic       init_state_o,
   output logic       ena_cpt_o,
   output logic	      ena_block_o,
   output logic       init_a_o,
   output logic       init_b_o,
   output logic	      init_block_o,
   output logic [1:0] conf_xor_down_o,
   output logic       ena_xor_up_o, 
   output logic       ena_xor_down_o
   );

   typedef enum       {idle, set_cpt, initial_state, init, init_a1, init_p, end_init, end_init_a1, end_init_p, xor_a1, xor_p, wait_a1, wait_p, t_end} fsm_state;

   fsm_state current_state_s, next_state_s;

   // Sequentiel : memorise l'état courant
   always @(posedge clock_i, negedge resetb_i) begin
      if (resetb_i == 1'b0) begin
	 current_state_s <= idle;
      end
      else begin
	 current_state_s <= next_state_s;
      end
   end

   // Combinatoire : transition d'état f (curren-_state, entree)
   always_comb begin
      case(current_state_s)
        idle: 
          if (start_i == 1'b1)
            next_state_s = set_cpt;
          else
            next_state_s = idle;
        set_cpt:
	  next_state_s = initial_state;
        initial_state:
          next_state_s = init;
	init:
	  if (round_i == 4'hA)
	    next_state_s = end_init;
          else
            next_state_s = init;
        end_init:
          if (data_valid_i == 1'b1)
            next_state_s = xor_a1;
          else begin
             next_state_s   = wait_a1;
	  end
        xor_a1:
          next_state_s = init_a1;
	wait_a1: 
	  if(data_valid_i == 1'b1)
	     next_state_s = xor_a1;
	  else
	     next_state_s = wait_a1;
	init_a1:
	  if (round_i == 4'hA)
	    next_state_s = end_init_a1;
          else
            next_state_s = init_a1;
	end_init_a1:
          if (data_valid_i == 1'b1)
            next_state_s = xor_p;
          else begin
             next_state_s   = wait_p;
	  end
	xor_p:	
	    next_state_s = init_p;
	init_p:
	  if (round_i == 4'hA)
	    next_state_s = end_init_p;
          else
            next_state_s = init_p;
	end_init_p:
	  if (data_valid_i == 1'b1 && block_i == 3'h4) //Compteur de block_i = 4 indique fin de la phase "Texte clair" et passage à "finalisation"
	    next_state_s = t_end;
          else if (data_valid_i == 1'b1)
	    next_state_s = xor_p;
          else begin
	    next_state_s = wait_p;
	    end	
	wait_p: 
	  if (data_valid_i == 1'b1 && block_i ==3'h4)
	     next_state_s = t_end;
	  else if (data_valid_i == 1'b1)
	     next_state_s = xor_p;
	  else
	     next_state_s = wait_p;
	t_end:begin
	end
      endcase
   end

   // Combinatoire des sorties
   always_comb begin
      cipher_valid_o  = 1'b0;
      end_o           = 1'b0;
      init_state_o    = 1'b0;
      ena_cpt_o       = 1'b0;
      init_a_o        = 1'b0;
      init_b_o        = 1'b0;
      init_block_o    = 1'b0;
      ena_block_o     = 1'b0;
      ena_xor_up_o    = 1'b0;
      ena_xor_down_o  = 1'b0;
      conf_xor_down_o = 2'b00;
      ena_reg_state_o = 1'b0;

      case(current_state_s)
        idle : begin
           // NOP
	end
        set_cpt: begin
           init_a_o = 1'b1;
	   init_block_o = 1'b1;
	   ena_cpt_o = 1'b1;
	end
        initial_state: begin
	   init_state_o = 1'b1;
           ena_cpt_o     = 1'b1;
           ena_reg_state_o = 1'b1;
	end
        init, init_a1, init_p: begin
	   ena_cpt_o = 1'b1;
	   ena_reg_state_o = 1'b1;
	end
	end_init: begin
	   ena_xor_down_o = 1'b1;
	   init_b_o       = 1'b1;
	   ena_cpt_o       = 1'b1;
	   ena_reg_state_o = 1'b1;
	   conf_xor_down_o = 2'b00;
	end
	xor_a1: begin	 
	   ena_cpt_o     = 1'b1;
	   ena_xor_up_o = 1'b1;
	   ena_reg_state_o = 1'b1;
	end
	xor_p: begin
	   ena_cpt_o     = 1'b1;
	   ena_xor_up_o = 1'b1;
	   ena_reg_state_o = 1'b1;
	   cipher_valid_o = 1'b1;
	   if (block_i < 3'h3)	    //Début du dernier bloc de 6 permutation avant la phase finale
		ena_block_o  = 1'b1;
	end
	wait_a1, wait_p: begin
	   //NOP	
	end
	end_init_a1: begin
	   ena_xor_down_o = 1'b1;
	   init_b_o       = 1'b1;
	   ena_cpt_o       = 1'b1;
	   ena_reg_state_o = 1'b1;
	   conf_xor_down_o = 2'b01;
	   init_block_o = 1'b0;
	end	
	end_init_p: begin
	   ena_cpt_o       = 1'b1;
	   ena_reg_state_o = 1'b1;
	   if (block_i == 3'h3) begin //Fin du dernier bloc de 6 permutations avant la phase finale
		ena_xor_down_o = 1'b1;
	   	conf_xor_down_o = 2'b10;
		init_a_o = 1'b1;     //On prépare le début du bloc de 12 permutations de la phase finale
		ena_block_o = 1'b1;
	   end
	   else if (block_i == 3'h4) begin // Fin du bloc de 12 permutations dans la phase finale
		ena_xor_down_o = 1'b1;
	   	conf_xor_down_o = 2'b11;
	   	end
	   else
		init_b_o = 1'b1; //Tant qu'on est dans la partie Texte Clair, on effectue 6 permutations
	end
	t_end: begin
	   end_o = 1'b1;
	end
      endcase
   end 


   
endmodule : fsm_moore
