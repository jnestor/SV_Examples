//-----------------------------------------------------------------------------
// Module Name   : correlator_demo_top - top-level module for correlator demo
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : March 1 2021
//-----------------------------------------------------------------------------
// Description   : Example code to generate stimulus, noise, and
//                 noisy stimulus while demonstrating different
//                 correlator configurtions
//-----------------------------------------------------------------------------

module correlator_demo_top;

    timeunit 1ns / 100ps;

    parameter CLKPD_NS = 10;
    parameter BIT_RATE = 50_000;
    localparam BITPD_NS = 1_000_000_000 / BIT_RATE;  // bit period in ns
    
    logic clk, rst, txd;

    clk_gen #(.CLKPD(CLKPD_NS)) CG (.clk);

    correlator_demo_bench  #(.CLKPD_NS(CLKPD_NS),.BIT_RATE(BIT_RATE)) BENCH (
        .clk, .rst, .txd(txd)
    );

   correlator_demo #(.CLKPD_NS(CLKPD_NS),.BIT_RATE(BIT_RATE)) DUV (
        .clk, .rst, .rxd(txd)
    );

endmodule: correlator_demo_top
