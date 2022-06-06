//-----------------------------------------------------------------------------
// Title         : mem_swsr - single port memory w/ synchornos read, write
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// File          : mem2p_sw_ar.sv
// Author        : John Nestor  <nestorj@nestorj-mbpro-15.home>
// Created       : 06.06.2022
//-----------------------------------------------------------------------------
// Description :
// single-port memory with a single clock, a synchronous write port
// and a synchronous read port.  This will synthesize as block
// RAM in a Xilinx FPGA
//------------------------------------------------------------------------------

module mem_swsr
    #(parameter W=8, D=128, localparam DW=$clog2(D))
    (
    input logic clk,
    input logic we,
    input logic [DW-1:0] addr,
    input logic [W-1:0]  din,
    output logic [W-1:0] dout
    );

    logic [W-1:0] ram_array [D-1:0];
    logic [DW-1:0] addr_r;

    always_ff @(posedge clk) begin
        if (we) ram_array[addr] <= din;
    end

    always_ff @(posedge clk) begin
        addr_r <= addr;
    end

    assign dout = ram_array[addr_r];

endmodule
