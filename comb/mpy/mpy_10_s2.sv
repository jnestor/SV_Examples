//-----------------------------------------------------------------------------
// Module Name   : mpy_10
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Multiply a by constant (10) by shifting & adding
//                 (for unsigned numbers)
//-----------------------------------------------------------------------------

module mpy_10_s #(parameter W=8) (
	input logic signed [W-1:0] a,
	output logic signed [W+4-1:0] y
	);

   assign y = (a << 3) + (a << 1);
   // do simulation and synthesis do sign extension properly?

endmodule: mpy_10_s
