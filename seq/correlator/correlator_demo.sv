//-----------------------------------------------------------------------------
// Module Name   : correlator
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : Mar 4 2021
//-----------------------------------------------------------------------------
// Description :
// Demonstration of different correlators working with a defined bit rate
//-----------------------------------------------------------------------------
module correlator_demo(
    input logic clk, rst,
    input logic rxd
    );

    logic enb_16x, enb_8x;

    parameter CLOCK_PD_NS = 10;
    parameter BIT_RATE = 50_000;
    localparam BITPD_NS = 1_000_000_000 / BIT_RATE;  // bit period in ns

    rate_enb #(.RATE_HZ(BIT_RATE*16)) U_RATE_16 (.clk, .rst(rst), .clr(1'b0), .enb_out(enb_16x));

    rate_enb #(.RATE_HZ(BIT_RATE*8)) U_RATE_8 (.clk, .rst(rst), .clr(1'b0), .enb_out(enb_8x));

    logic [6:0] pre_sum, sfd_sum;
    logic [4:0] det16_sum;
    logic [3:0] det8_sum;
    logic r_edge, f_edge, r_edge_enb, f_edge_enb;
    logic pre_h,pre_l, sfd_h, sfd_l, det16_h, det16_l, det8_h, det8_l;
    
            
    edge_det U_EDGE (.clk, .d_in(rxd), .r_edge, .f_edge);
    
    edge_det_enb U_EENB (.clk, .d_in(rxd), .enb(enb_16x), .r_edge(r_edge_enb), .f_edge(f_edge_enb));

    correlator #(
        .LEN(64), .PATTERN(64'b11110000_00001111_11110000_00001111_11110000_00001111_11110000_00001111),
        .HTHRESH(54), .LTHRESH(10))
        U_PREAMBLE_DET (
            .clk, .rst, .enb(enb_8x), .d_in(rxd), .csum(pre_sum),
            .h_out(pre_h), .l_out(pre_l)
        );

    correlator #(
        .LEN(64), .PATTERN(64'b00001111_00001111_00001111_00001111_11110000_00001111_11110000_11110000),
        .HTHRESH(54), .LTHRESH(10))
        U_SFD_DET (
            .clk, .rst, .enb(enb_8x), .d_in(rxd), .csum(sfd_sum),
            .h_out(sfd_h), .l_out(sfd_l)
        );

        
    correlator #(
        .LEN(16), .PATTERN(16'b00000000_11111111),
        .HTHRESH(14), .LTHRESH(2))
        U_EDGE_DET_16 (
            .clk, .rst, .enb(enb_16x), .d_in(rxd), .csum(det16_sum),
            .h_out(det16_h), .l_out(det16_l)
        );
     
     correlator #(
        .LEN(8), .PATTERN(16'b0000_1111),
        .HTHRESH(7), .LTHRESH(1))
        U_BIT_DET (
            .clk, .rst, .enb(enb_16x), .d_in(rxd), .csum(det8_sum),
            .h_out(det8_h), .l_out(det8_l)
        );

    logic [4:0] det_eof_sum;
    logic det_eof_h, det_eof_l;
    
    correlator #(
        .LEN(16), .PATTERN(16'b11111111_11111111),
        .HTHRESH(14), .LTHRESH(2))
        U_EOF_DET (
            .clk, .rst, .enb(enb_8x), .d_in(rxd), .csum(det_eof_sum),
            .h_out(det_eof_h), .l_out(det_eof_l)
        );

endmodule: correlator_demo
