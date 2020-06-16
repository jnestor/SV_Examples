//-----------------------------------------------------------------------------
// Title         : mem2p_sw_ar 2-port memory
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// File          : mem2p_sw_ar.sv
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : 13.02.2020
// Last modified : 13.02.2020
//-----------------------------------------------------------------------------
// Description :
// Two-port memory with a single clock, a synchronous write port
// and an asynchronous read port.  This will synthesize as distributed
// RAM in a Xilinx FPGA
//-----------------------------------------------------------------------------

  module mem2p_sw_ar #(parameter W=8, D=128, localparam DW=$clog2(D))
    (
    input logic clk,
    input logic we1,
    input logic [DW-1:0] addr1,
    input logic [W-1:0]  din1,
    input logic [DW-1:0] addr2,
    output logic [W-1:0] dout2
    );

  logic [W-1:0] ram_array [D-1:0];

  always_ff @(posedge clk)
    if (we1) ram_array[addr1] = din1;

  assign dout2 = ram_array[addr2];

endmodule
