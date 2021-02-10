module dbl_dabble_s_tb;
    logic  [7:0] b;
    logic [3:0] hundreds, tens, ones;
    logic [3:0] hundreds_exp, tens_exp, ones_exp;
    binary_to_bcd DUV (.b, .hundreds, .tens, .ones);

    initial begin
        $timeformat(-9,2," ns");
        b = 255;
        #10;
        b = 123;
        #10;
        $stop;
        for (int i=0; i<256; i++) begin
            b = i;
            ones_exp = b % 10;
            tens_exp = (b / 10) % 10;
            hundreds_exp = b / 100;
            #10;
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
