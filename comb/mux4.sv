//-----------------------------------------------------------------------------
// Module Name   : mux4
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 4-1 mux parameterized by bitwidthw W
//-----------------------------------------------------------------------------

module mux4 #(parameter W=32)
             (input logic [W-1:0]  d0, d1, d2, d3,
              input logic [1:0]    sel,
              output logic [W-1:0] y );

   always_comb
     case (sel)
       2'd0 : y = d0;
       2'd1 : y = d1;
       2'd2 : y = d2;
       2'd3 : y = d3;
       default : y = 0;
     endcase

endmodule: mux4
