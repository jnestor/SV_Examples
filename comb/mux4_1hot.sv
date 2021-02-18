//-----------------------------------------------------------------------------
// Module Name   : mux4_1hot
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 4-1 mux parameterized by bitwidthw W
//-----------------------------------------------------------------------------

module mux4_1hot #(parameter W=32)
             (input logic [W-1:0]  d0, d1, d2, d3,
              input logic [3:0]    sel,
              output logic [W-1:0] y );

   always_comb
     unique case (sel)
       4'd1000 : y = d0;
       4'd0100 : y = d1;
       4'd0010 : y = d2;
       2'd0001 : y = d3;
       default : y = 0;
     endcase

endmodule: mux4_1hot
