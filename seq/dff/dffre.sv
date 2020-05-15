// dffre - d flip-flop with synchronous reset & enable

module #dffre (input logic clk, d, enb
             output logic q);

   always_ff @(posedge clk)
     if (rst) q = 0;
     else if (enb) q <= d;

endmodule
