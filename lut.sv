/*
 LUT for angle approximates. 
 14-bit fractional precision
 1-bit decimal precision.
 1-bit signed
 All angles coresspond to radian values.
 */
module lut( input [3:0] addr,
	    output logic signed [14:0] val);

   always_comb
     begin
	case(addr)
	  4'h0: begin val = 15'sh3243; end // pi/4
	  4'h1: begin val = 15'sh1DAC; end
	  4'h2: begin val = 15'sh0FAD; end
	  4'h3: begin val = 15'sh07F5; end
	  4'h4: begin val = 15'sh03FE; end
	  4'h5: begin val = 15'sh01FF; end
	  4'h6: begin val = 15'sh00FF; end
	  4'h7: begin val = 15'sh007F; end
	  4'h8: begin val = 15'sh003F; end
	  4'h9: begin val = 15'sh001F; end
	  4'hA: begin val = 15'sh000F; end
	  4'hB: begin val = 15'sh0007; end
	  4'hC: begin val = 15'sh0003; end
	  4'hD: begin val = 15'sh0001; end // pi/(2*8192)
	  4'hE: begin val = 15'sh0000; end
	  4'hF: begin val = 15'sh0000; end
	endcase // case (addr)
     end // always_comb
endmodule // lut

	     
	     
