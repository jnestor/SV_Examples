//-----------------------------------------------------------------------------
// Module Name   : sh_reg
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Shift register with parallel load parameterized by bitwidth
//-----------------------------------------------------------------------------

module sh_reg #(parameter W=8)
                (input logic clk, rst, shen, lden, s_in,
                 input logic [W-1:0]  d,
                 output logic [W-1:0] q);

  always_ff @(posedge clk)
    if (rst) q <= '0;
    else if (lden) q <= d;
    else if (shen) q <= { s_in, q[W-1:1] };

endmodule: sh_reg
