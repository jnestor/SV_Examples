//-----------------------------------------------------------------------------
// Module Name   : mpy_9
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Multiply a by constant (9) by shifting & adding
//-----------------------------------------------------------------------------

module mpy_9 #(parameter W=8) (input logic [W-1:0] a,
			       output logic [W-1:0] y);
   assign y = (a << 3) + a;

endmodule: mpy_9
