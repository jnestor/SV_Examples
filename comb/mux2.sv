//-----------------------------------------------------------------------------
// Module Name   : mux2
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2022
//-----------------------------------------------------------------------------
// Description   : 2-1 mux parameterized by bitwidth W
//-----------------------------------------------------------------------------

module mux2 #(parameter W=32)
             (input logic [W-1:0]  d0, d1,
              input logic          sel,
              output logic [W-1:0] y );

   always_comb
     if (sel) y = d1;
     else y = d0;

endmodule: mux2
