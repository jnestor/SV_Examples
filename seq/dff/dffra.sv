// dffra - d flip-flop with asynchronous reset

module dffra (input logic clk, d, rst
             output logic q);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0;
        end
        else begin
            q <= d;
        end

endmodule: dffra
