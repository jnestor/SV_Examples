//-----------------------------------------------------------------------------
// Module Name   : counter_rc_mod
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jan 2022
//-----------------------------------------------------------------------------
// Description   : 4-bit counter with ripple carry and parameterized modulus
//-----------------------------------------------------------------------------

module counter_rc_mod (
    input logic clk, rst, enb,
    output logic [3:0] q,
    output logic cy
    );

    parameter MOD = 4'd10;

    assign cy = (q == MOD-1) && enb;

    always_ff @(posedge clk) begin
        if (rst || cy) q <= 0;
        else if (enb) q <= q + 1;
    end

endmodule
