//-----------------------------------------------------------------------------
// Module Name   : mpy_10
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Multiply a by constant (10) by shifting & adding
//-----------------------------------------------------------------------------

module mpy_10 #(parameter W=8) (input logic [W-1:0] a,
			       output logic [W-1:0] y);
   assign y = (a << 3) + (a << 1);

endmodule: mpy_10
