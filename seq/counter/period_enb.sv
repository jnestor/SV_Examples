//-----------------------------------------------------------------------------
// Title         : PERIOD_COUNT_BITS_enb - parameterized clock enable generator
// Project       : ECE 212 - Digital Circuits II
//-----------------------------------------------------------------------------
// File          : PERIOD_enb.sv
// Author        : John Nestor
// Created       : 01.06.2019
// Last modified : 02.12.2020
//-----------------------------------------------------------------------------
// Description :
// This module generates a periodic  enable signal that is asserted for one clock
// cycle after a parameterized period that can be specified in terms of
// milliseconds (PERIOD_MS), microseconds (PERIOD_US), or nanoseconds (PERIOD_NS).
// The enable output is asserted after the clr signal is asserted high and
// then asserted low.  It will then assert enb true each time the specified
// delay has passed.  It enables connected logic to perform a repeated task
// at a specified rate while keeping all flip-flops // connected to a common clock.
// The default CLKPD_NS parameter corresponds to the on-board clock frequency of
//  a Nexys4 FPGA board.  Note that rst is intended as a master reset signal.
//-----------------------------------------------------------------------------

module period_enb(input logic clk, rst, clr, output logic enb_out);
    parameter PERIOD_MS = 1;   // override ONE of the three delay parameters
    parameter PERIOD_US = PERIOD_MS * 1000;
    parameter PERIOD_NS = PERIOD_US * 1000;
    parameter CLKFREQ_MHZ = 100;  // default matches Nexys4 clock

    localparam CLKPD_NS = 1000 / CLKFREQ_MHZ;
    localparam PERIOD_COUNT_LIMIT = PERIOD_NS / CLKPD_NS;
    localparam PERIOD_COUNT_BITS = $clog2(PERIOD_COUNT_LIMIT);

    logic [PERIOD_COUNT_BITS-1:0] q;

    assign enb_out = (q == PERIOD_COUNT_LIMIT - 1);

    always_ff @(posedge clk)
        if (rst || clr || enb_out) q <= 0;
        else                       q <=  q + 1;

endmodule: period_enb
