module counter_rc (input logic clk, rst, enb,
                   output logic [3:0] q,
                   output logic cy);

    assign cy = (q == 4'b1111) && enb;

    always_ff @(posedge clk) begin
        if (rst) q <= 0;
        else if (enb) q <= q + 1;
    end

endmodule
