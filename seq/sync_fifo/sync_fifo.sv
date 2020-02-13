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
// status outputs
//-----------------------------------------------------------------------------
module sync_fifo #(parameter WIDTH=8, DEPTH=4)
  (input logic clk, rst, enqueue, dequeue,
   input logic [WIDTH-1:0] din,
   output logic [DEPTH-1:0] dout,
   output logic full, empty);

  localparam ADRW = $clog2(DEPTH);  // address size in bits

  logic [ADRW-1:0] wp, rp, wp_inc, rp_inc;
  logic wp_inc_en, rp_inc_en;
  logic gb;  // differentiates empty vs full conditions when rp==wp

  fifo_ram #(.W(WIDTH), .D(DEPTH)) U_RAM  (.clk, .we, .din, .rdaddr(rp),
                                           .wraddr(wp), .dout);

  assign wp_inc = wp + 1;
  assign rp_inc = rp + 1;
  assign empty = (wp == rp) && !gb;
  assign full = (wp == rp) && gb;

  assign ovalid = !empty;
  assign iready = !full;

  assign wp_inc_en = enqueue && !full;  // avoid breaking FIFO on overflow
  assign rp_inc_en = dequeue && !empty; // avoid breaking FIFO on underflow

  always_ff @(posedge clk)
    if (rst) wp <= 0;
    else if (wp_inc_en) wp <= wp_inc;

  always_ff @(posedge clk)
    if (rst) rp <= 0;
    else if (rp_inc_en) rp <= rp_inc;

   always_ff @(posedge clk)
     if (rst) gb <= 0;
     else if ((wp_inc == rp) && enqueue) gb <= 1;
     else if (dequeue) gb <= 0;

endmodule
