//
// example to illustrate race condition in sequential circui
//

module race_tb;

    logic clk, d1, q1, d2, q2, d3, q3;

    parameter CLKPD = 10;

    clk_gen #(.CLKPD(CLKPD)) CG (.clk);

    dff DUV1 (.clk, .d(d1), .q(q1));
    dff DUV2 (.clk, .d(d2), .q(q2));
    dff DUV3 (.clk, .d(d3), .q(q3));

    initial begin
        d1 = 0;
        d2 <= 0;
        #1 d3 = 0;
        @(posedge clk);
        d1 = 1;
        d2 <= 1;
        #1 d3 = 1;
        @(posedge clk);
        d1 = 0;
        d2 <= 0;
        #1 d3 = 0;
        @(posedge clk);
        $stop;
    end
    
endmodule: race_tb
