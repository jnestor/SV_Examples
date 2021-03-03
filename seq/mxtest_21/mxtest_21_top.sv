//-----------------------------------------------------------------------------
// Module Name   : mx21_top - top-level module for mxtest_21
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : March 1 2021
//-----------------------------------------------------------------------------
// Description   : Generates a burst of characters on the ready-valid
// interface of the UART transmitter when send is asserted
//-----------------------------------------------------------------------------

module mxtest_21_top(
    input logic clk, rst, btnu, btnd,
    input logic [5:0] sw,
    output txd, txen, rdy, rdy_led
    );

    logic send, d_pulse;

    assign rdy_led = rdy;

    single_pulser U_SP (.clk, .din(btnu), .d_pulse);

    assign send = d_pulse || btnd;

    parameter BIT_RATE=10000;

    logic valid;
    logic [7:0] data;

    mxtest_21 U_MXTEST (.clk, .rst, .send, .rdy, .frame_len(sw), .data, .valid);

    mx4 #(.BIT_RATE(BIT_RATE)) U_MX4 (
        .clk, .rst, .valid, .data, .rdy, .txen, .txd
        );

endmodule: mxtest_21_top
