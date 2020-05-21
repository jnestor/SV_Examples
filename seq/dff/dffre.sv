// dffre - d flip-flop with synchronous reset & enable

module #dffre (input logic clk, d, enb
               output logic q);

    always_ff @(posedge clk)
        if (rst) begin
            q <= 0;
        end
        else if (enb) begin
            q <= d;
        end

endmodule: dffre
