//-----------------------------------------------------------------------------
// Module Name   : wf_pkt_top - top-level module for WimpFi testbench
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : May 5 2021
//-----------------------------------------------------------------------------
// Description   : Constrained random stimulus for WimpFi packets
//-----------------------------------------------------------------------------

module wf_pkt_top;

    timeunit 1ns / 100ps;

    parameter CLKPD_NS = 10;
    parameter BIT_RATE = 50_000;
    localparam BITPD_NS = 1_000_000_000 / BIT_RATE;  // bit period in ns

    logic clk, rst, txd;
    logic [7:0] mac, rdata;
    logic rvalid, cardet;
    logic rrdy;
    logic [7:0] rerrcnt;

    clk_gen #(.CLKPD(CLKPD_NS)) CG (.clk);

    wf_pkt_tb  #(.CLKPD_NS(CLKPD_NS),.BIT_RATE(BIT_RATE)) BENCH (
        .clk, .rst, .txd, .cardet, .rdata, .rvalid, .rerrcnt
    );

    // add your WimpFi receiver here
   // wf_rcvr #(.BIT_RATE(BIT_RATE)) DUV (
   //      .clk, .rst, .rxd, ,rdata, .rvalid, .cardet, .rrdy, .rerrcnt
   //  );

endmodule: wf_pkt_top
