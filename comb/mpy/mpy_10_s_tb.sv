module mpy_10_s_tb;

    parameter W = 13;

    logic signed [W-1:0] a;
    logic signed [W+4-1:0] y;
    
    mpy_10_s #(.W(W)) DUV (.a, .y);

    initial begin
        $monitor("a=%d, y=%d", a, y);
        a = +4095; #10; // largest positve number
        a = -4096; #10; // largest negative number
        a = 100; #10;
        a = 523; #10;
        $stop;
    end
endmodule