module mpy_9 #(parameter W=8) (input logic [W-1:0] a,
			       output logic [W-1:0] y);
   assign y = (a << 3) + a;

endmodule // mpy_9
