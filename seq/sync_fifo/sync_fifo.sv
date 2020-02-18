//-----------------------------------------------------------------------------
// Title         : sync_fifo - Synchronous FIFO w/traditional interface
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// File          : sync_fifo.sv
// Author        : John Nestor
// Created       : 01.06.2019
// Last modified : 02.12.2020
//-----------------------------------------------------------------------------
// Description :
// A synchronous FIFO using a traditional interface with full and empty
// status outputs.  DEPTH should be a power of 2!
//-----------------------------------------------------------------------------

module sync_fifo #(parameter WIDTH=8, DEPTH=4)
  (input logic clk, rst, push, pop,
   input logic [WIDTH-1:0] din,
   output logic [WIDTH-1:0] dout,
   output logic full, empty);

  localparam ADRW = $clog2(DEPTH);  // address size in bits

  logic [ADRW:0] wp, rp, wp_inc, rp_inc;  // note this is ADRW+1 bits!
  // break out MSB, RAM addresses from wp, rp
  logic [ADRW-1:0] wpaddr, rpaddr;
  logic wpmsb, rpmsb;
  assign wpaddr = wp[ADRW-1:0];
  assign wpmsb = wp[ADRW];
  assign rpaddr = rp[ADRW-1:0];
  assign rpmsb = rp[ADRW];

  logic wp_inc_en, rp_inc_en;

  mem2p_sw_ar #(.W(WIDTH), .D(DEPTH)) U_RAM
      (.clk, .we1(wp_inc_en), .din1(din), .addr1(wpaddr),
       .addr2(rpaddr), .dout2(dout));

  assign wp_inc = wp + 1;
  assign rp_inc = rp + 1;
  assign empty = (wpmsb == rpmsb) && (wpaddr == rpaddr);
  assign full  = (wpmsb != rpmsb) && (wpaddr == rpaddr);

  assign wp_inc_en = push && !full;  // avoid breaking FIFO on overflow
  assign rp_inc_en = pop && !empty; // avoid breaking FIFO on underflow

  always_ff @(posedge clk)
    if (rst) wp <= 0;
    else if (wp_inc_en) wp <= wp_inc;

  always_ff @(posedge clk)
    if (rst) rp <= 0;
    else if (rp_inc_en) rp <= rp_inc;

endmodule
