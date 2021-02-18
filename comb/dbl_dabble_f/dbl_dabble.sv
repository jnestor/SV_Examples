//-----------------------------------------------------------------------------
// Module Name   : dbl_dabble - binary-bcd converter (outpus 3 bcd digits)
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : Functional description of an extended binary-bcd
//  converter using the double-dabble algorithm implemented in combinational
// logic.  This version converts an 8-bit input to three bcd digits output
// The $display functions illustrate how the algorithm functions
// but are ignored during synthesis
//-----------------------------------------------------------------------------

module dbl_dabble(
    input logic [7:0] b,
    output logic [3:0] hundreds, tens, ones
    );

logic [7:0] bs;

always_comb
    begin
        $display("dbl_dabble input: %d", b);
        bs = b;
        {hundreds, tens, ones} = 12'h0;
        for (int i=1; i<=8; i++)
            begin
                if ((i > 3) && (ones >= 4'd5)) begin
                    ones = ones + 3;
                    $display("add3o %1d %4b %4b %4b %8b", i, hundreds, tens, ones, bs);
                end
                if ((i > 6) && (tens >= 4'd5)) begin
                    tens = tens + 3;
                    $display("add3t %1d %4b %4b %4b %8b", i, hundreds, tens, ones, bs);
                end
                // don't need to check hundreds digit - it will never go above 3!
                {hundreds, tens, ones, bs} = {hundreds, tens, ones, bs} << 1;
                $display("shift %1d %4b %4b %4b %8b", i, hundreds, tens, ones, bs);
            end
            $display("result    %d   %d   %d", hundreds, tens, ones);
    end

endmodule: dbl_dabble
