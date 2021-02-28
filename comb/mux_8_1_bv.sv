//-----------------------------------------------------------------------------
// Module Name   : mux8_1_bv
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 8-1 mux with bit vector input using indexing
//-----------------------------------------------------------------------------

module mux8_1_bv (
    input logic [7:0] d,
    input logic [2:0] sel,
    output logic y
    );

    assign y = d[sel];

endmodule: mux8_1_bv
