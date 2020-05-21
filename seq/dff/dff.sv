// dff - basic d flip-flop

module dff (input logic clk, d,
            output logic q);

    always_ff @(posedge clk) begin
          q <= d;
    end

endmodule: dff
