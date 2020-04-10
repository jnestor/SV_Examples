// dffra - d flip-flop with asynchronous reset

module dffra (input logic clk, d, rst
             output logic q);

   always_ff @(posedge clk or posedge rst)
     if (rst) q <= 0;
     else q <= d;

endmodule
