//-----------------------------------------------------------------------------
// Module Name   : dffa
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d flip-flop with asynchronous reset
//-----------------------------------------------------------------------------

module dffa (input logic clk, d, rst
             output logic q);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) q <= 0;
        else     q <= d;

endmodule: dffra
