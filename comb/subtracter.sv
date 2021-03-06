//-----------------------------------------------------------------------------
// Module Name   : subtracter
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Straightforward subtracter parameterized by bitwidth
//-----------------------------------------------------------------------------

module subtracter #(parameter W=8)
   (input logic [W-1:0] a, b,
    output logic [W-1:0] y);

   assign y = a - b;

endmodule: subtracter
