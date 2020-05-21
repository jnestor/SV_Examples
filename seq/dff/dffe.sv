// dffe - d flip-flop with enable

module dffe (input logic clk, d, enb
             output logic q);

    always_ff @(posedge clk) begin
        if (enb) q <= d;
    end

endmodule: dffe
