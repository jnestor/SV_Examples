//-----------------------------------------------------------------------------
// Title         : crc_bench - testbemch for 8-Bit Dallas/Maxim CRC calculator
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : Mar 2006
// Last modified : April 2021
//-----------------------------------------------------------------------------
// Description :
// This testbench exercises the reference Dallas/Maxim 1-wire CRC circuit.
// Currently it applies two bytes to the CRC, and then applies the CRC itself
// starting with qx[8] and ending with qx[1].  The result of this two-byte message
// and CRC must be zero.  Note that in this design, q[8] is the LEFTMOST bit
// of the CRC, while qx[1] is the RIGHTMOST bit.  This is the reverse of the
// order in which we whould usually like to transmit the CRC.
//-----------------------------------------------------------------------------

module crc_bench;

    // Inputs
    logic clk, rst, d;

    // Outputs
    logic [8:1] qx;
    logic [8:1]  crc; // for saving the value

    // Instantiate Device Under Verification (DVUV)
    crc DUV (
    .clk(clk),
    .rst(rst),
    .d(d),
    .qx(x)
    );

    // apply data bit di to the CRC input for one clock cycle
    task send_bit(input logic di);
        begin
            d = di;
            @(posedge clk) #1;
        end
    endtask

    // apply the 8 data bits in bi to the CRC input over eight
    // clock cycles, starting with bi[0]
    task send_byte(input [7:0] bi);

        integer 	  i;

        begin
            for (i = 0; i <= 7; i = i+1)
            send_bit(bi[i]);
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
        crc = qx;
        $display("Sending CRC Code: %x", qx);
        // apply the CRC.  Sinc3e x[8] is the
        // leftmost bit, can't use send_byte here
        send_bit(crc[8]);
        send_bit(crc[7]);
        send_bit(crc[6]);
        send_bit(crc[5]);
        send_bit(crc[4]);
        send_bit(crc[3]);
        send_bit(crc[2]);
        send_bit(crc[1]);
        if (x==0) $display("CRC recevived correctly: %x", qx);
        else $display("CRC recevived incorrectly: %x", qx);
        d = 0;
        @(posedge clk) #1;
        $stop;
    end
    
endmodule
