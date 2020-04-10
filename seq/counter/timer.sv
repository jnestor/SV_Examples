// timer - count down to a deadline

module timer(input logic clk, rst, start,
               output logic done);

 logic [4:0] q;

 assign done (q == 0);

 always_ff @(posedge clk)
    if (rst) q <= 0;
    else if (start) q <= 4'd10;
    else if (!done) q <= q - 1;
endmodule
