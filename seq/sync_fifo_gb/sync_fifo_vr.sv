//-----------------------------------------------------------------------------
// Title         : sync_fifo_vr - Synchronous FIFO w/ valid/ready interface
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// File          : sync_fifo_vr.sv
// Author        : John Nestor
// Created       : 01.06.2019
// Last modified : 02.12.2020
//-----------------------------------------------------------------------------
// Description :
// A synchronous FIFO using a valid/ready interface
//-----------------------------------------------------------------------------
module sync_fifo #(parameter W=8, D=4)
  (input logic clk, rst, ivalid, oready,
   input logic [W-1:0] din,
   output logic [W-1:0] dout,
   output logic iready, ovalid);

  localparam DW=$clog2(D);

  logic [DW-1:0] wp, rp, wp_inc, rp_inc;
  logic we, re, gb, empty, full;

  fifo_ram #(.W(W), .D(D)) U_RAM (.clk, .we, .din, .rdaddr(rp), .
                            wraddr(wp), .dout);

  assign wp_inc = wp + 1;
  assign rp_inc = rp + 1;
  assign empty = (wp == rp) && !gb;
  assign full = (wp == rp) && gb;

  assign ovalid = !empty;
  assign iready = !full;

  assign we = iready && ivalid;
  assign re = ovalid && oready;

  always_ff @(posedge clk)
    if (rst) wp <= 0;
    else if (we) wp <= wp_inc;

  always_ff @(posedge clk)
    if (rst) rp <= 0;
    else if (re) rp <= rp_inc;

   always_ff @(posedge clk)
     if (rst) gb <= 0;
     else if ((wp_inc == rp) && ivalid) gb <= 1;
     else if (oready) gb <= 0;

endmodule
