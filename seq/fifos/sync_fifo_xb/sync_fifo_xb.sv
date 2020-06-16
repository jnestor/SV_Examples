//-----------------------------------------------------------------------------
// Title         : sync_fifo_xb - Synchronous FIFO w/traditional interface
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// File          : sync_fifo.sv
// Author        : John Nestor
// Created       : 01.06.2019
// Last modified : 02.12.2020
//-----------------------------------------------------------------------------
// Description :
// A synchronous FIFO using a traditional interface with full and empty
// status outputs.  Extra bit (xb) in rp & wp used to detect full vs. empty
//-----------------------------------------------------------------------------
module sync_fifo_xb #(parameter WIDTH=8, DEPTH=4)
  (input logic clk, rst, enqueue, dequeue,
   input logic [WIDTH-1:0] din,
   output logic [WIDTH-1:0] dout,
   output logic full, empty);

  localparam ADDRW = $clog2(DEPTH);  // address size in bits

  logic [ADDRW:0] wp, rp;  // note extra leftmost bit!
  logic [ADDRW-1:0] wraddr, rdaddr;
  assign wraddr = wp[ADDRW-1:0];
  assign rdaddr = rp[ADDRW-1:0];

  logic wp_inc_en, rp_inc_en;

  fifo_ram #(.W(WIDTH), .D(DEPTH)) U_RAM  (.clk, .we(wp_inc_en), .din, .rdaddr(rp),
                                           .wraddr(wp), .dout);

  assign empty =  (wraddr == rdaddr) && (wp[ADDRW] == rp[ADDRW]);
  assign full = (wraddr == rdaddr) && (wp[ADDRW] != rp[ADDRW]);

  assign wp_inc_en = enqueue && !full;  // avoid breaking FIFO on overflow
  assign rp_inc_en = dequeue && !empty; // avoid breaking FIFO on underflow

  always_ff @(posedge clk)
    if (rst) wp <= 0;
    else if (wp_inc_en) wp <= wp + 1;

  always_ff @(posedge clk)
    if (rst) rp <= 0;
    else if (rp_inc_en) rp <= rp + 1;

endmodule
