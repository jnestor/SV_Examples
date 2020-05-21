// timer - count down to a deadline

module timer(input logic clk, rst, start,
             output logic done);

    parameter DEADLINE = 100;
    localparam DW = $clog2(DELAY);

    logic [W-1:0] q;

    assign done = (q == '0);

    always_ff @(posedge clk) begin
        if (rst) begin
            q <= '0;
        end
        else if (start) begin
            q <= DEADLINE - 1;
        end
        else if (!done) begin
            q <= q - 1;
        end
    end

endmodule: timer
