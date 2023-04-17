module timer_tb;

    parameter CLK_PD = 10;

    logic clk, rst, start, done;

    timer #(.DEADLINE_NS(100)) DUV (.clk, .rst, .start, .done);

    always begin
        clk = 0; #(CLK_PD/2);
        clk = 1; #(CLK_PD/2);
    end

    initial begin
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        #CLK_PD;
        start = 1;
        #CLK_PD;
        start = 0;
        #(CLK_PD * 12);
        start = 1;
        #(CLK_PD * 2);
        start = 0;
        #(CLK_PD/2);
        $stop;
    end
endmodule
