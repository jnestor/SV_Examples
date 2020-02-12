module mpy #(parameter W=10) (input logic [W-1:0] a, b,
			     output logic [2*W-1:0] y);

   assign y = a * b;

endmodule // mpy
