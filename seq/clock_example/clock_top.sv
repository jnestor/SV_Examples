//-----------------------------------------------------------------------------
// Module Name   : clock_top
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jan 2022
//-----------------------------------------------------------------------------
// Description   : Top-level file for digital clock implemented on a Nexys A7
// FPGA board
//-----------------------------------------------------------------------------

module clock_top (
    input logic clk, rst, adv_min, adv_hr,
    output logic [7:0] an_n,
    output logic [6:0] segs_n,
    output logic dp_n,
    output logic pm
    );

    logic [3:0] h1, h0, m1, m0, s1, s0;

    logic [6:0]  d7, d6, d5, d4, d3, d2, d1, d0;

    assign d7 = 7'b1000000;      // blank d7 - unused
    assign d6 = 7'b1000000;      // blank d7 - unused
    assign d5 = { (h1==4'd0), 2'b000, h1 };  // blank when zero
    assign d4 = { 3'b010, h0 };  // display dp after hours
    assign d3 = { 3'b000, m1 };
    assign d2 = { 3'b010, m0 };  // display dp after minutes
    assign d1 = { 3'b000, s1 };
    assign d0 = { 3'b000, s0 };

    clock_example U_CLK (
        .clk, .rst, .adv_min, .adv_hr, .h1, .h0, .m1, .m0, .s1, .s0, .pm
    );

    sevenseg_ctl U_SSEG (
        .clk, .rst, .d7, .d6, .d5, .d4, .d3, .d2, .d1, .d0, .an_n, .dp_n, .segs_n
    );

endmodule
