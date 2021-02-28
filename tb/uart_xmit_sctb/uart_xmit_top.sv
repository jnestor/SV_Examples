//-----------------------------------------------------------------------------
// Module Name   : template_top
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Template for top-level simulation file
//-----------------------------------------------------------------------------

module uart_xmit_top;

    timeunit 1ns / 100ps;  // define timing for this module and all submodules

    parameter CLKPD = 10;  // clock period in nanoseconds
    parameter BAUD_RATE = 9600;
    
    logic clk, rst, valid, txd, rdy;
    
    logic [7:0] data;

    clk_gen #(.CLKPD(CLKPD)) CG (.clk);

    uart_xmit #(.BAUD_RATE(BAUD_RATE)) DUV (.clk, .rst, .valid, .data, .txd, .rdy);

    uart_xmit_sctb #(.BAUD_RATE(BAUD_RATE)) TB (.clk, .rst, .valid, .data, .txd, .rdy);

endmodule: uart_xmit_top
