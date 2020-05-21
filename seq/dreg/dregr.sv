// dregr - d register with synchronous reset

module dregr (#parameter W=4)
             (input logic clk, rst,
              input logic [W-1:0] d,
              output logic [W-1:0] q);

    always_ff @(posedge clk) begin
        if (rst) begin
             q <= '0;
        end
        else begin
             q <= d;
        end
    end

endmodule: dregr
