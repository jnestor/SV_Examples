//-----------------------------------------------------------------------------
// Module Name   : adder
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Adder/Subtracter functional description
//-----------------------------------------------------------------------------

module addsub_funct #(parameter W=8)
   (input logic [W-1:0] a, b,
    input logic sub,
    output logic [W-1:0] y);

   assign y = (sub) ? a - b : a + b;

endmodule: adder
