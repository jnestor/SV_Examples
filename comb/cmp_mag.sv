//-----------------------------------------------------------------------------
// Module Name   : cmp_mag
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Straightforward unsigned magnitude comparator
//-----------------------------------------------------------------------------

module cmp_mag #(parameter W=8)
  (input logic [W-1:0] a, b,
   output logic a_gt_b);

  assign a_gt_b = (a > b);

endmodule: cmp_mag
