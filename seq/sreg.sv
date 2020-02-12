module shreg (input logic clk, rst, enb, s_in,
              output logic [3:0] q,
              output logic 	 s_out);
   
   always_ff @(posedge clk)
     if (rst) q <= 0;
     else if (enb) q <= { s_in, q[3:1] };
   
   assign s_out = q[0];
   
endmodule
