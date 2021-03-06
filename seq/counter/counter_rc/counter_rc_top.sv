//
// Top-level file for simulating counter_rc
//

module counter_rc_top;

    logic clk, rst, enb;
    logic [3:0] q;
    logic       cy;


    parameter CLKPD = 10;

    clk_gen #(.CLKPD(CLKPD)) CG (.clk);

    counter_rc DUV (.clk, .rst, .enb, .q, .cy);

    counter_rc_tb #(.CLKPD(CLKPD)) TB (.clk, .rst, .enb, .q, .cy);

endmodule: counter_rc_top
