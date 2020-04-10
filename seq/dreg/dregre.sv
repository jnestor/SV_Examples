// dregre - d register with synchronous reset and enable

module dregre (#parameter W=4)
  (input logic clk, rst, enb
   input logic [W-1:0] 	d,
   output logic [W-1:0] q);

   always_ff @(posedge clk)
     if (rst) q <= '0;
     if (enb) q <= d;

endmodule
