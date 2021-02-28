//-----------------------------------------------------------------------------
// Module Name   : template_top
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Template for top-level simulation file
//-----------------------------------------------------------------------------

module template_top;

    timeunit 1ns / 100ps;

    logic clk, rst;
    // add signals to connect testbench to DUV

    parameter CLKPD = 10;

    clk_gen #(.CLKPD(CLKPD)) CG (.clk);

    template_duv DUV (.clk, .rst /* add connections */ );

    template_tb #(.CLKPD(CLKPD)) TB (.clk, .rst /* add connections */ );

endmodule: template_top
