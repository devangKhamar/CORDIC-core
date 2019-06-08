/*
 Author: Devang Khamar
 tb.sv:
 This file contains the test-bench for the Cordic-core block.
 */

module tb;
   
   logic clk;
   cordic_if interf(clk);

   initial begin
      clk = 0;
      forever begin
	 #10 clk = ~clk;
      end
   end      
      
   driver tb_driver(interf);
   cordic duv(interf);

   always@(negedge clk) 
     begin
	assert property(tb.duv.shift_x === (tb.duv.x_buf >>> tb.duv.ctr_reg));
	assert property(tb.duv.shift_y === (tb.duv.y_buf >>> tb.duv.ctr_reg));
     end
endmodule
