//-----------------------------------------------------------------------------
// Module Name   : shift_r
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Straightforward subtracter parameterized by bitwidth
//-----------------------------------------------------------------------------

module shifter_rl #(parameter W=32, localparam SW=$clog2(W)) (
    input logic [W-1:0]  a,
    input logic [SW-1:0] shamt,
    output logic [W-1:0] y
    );

   assign y = a >> shamt;

endmodule: shifter_rl
