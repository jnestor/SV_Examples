//-----------------------------------------------------------------------------
// Module Name   : clock_example_tb
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jan 2022
//-----------------------------------------------------------------------------
// Description   : Stimulus-only testbench for simploe clock example
//-----------------------------------------------------------------------------

module clock_example_tb;

    logic clk, rst, adv_min, adv_hr;
    logic [3:0] h1, h0, m1, m0, s1, s0;
    logic pm;

    localparam CLK_PD = 10;

    always begin
        clk = 0; #(CLK_PD/2);
        clk = 1; #(CLK_PD/2);
    end

    clock_example DUV (.clk, .rst, .adv_min, .adv_hr, .h1, .h0, .m1, .m0, .s1, .s0, .pm);

    initial begin
        rst = 1;
        adv_min = 0;
        adv_hr = 0;
        #(CLK_PD + 1);
        rst = 0;
        adv_min = 1;
        #(CLK_PD*40);
        adv_min = 0;
        adv_hr = 1;
        #(CLK_PD*5);
        adv_hr = 0;
        $stop;
        #(CLK_PD*2400);
        $stop;
    end
    
endmodule
