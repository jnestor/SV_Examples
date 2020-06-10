// counter - basic binary counter

module counter(input logic clk, rst, enb,
               output logic [3:0] q);

    always_ff @(posedge clk)
        if (rst)      q <= '0;
        else if (enb) q <= q + 1;

endmodule: counter
