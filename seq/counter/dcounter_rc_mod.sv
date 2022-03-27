//-----------------------------------------------------------------------------
// Module Name   : dcounter_rc_mod
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Mar 2022
//-----------------------------------------------------------------------------
// Description   : 4-bit down counter with ripple carry and parameterized modulus
//-----------------------------------------------------------------------------

module dcounter_rc_mod (
    input logic clk, rst, enb,
    output logic [3:0] q,
    output logic bw
    );

    parameter MOD = 4'd10;

    assign cy = (q == 0) && enb;

    always_ff @(posedge clk) begin
        if (rst || cy) q <= MOD-1;
        else if (enb) q <= q - 1;
    end

endmodule
