//-----------------------------------------------------------------------------
// Module Name   : fifo_xb_top
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Top-level simulation file for fifo_xb
//-----------------------------------------------------------------------------

module fifo_xb_top;
    parameter WIDTH = 8;
    parameter DEPTH = 4;

    logic clk, rst;
    logic enqueue, dequeue;
    logic [WIDTH-1:0] din;
    logic [WIDTH-1:0] dout;
    logic full, empty;

    parameter CLKPD = 10;

    clk_gen #(.CLKPD(CLKPD)) CG (.clk);

    fifo_xb  #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUV
                 (.clk, .rst, .enqueue, .dequeue,
                  .din, .dout, .full, .empty);

    fifo_xb_tb #(.CLKPD(CLKPD), .WIDTH(WIDTH), .DEPTH(DEPTH)) TB
                   (.clk, .rst, .enqueue, .dequeue,
                    .din, .dout, .full, .empty);;

endmodule: fifo_xb_top
