/*
 Author: Devang Khamar
 driver.sv:
 This file contains the test-bench driver for the Cordic-core block.
 */


module driver(cordic_if.TEST t);

   task reset_t;
     begin
      t.rst = 1'b0;
      @(posedge t.clk)
	t.rst = 1'b1;
      @(posedge t.clk)
	t.rst = 1'b0;
     end
   endtask

   task driver;
     input [15:0] val;
      begin
	 t.load = 1'b0;
	 @(posedge t.clk)
	   fork 
	      t.Az = val;
	      t.load = 1'b1;
	   join
	 @(posedge t.clk)
	      t.load = 1'b0;
	 for(int i = 0; i < 16 ; i = i + 1) 
	   begin
	      @(posedge t.clk);
	   end
      end
   endtask
   
   

   task generator;      
      real cos_val, sine_val, rads;
      int passed;
      int cos_ref, sine_ref, theta_val;
      real error_val, error_mag;
      
      rads = (3.141529/2);
      
      begin
	 passed = 32'd32768;
	 error_val = 0;	 
	 for(int i = 0 ; i < 16384; i = i + 1) 
	   begin	      
	      cos_val = $cos($itor((rads*i)/16384));
	      sine_val = $sin($itor((rads*i)/16384));
	      cos_ref = $rtoi(cos_val*16384);
	      sine_ref = $rtoi(sine_val*16384);
	      theta_val = $rtoi(rads*i);	      
	      driver(theta_val[15:0]);
	      //assert (t.Ax == cos_ref[15:0]) else $error("Failed at: %d, ref: %d, calc: %d" ,i, cos_ref, t.Ax);
	      //assert (t.Ay == sine_ref[15:0]) else $error("Failed at: %d, ref: %d, calc: %d" ,i, sine_ref, t.Ay);
	      if(t.Ax != cos_ref[15:0]) 
		begin 
		   passed = passed-1;
		   error_mag = cos_ref - t.Ax;		   
		   error_val = error_val + (error_mag > 0 ? error_mag : -error_mag);
		end;	      
	      if(t.Ay != sine_ref[15:0])	      
		begin 
		   passed = passed-1;
		   error_mag = sine_ref - t.Ay;		   
		   error_val = error_val + (error_mag > 0 ? error_mag : -error_mag);
		end;		   
	   end // for (int i = 1 ; i < 16384; i = i << 1)
	 error_val = (100*error_val)/((32768-passed)*(16384));	 
	 $display("pass rate: %d/%d \n", passed, 32768);
	 $display("mean error value: %g %% \n", error_val);	 
      end
   endtask // for
   
   
   initial
     begin
	$display("### SIMULATION STARTING ###");
	reset_t();
	$display("### RESET COMPLETE ###");
	generator();
	$display("### SIMULATION COMPLETE ###");
	$finish;	
     end   
endmodule
