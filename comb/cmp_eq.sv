//-----------------------------------------------------------------------------
// Module Name   : cmp_eq
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Straightforward equality comparator
//-----------------------------------------------------------------------------

module cmp_eq #(parameter W=8)
   (input logic [W-1:0] a, b,
    output logic a_eq_b);

   assign a_eq_b (a == b);

endmodule: cmp_eq
