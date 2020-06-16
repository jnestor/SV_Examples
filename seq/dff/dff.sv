//-----------------------------------------------------------------------------
// Module Name   : dff
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d flip-flop
//-----------------------------------------------------------------------------

module dff (input logic clk, d,
            output logic q);

    always_ff @(posedge clk)
        q <= d;

endmodule: dff
