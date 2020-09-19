module add3 (input logic [3:0] a,
	     output logic [3:0] y);

  assign y = (a<4'd5) ? a : a+4'd3;
   
endmodule // add3

