//-----------------------------------------------------------------------------
// Module Name   : binary_to_bcd_tb - testbench for double-dabble
// Project       : ECE 211 - Digital Circuits 1
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2023
//-----------------------------------------------------------------------------
// Description   : Self-checking testbench for the double-dabble
// binary-bcd converter.  Exhaustively tests all possble values and reports
// errors
//-----------------------------------------------------------------------------

module binary_to_bcd_tb;
    logic  [7:0] b;
    logic [3:0] hundreds, tens, ones;
    logic [3:0] hundreds_exp, tens_exp, ones_exp;

    binary_to_bcd DUV (.b, .hundreds, .tens, .ones);

    int err_ct;

    initial begin
        $timeformat(-9,2," ns");
        // first do some random test cases without checking
        err_ct = 0;
        ones_exp = 0;
        tens_exp = 0;
        hundreds_exp = 0;
        b = 255;
        #10;
        b = 123;
        #10;
        b = 1;
        #10;
        b = 99;
        #10;
        b = 222;
        #10;
        $stop;
        // now exhaustively self-check the translation
        for (int i=0; i<255; i++) begin
            b = i;
            ones_exp = b % 10;
            tens_exp = (b / 10) % 10;
            hundreds_exp = b / 100;
            #10;
            if ( (hundreds_exp != hundreds) || (tens_exp != tens) || (ones_exp != ones) ) begin
                  $display("time=%t, expected %1d %1d %1d actual %1d %1d %1d",
                            $time, hundreds_exp, tens_exp, ones_exp,
                            hundreds, tens, ones);
                  err_ct++;
            end
        end
        $display("%d errors", err_ct );
        $stop;
    end
endmodule
