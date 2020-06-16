//-----------------------------------------------------------------------------
// Module Name   : dffe
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d flip-flop with enable
//-----------------------------------------------------------------------------

module dffe (input logic clk, d, enb
             output logic q);

    always_ff @(posedge clk)
        if (enb) q <= d;

endmodule: dffe
