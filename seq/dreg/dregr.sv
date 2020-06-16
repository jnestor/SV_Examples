//-----------------------------------------------------------------------------
// Module Name   : dregr
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d register
//-----------------------------------------------------------------------------

module dregr (#parameter W=4)
             (input logic clk, rst,
              input logic [W-1:0] d,
              output logic [W-1:0] q);

    always_ff @(posedge clk)
        if (rst) q <= '0;
        else q <= d;

endmodule: dregr
