//-----------------------------------------------------------------------------
// Module Name   : tffr - toggle flip flop with reset
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : toggle flip-flop
//-----------------------------------------------------------------------------

module tffr (
    input logic clk, rst, t,
    output logic q
    );

    always_ff @(posedge clk)
        if (rst) q <= 0;
        else if (t) q <= !q;

endmodule: tffr
