//
// example to illustrate race condition in sequential circui
//

module stim_example;

    logic clk, d1, q1, d2, q2, d3, q3;

    parameter CLKPD = 10;

    clk_gen #(.CLKPD(CLKPD)) CG (.clk);

    dff DUV1 (.clk, .d(d1), .q(q1));
    dff DUV2 (.clk, .d(d2), .q(q2));
    dff DUV3 (.clk, .d(d3), .q(q3));

    initial begin
        d1 <= 0;
        @(posedge clk) #1;
        d1 <= 1;
        @(posedge clk) #1;
        d1 <= 0;
        @(posedge clk) #1;
    end

    initial begin
        d2 <= 0;
        @(posedge clk);
        d2 <= 1;
        @(posedge clk);
        d2 <= 0;
        @(posedge clk);
    end

    initial begin
        d3 = 0;
        @(posedge clk);
        d3 = 1;
        @(posedge clk);
        d3 = 0;
        @(posedge clk);
        $stop;
    end

endmodule: stim_example