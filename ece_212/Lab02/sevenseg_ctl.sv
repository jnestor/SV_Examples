//-----------------------------------------------------------------------------
// Module Name   : sevenset_ctl - extended seven-segment controller
// Project       : ECE 212 - Digital Circuits II
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jan 2022
//-----------------------------------------------------------------------------
// Description   : Extended 7-segment controller for Nexys A7 boards
// with blanking, decimal point and dash (minus sign) display as options.
// For each input di in d7-d0:
//    di[6] - blank (turns of display when blank=1
//    di[5] - dp displays decimal point when asserted and blank=0 (active high)
//    di[4] - dash displays a dash/minus sign when asserted and blank=0
//    d[3:0] - binary value to be displayed as a hexadecimal digit
//             when minus=0 and blank=0
//-----------------------------------------------------------------------------

module sevenseg_ctl(
    input logic clk, rst,
    input logic [6:0] d7, d6, d5, d4, d3, d2, d1, d0,
    output logic [6:0] segs_n,
    output logic dp_n,
    output logic [7:0] an_n
    );

    logic enb, clr;
    logic [2:0] digit;  // count of current digit
    logic [6:0] muxd;

    assign clr = 1'b0;

    period_enb #(.PERIOD_MS(1)) U_ENB(.clk, .rst, .clr, .enb_out(enb));

    counter #(.W(3)) U_CT (.clk, .rst, .enb, .q(digit));

    dec_3_8_n U_DEC (.a(digit), .y_n(an_n));

    mux8 #(.W(7)) U_MUX8 (.sel(digit), .d0, .d1, .d2, .d3, .d4, .d5, .d6, .d7, .y(muxd));

    sevenseg_ext_n U_SSEG (.d(muxd), .segs_n, .dp_n);

endmodule
