//-----------------------------------------------------------------------------
// Module Name   : adder
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Straightforward adder parameterized by bitwidth
//-----------------------------------------------------------------------------

module adder #(parameter W=8)
   (input logic [W-1:0] a, b,
    output logic [W-1:0] y);

   assign y = a + b;

endmodule: adder
