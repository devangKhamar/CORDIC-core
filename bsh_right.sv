module bsh_right  
  ( input logic [15:0] din,
    input logic [3:0] 	shift,
    output logic [15:0] dout
    );

   logic [15:0] 	layers[2:0];
   
   
   always_comb
     begin
	//Shift 1
	layers[0] = shift[0] ? {din[15], din[15:1]} : din;
	//Shift 2
	layers[1] = shift[1] ? {{2{layers[0][15]}}, layers[0][15:2]} : layers[0];
	//Shift 4
	layers[2] = shift[2] ? {{4{layers[1][15]}}, layers[1][15:4]} : layers[1];
	//Shift 8
	dout = shift[3] ? {{8{layers[2][15]}}, layers[2][15:8]} : layers[2];
     end // always_comb
endmodule
