//-----------------------------------------------------------------------------
// Module Name   : sh_reg4
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 4-bit shift register with parallel load
//-----------------------------------------------------------------------------

module sh_reg4 (input logic clk, rst, shen
                lden, s_in,
                input logic [3:0]  d,
                output logic [3:0] q);

  always_ff @(posedge clk)
    if (rst) q <= 4'd0;
    else if (lden) q <= d;
    else if (shen) q <= { s_in, q[3:1] };

endmodule: sh_reg4
