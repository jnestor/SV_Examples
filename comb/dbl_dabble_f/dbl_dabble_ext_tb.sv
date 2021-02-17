//-----------------------------------------------------------------------------
// Module Name   : dbl_dabble_ext_tb - testbench for ext. binar-bcd conv.
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : Self-checking testbench for the extended double-dabble
// binary-bcd converter.  Exhaustively tests all possble values and reports
// errors
//-----------------------------------------------------------------------------

module dbl_dabble_tb;
    logic  [9:0] b;
    logic [3:0] thousands, hundreds, tens, ones;
    logic [3:0] thousands_exp, hundreds_exp, tens_exp, ones_exp;
    dbl_dabble_ext DUV (.b, .thousands, .hundreds, .tens, .ones);

    initial begin
        $timeformat(-9,2," ns");
        b = 1023;
        #10;
        b = 123;
        #10;
        $stop;
        for (int i=0; i<1024; i++) begin
            b = i;
            ones_exp = b % 10;
            tens_exp = (b / 10) % 10;
            hundreds_exp = b / 100 % 10;
            thousands_exp = b / 1000;
            #10;
            if (thousands_exp != thousands)
                $display("time=%t b=%d expected thousands: %d actual %d",$time,b,thousands_exp, thousands);
            if (hundreds_exp != hundreds)
                $display("time=%t b=%d expected hundreds: %d actual %d",$time,b,hundreds_exp, hundreds);
            if (tens_exp != tens)
                $display("time=%t b=%d expected tens: %d actual %d",$time,b,tens_exp, tens);
            if (ones_exp != ones)
                $display("time=%t b=%d expected ones: %d actual %d",$time,b,ones_exp, ones);
        end
        $stop;
    end
endmodule
