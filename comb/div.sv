module mpy_seq #(parameter W=4) ( input logic [W-1:0] 	a, b,
				 output logic [W-1:0] q, r);

   always @(posedge clk)
     begin
	q = a / b;
	r = a % b;
     end

endmodule // mpy
