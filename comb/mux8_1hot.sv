//-----------------------------------------------------------------------------
// Module Name   : mux4_1hot
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 4-1 mux parameterized by bitwidthw W
//-----------------------------------------------------------------------------

module mux8_1hot #(parameter W=4) (
    input logic [W-1:0]  d0, d1, d2, d3, d4, d5, d6, d7,
    input logic [7:0]    sel,
    output logic [W-1:0] y 
    );

   always_comb
     unique case (sel)
       8'd00000001 : y = d0;
       8'd00000010 : y = d1;
       8'd00000100 : y = d2;
       8'd00001000 : y = d3;
       8'd00010000 : y = d4;
       8'd00100000 : y = d5;
       8'd01000000 : y = d6;
       8'd10000000 : y = d7;
       // default : y = 0;
     endcase

endmodule: mux8_1hot
