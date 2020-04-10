// dreg - d register parameterized by width W

module dreg (#parameter W=4)
  (input logic clk,
   input logic [W-1:0] 	d,
   output logic [W-1:0] q);

  always_ff @(posedge clk)
    q <= d;

endmodule
