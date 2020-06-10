// timer - count down to a deadline

module timer(input logic clk, rst, start,
             output logic done);

    parameter DEADLINE = 100;
    localparam DW = $clog2(DELAY);

    logic [W-1:0] q;

    assign done = (q == '0);

    always_ff @(posedge clk) begin
        if (rst)        q <= '0;
        else if (start) q <= DEADLINE - 1;
        else if (!done) q <= q - 1;
    end

endmodule: timer
