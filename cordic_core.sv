/*
 Author: Devang Khamar
 cordic_core.sv:
 This file contains the implementation of the Cordic core block.
 This block can be then wrapped around logic to run iteratively,
 or pipelined.
 */

module cordic(cordic_if.CORE c);
   
   logic signed [15:0] x_buf, y_buf, z_buf;
   logic signed [14:0] curr_angle;
   logic signed [15:0] x, y, z;
   logic [3:0] 	ctr, ctr_reg;
   logic       sign, enable;
   logic [1:0] pstate, nstate; 
   
   localparam IDLE = 1'b0, COMPUTE = 1'b1;
   

   assign c.Ax = pstate == IDLE ? x_buf : 16'h0;
   assign c.Ay = pstate == IDLE ? y_buf : 16'h0;
   
   always_ff@(posedge c.clk)
     begin
	if(c.rst)
	  begin
	     x_buf <= 16'sh0;
	     y_buf <= 16'sh0;
	     z_buf <= 16'sh0;	   
	     pstate <= IDLE;
	     enable <= 1'b0;
	     ctr_reg <= 4'h0;	   
	  end
	else
	  begin
	     x_buf <= x;
	     y_buf <= y;
	     z_buf <= (c.load & (pstate == IDLE)) ? c.Az : z;
	     enable <= (pstate == IDLE) ? c.load : enable;
	     pstate <= nstate;
	     ctr_reg <= ctr;
	  end
     end // always@ (posedge clk)
  
   logic signed [15:0] shift_x, shift_y;   
   //signed-bit is MSB. Need to check only this to see if value is negative	

   lut cordic_consts(.addr(ctr_reg), .val(curr_angle));
   bsh_right xShift(.din(x_buf), .shift(ctr_reg), .dout(shift_x));
   bsh_right yShift(.din(y_buf), .shift(ctr_reg), .dout(shift_y));

   assign sign = z_buf[15];
   //X-buf section 
   always_comb
     begin
	x = x_buf;
	y = y_buf;
	case(pstate)
	  IDLE:
	    begin	     
	       x = enable ? 16'sh26DD : x_buf;
	       y = enable ? 16'sh0000 : y_buf;	       
	    end
	  COMPUTE:
	    begin
	       x = sign ? x_buf + shift_y : x_buf - shift_y ;
	       y = sign ? y_buf - shift_x : y_buf + shift_x ;	     
	    end	    
	endcase
     end // always_comb


//z-buf section
   always_comb
     begin
	nstate = pstate;
	z = z_buf;
	ctr = ctr_reg;
	case(pstate)
	  IDLE:
	    begin	     
	       nstate = enable ? COMPUTE : IDLE;
	       ctr = 4'h0;	       
	    end
	  COMPUTE:
	    begin
	       z = sign ? z_buf + {2'b0, curr_angle} : z_buf - {2'b0, curr_angle};
	       nstate = (ctr_reg != 4'hB) ? COMPUTE : IDLE;
	       ctr = ctr_reg + 4'h1;
	    end
	  default:
	    begin nstate = IDLE; end
	endcase
     end
endmodule
