module dffr (input logic clk, d, rst
             output logic q);

    always_ff @(posedge clk) begin
        if (rst) q <= 0;
        else q <= d;
    end

endmodule
