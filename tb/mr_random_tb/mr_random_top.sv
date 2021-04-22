//-----------------------------------------------------------------------------
// Module Name   : mx_rcvr_top - top-level module for correlator demo
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : March 1 2021
//-----------------------------------------------------------------------------
// Description   : Example code to generate stimulus, noise, and
//                 noisy stimulus while demonstrating different
//                 correlator configurtions
//-----------------------------------------------------------------------------

module mr_random_top;

    timeunit 1ns / 100ps;

    parameter CLKPD_NS = 10;
    parameter BIT_RATE = 50_000;
    localparam BITPD_NS = 1_000_000_000 / BIT_RATE;  // bit period in ns

    logic clk, rst, rxd;
    logic [7:0] data;
    logic cardet, valid, error;

    clk_gen #(.CLKPD(CLKPD_NS)) CG (.clk);

    mr_random_tb  #(.CLKPD_NS(CLKPD_NS),.BIT_RATE(BIT_RATE)) BENCH (
        .clk, .rst, .txd(rxd), .cardet, .data, .valid, .error
    );

   mx_rcvr #(.BIT_RATE(BIT_RATE)) DUV (
        .clk, .rst, .rxd, .cardet, .data, .valid, .error
    );

endmodule: mr_random_top
