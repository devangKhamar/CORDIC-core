/*
 Defines intefaces for the cordic core
 */

interface cordic_if(input clk);
   logic signed [15:0] Az;
   logic 	load;
   logic 	rst;
   logic signed [15:0] Ax;
   logic signed [15:0] Ay;

   modport CORE(input Az, input  rst, input clk, input load,
		output Ax, output Ay);
   modport TEST(output Az,output rst, input clk, output load,
		input  Ax, input  Ay);
   modport MONTIOR(output Az, output rst, input clk, output load,
		   output Ax, output Ay);
endinterface // cordic_if
