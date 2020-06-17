//-----------------------------------------------------------------------------
// Module Name   : lfsr
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 4-bit linear feedback shift register
//-----------------------------------------------------------------------------

module lfsr(
   input logic        rst, clk,
   output logic [3:0] q
);

   always_ff @(posedge clk)
       if (rst) q <= 4'b0001;
       else q <= { (q[1] ^ q[0]), q[3:1] };

endmodule: lfsr
