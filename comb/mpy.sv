//-----------------------------------------------------------------------------
// Module Name   : mpy
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Multiplier
// Will synthesize to hardwired multiplier on an FPGA
//-----------------------------------------------------------------------------

module mpy #(parameter W=10) (input logic [W-1:0] a, b,
			     output logic [2*W-1:0] y);

   assign y = a * b;

endmodule: mpy
