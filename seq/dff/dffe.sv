// dffe - d flip-flop with enable

module dffe (input logic clk, d, enb
             output logic q);

    always_ff @(posedge clk)
        if (enb) q <= d;

endmodule: dffe
