//-----------------------------------------------------------------------------
// Module Name   : mpy_10
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Multiply a by constant (10) by shifting & adding
//                 (for signed two's complement numbers)
//-----------------------------------------------------------------------------

module mpy_10_s #(parameter W=8) (
	input logic signed [W-1:0] a,
	output logic signed [W+4-1:0] y
	)
	;
   logic [W+3-1:0] ax8;
   logic [W+1-1:0] ax2;
   logic sign;
   logic [W+3-1:0] ax2x;  // extended to match bitwith of ax8

   assign sign = a[W-1];

   assign ax8 = a << 3;
   assign ax2 = a << 1;
   assign ax2x = {{2{sign}},ax2}; // sign extend
   assign y = ax8 + ax2x;

endmodule: mpy_10_s
