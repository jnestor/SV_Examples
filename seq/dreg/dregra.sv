// dregra - d register with asynchronous reset

module dregra (#parameter W=4)
  (input logic clk, rst,
   input logic [W-1:0] 	d,
   output logic [W-1:0] q);

   always_ff @(posedge clk or posedge rst)
     if (rst) q <= '0;
     else q <= d;

endmodule
