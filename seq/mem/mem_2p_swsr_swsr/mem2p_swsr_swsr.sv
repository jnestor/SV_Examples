//-----------------------------------------------------------------------------
// Title         : mem2p_swsr_srw 2-port memory
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor, Lafayette College
// Created       : 13.02.2020
// Last modified : 06.06.2022
//-----------------------------------------------------------------------------
// Description :
// Two-port memory with a single clock, and two synchronous read-write
// ports.  This will infer a "True Dual Port" (TDP) Block RAM
// in a Xilinx FPGA.  CAUTION: this module has not yet been tested
//------------------------------------------------------------------------------

module mem2p_swsr_swsr
    #(parameter W=8, D=128, localparam DW=$clog2(D))
    (
    input logic clk,
    input logic we1,
    input logic [DW-1:0] addr1,
    input logic [W-1:0]  din1,
    output logic [W-1:0] dout1,
    input logic [DW-1:0] addr2,
    input logic [W-1:0] din2,
    output logic [W-1:0] dout2
    );

    logic [W-1:0] ram_array [D-1:0];
    logic [DW-1:0] addr1_r, addr2_r;

    // port 1 write
    always_ff @(posedge clk) begin
        if (we1) ram_array[addr1] <= din1;
    end

    // port 1 read
    always_ff @(posedge clk) begin
        addr1_r <= addr1;
    end

    assign dout1 = ram_array[addr1_r];

    // port 2 write
    always_ff @(posedge clk) begin
        if (we2) ram_array[addr2] <= din2;
    end

    // port 2 read
    always_ff @(posedge clk) begin
        addr2_r <= addr2;
    end

    assign dout2 = ram_array[addr2_r];

endmodule
