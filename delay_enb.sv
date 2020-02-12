//-----------------------------------------------------------------------------
// Title         : delay_enb - parameterized clock enable generator
// Project       : ECE 212 - Digital Circuits II
//-----------------------------------------------------------------------------
// File          : delay_enb.sv
// Author        : John Nestor
// Created       : 01.06.2019
// Last modified : 01.12.2019
//-----------------------------------------------------------------------------
// Description :
// This module generates a periodic  enable signal that is asserted for one clock
// cycle after a parameterized delay that can be specified in terms of 
// milliseconds (DELAY_MS), microseconds (DELAY_US), or nanoseconds (DELAY_NS).
// The enable output is asserted after the clr signal is asserted high and
// then asserted low.  It will then assert enb true each time the specified
// delay has passed.  Itt enables connected logic to perform a repeated task 
// at a specified rate while keeping all flip-flops // connected to a common clock.  
// The default CLKFREQ parameter corresponds to the on-board clock frequency of
//  a Nexys4 FPGA board.  Note that rst is intended as a master reset signal.

module delay_enb(input logic clk, rst, clr, output logic enb_out);
   parameter DELAY_MS = 1;   // override ONE of the three delay parameters
   parameter DELAY_US = DELAY_MS * 1000;
   parameter DELAY_NS = DELAY_US * 1000;
   parameter CLKPD_NS = 10;  // default matches 100MHz clk freq of Nexys4

   localparam DELAY_COUNT_LIMIT = DELAY_NS / CLKPD_NS;
   localparam DELAY_COUNT_BITS = $clog2(DELAY_COUNT_LIMIT);
   
   logic [DELAY_COUNT_BITS-1:0] q;

   assign enb_out = (q == DELAY_COUNT_LIMIT -1);
   
   always_ff @(posedge clk)
     if (rst || clr || enb_out) q <= 0;
     else q <=  q + 1;
   
endmodule // delay_enb




   
  
