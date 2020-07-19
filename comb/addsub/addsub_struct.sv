//-----------------------------------------------------------------------------
// Module Name   : adder
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Adder/Subtracter with explicitly shared adder
//-----------------------------------------------------------------------------

module addsub_struct #(parameter W=32)
   (input logic [W-1:0] a, b,
    input logic subsel,
    output logic [W-1:0] y);

    logic [W-1:0] bx;

    assign bx = (subsel) ? ~b : b;

    assign y = a + bx + subsel;

endmodule: addsub_struct
