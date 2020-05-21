// counter - basic binary counter

module counter(input logic clk, rst, enb,
               output logic [3:0] q);

    always_ff @(posedge clk) begin
        if (rst) begin
          q <= 4'd0;
        end
        else if (enb) begin
          q <= q + 1;
        end
    end
endmodule: counter
