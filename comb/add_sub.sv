//-----------------------------------------------------------------------------
// Module Name   : add_sub - combined adder/subtracter
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : adder/subtracter - adds when selsub=0,
//                 subtracts when selsub=1
//-----------------------------------------------------------------------------

module add_sub #(parameter W=8) (
    input                selsub,
    input logic [W-1:0]  a, b, 
    output logic [W-1:0] y
    );

    logic [W-1:0] bx;

    assign bx = selsub ? ~b : b;

    assign y = a + bx + selsub;

endmodule: add_sub
