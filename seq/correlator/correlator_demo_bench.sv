//-----------------------------------------------------------------------------
// Module Name   : correlator_tb - stimulus-only testbench for correlator
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : Mar 4 2021
//-----------------------------------------------------------------------------
// Description :
// Inputs a sequence of bits of length LEN on d_in and computes the number
// matching bits when compared to a PATTERN of the same length.
// Asserts h_out true when the number of matching bits equals or exceeds
// threshold value HTHRESH.
// Asserts l_out true when the number of matching equals or is less than LTHRESH.
//-----------------------------------------------------------------------------

module correlator_demo_bench (
    input clk,
    output logic rst, txd
    );

    timeunit 1ns / 100ps;

    parameter CLKPD_NS = 10;
    parameter BIT_RATE = 50_000;
    localparam BITPD_NS = 1_000_000_000 / BIT_RATE;  // bit period in ns
    parameter ERROR_RATE_PPM = 1000;  // error rate per million clock cycles

    logic txd_clean;
    
    // Noise injection for normal signal
    
    logic noise_error;

    correlator_demo DUV (.clk, .rst, .rxd(txd));

    assign txd = txd_clean ^ noise_error;


    int r;
    always @(posedge clk)
    begin
        #1;
        r = $urandom_range(1_000_000,1);
        //$display("r=%d",r);
        if (r <= ERROR_RATE_PPM) begin
            noise_error = 1;
            //$display("%t error injected", $time);
        end
        else noise_error = 0;
    end
    
    // tasks to send data, eof, and noise to txd
    
    task do_reset();
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        @(posedge clk) #1;    
    endtask

    task send_bit(input logic d);
        txd_clean = d;
        #(BITPD_NS/2);
        txd_clean = !d;
        #(BITPD_NS/2);
    endtask

    task send_byte(input logic [7:0] data);
        $display("send_byte: %h at time %t", data, $time);
        for (int i=0; i<=7; i++) begin
            send_bit(data[i]);  // send lsb first
        end
    endtask
    
    // send an EOF marker with length in bit periods
    task send_eof(input int length);
        txd_clean = 1;
        #(BITPD_NS * length);
    endtask
    
    task send_noise(input int length);
        for (int i=0; i< (length*BITPD_NS/CLKPD_NS); i++) begin
            @(posedge clk) #1;
            txd_clean = $urandom() & 1;  // coin toss
        end
    endtask
    
        // send an EOF marker with length in bit periods
    task send_error_low(input int length);
        txd_clean = 0;
        #(BITPD_NS * length);
    endtask
    
    localparam PREAMBLE=8'b01010101;
    localparam SFD=8'b11010000;
    
    // actual testbench

    initial begin
        $timeformat(-9, 0, "ns", 6);
        txd_clean = 1; // start with idle value
        do_reset();
        send_noise(8);
        //send_byte(PREAMBLE);
        send_byte(PREAMBLE);
        send_byte(SFD);
        send_byte(8'b00110101);
        send_eof(2);
        send_noise(8);
        send_error_low(2);
        send_noise(1);
        $stop;
    end
endmodule
