//-----------------------------------------------------------------------------
// Title         : crc_bench - testbemch for 8-Bit Dallas/Maxim CRC calculator
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : Mar 2006
// Last modified : April 2021
//-----------------------------------------------------------------------------
// Description :
// This testbench exercises the reference Dallas/Maxim 1-wire CRC circuits.
// One implementation uses an LFSR, the other uses a lookup table
// It calculates the CRC of a sequence of bytes and then applies that CRC
// to generate a zero result if the CRC has been calculated correctly.
//-----------------------------------------------------------------------------

module crc_bench;

    // Inputs
logic clk, rst, enb_bit, d;

    // Outputs
    logic [7:0] crc_bit;
    logic [7:0]  crc_saved; // for saving the value
    logic enb_lookup;
    logic [7:0] data_lookup, crc_lookup;

    // Instantiate Device Under Verification (DVUV)
    crc DUV_BIT (
    .clk(clk),
    .rst(rst),
    .enb(enb_bit),
    .d(d),
    .crc(crc_bit)
    );

    crc_lookup DUV_LU (
        .clk, .rst, .enb(enb_lookup), .data(data_lookup), .crc(crc_lookup)
    );

    // apply data bit di to the CRC input for one clock cycle
    task send_bit(input logic di);
        begin
            enb_bit = 1;
            d = di;
            @(posedge clk) #1;
            enb_bit = 0;
        end
    endtask

    // apply the 8 data bits in bi to the CRC input over eight
    // clock cycles, starting with bi[0]
    task send_byte(input [7:0] bi);

        integer 	  i;

        begin
            data_lookup = bi;
            for (i = 0; i <= 7; i = i+1) begin
                if (i == 0) enb_lookup = 1;
                send_bit(bi[i]);
                enb_lookup = 0;
            end
        end
    endtask

    // clock oscillator
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // apply two characters; then apply bits x[8] down to x[1]
    initial begin
        // Initialize Inputs
        rst = 1;
        d = 0;
        @(posedge clk) #1;
        rst = 0;
        send_byte("a");
        send_byte("b");
        send_byte("w");
        send_byte("0");
        send_byte("0");
        send_byte("t");
        send_byte("!");
        crc_saved = crc_bit;
        $display("Sending CRC Code: %x", crc_saved);
        send_byte(crc_saved);
        if (crc_bit==0) $display("CRC recevived correctly: %x", crc_saved);
        else $display("CRC recevived incorrectly: %x", crc_saved);
        d = 0;
        @(posedge clk) #1;
        $stop;
    end

endmodule
