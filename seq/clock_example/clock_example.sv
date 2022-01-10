//-----------------------------------------------------------------------------
// Module Name   : clock_example
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jan 2022
//-----------------------------------------------------------------------------
// Description   : Simple digital clock for an FPGA board.  This design is built
// structurally using a parameterized modular counter.
//-----------------------------------------------------------------------------

module clock_example (
    input logic clk, rst, adv_min, adv_hr,
    output logic [3:0] h1, h0, m1, m0, s1, s0,
    output logic pm
    );

    logic s0_enb, s0_cy, s1_cy, m0_cy, m0_enb, m1_cy, h0_enb, h0_cy, h1_cy;

    rate_enb #(.RATE_HZ(1)) U_ENB (.clk, .rst, .clr(1'b0), .enb_out(s0_enb));

    counter_rc_mod #(.MOD(10)) U_CTS0 (
        .clk, .rst, .enb(s0_enb), .q(s0), .cy(s0_cy)
    );

    counter_rc_mod #(.MOD(6)) U_CTS1 (
        .clk, .rst, .enb(s0_cy), .q(s1), .cy(s1_cy)
    );

    assign m0_enb = s1_cy || (adv_min && s0_enb);

    counter_rc_mod #(.MOD(10)) U_CTM0 (
        .clk, .rst, .enb(m0_enb), .q(m0), .cy(m0_cy)
    );

    counter_rc_mod #(.MOD(6)) U_CTM1 (
        .clk, .rst, .enb(m0_cy), .q(m1), .cy(m1_cy)
    );

    assign h0_enb = m1_cy || (adv_hr && s0_enb);

    counter_hrs U_CTH (
        .clk, .rst, .enb(h0_enb), .h1, .h0, .pm
    );


endmodule
