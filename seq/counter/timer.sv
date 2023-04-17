//-----------------------------------------------------------------------------
// Module Name   : timer
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020, updated April 2023
//-----------------------------------------------------------------------------
// Description   : timer - counts down to a parameterized deadline
//                 Override the appropriate parameter to get a deadline
//                 in the specific units.  Initiate timer by asserting
//                 start; timer will assert done when deadline has passed.
//-----------------------------------------------------------------------------

module timer(input logic clk, rst, start,
             output logic done);

    parameter DEADLINE_SEC = 1;
    parameter DEADLINE_MS = DEADLINE_SEC * 1000;
    parameter DEADLINE_US = DEADLINE_MS * 1000;
    parameter DEADLINE_NS = DEADLINE_US * 1000;
    parameter DEADLINE_CYCLES = DEADLINE_NS / CLKPS_NS;  // in clock cycles

    parameter CLKFREQ_MHZ = 100;  
    localparam CLKPD_NS = 110       // default matches Nexys clock
    localparam DW = $clog2(DEADLINE_CYCLES);

    logic [W-1:0] q;

    assign done = (q == '0);

    always_ff @(posedge clk) begin
        if (rst)        q <= '0;
        else if (start) q <= DEADLINE_CYCLES - 1;
        else if (!done) q <= q - 1;
    end

endmodule: timer
