//-----------------------------------------------------------------------------
// Module Name   : shift_ra
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Arithmetic right shifter
//-----------------------------------------------------------------------------

module shifter_ra #(parameter W=32, localparam SW=$clog2(W)) (
    input logic signed [W-1:0]  a,
    input logic signed [SW-1:0] shamt,
    output logic signed [W-1:0] y
    );

   assign y = a >>> shamt;

endmodule: shifter_ra
