//-----------------------------------------------------------------------------
// Title         : mem2p_sw_ar_tb Testbench for 2-port memory
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// File          : mem2p_sw_ar.sv
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : 13.02.2020
// Last modified : 13.02.2020
//-----------------------------------------------------------------------------
// Description :
// Simple stimulus-only testbench for a two-port memory with a single
// clock, a synchronous write port and a synchronous read port.
//------------------------------------------------------------------------------
// Modification history :
// 13.02.2020 : created
//-----------------------------------------------------------------------------

module mem2p_sw_ar_tb;
  parameter W=8, D=16, DW=$clog2(D);
  logic clk, we1;
  logic [DW-1:0] addr1;
  logic [W-1:0] din1;
  logic [DW-1:0] addr2;
  logic [W-1:0] dout2;


  mem2p_sw_sr #(.W(W), .D(D)) DUV (.clk, .we1, .din1, .addr1,
                                    .addr2, .dout2);

  always begin
    clk = 0; #10;
    clk = 1; #10;
  end

  initial begin
    $monitor("time=%t we1=%b addr1=%h din1=%h addr2=%h dout2=%h",
             $time, we1, addr1, din1, addr2, dout2);

    we1 = 0;
    addr1 = 4'd0;
    din1 = 8'd0;
    addr2 = 4'd0;
    @(posedge clk) #1;
    we1 = 1;
    @(posedge clk) #1;
    addr1 = 4'd1;
    din1 = 8'd1;
    @(posedge clk) #1;
    addr1 = 4'd2;
    din1 = 8'hF2;
    addr2 = 4'd1;
    @(posedge clk) #1;
    we1 = 0;
    addr2 = 4'd2;
    @(posedge clk) #1;
    $stop;
  end
endmodule
