//-----------------------------------------------------------------------------
// Module Name   : dffr
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d flip-flop with synchronous reset
//-----------------------------------------------------------------------------

module dffr (input logic clk, d, rst
             output logic q);

    always_ff @(posedge clk) begin
        if (rst) q <= 0;
        else     q <= d;
    end

endmodule
