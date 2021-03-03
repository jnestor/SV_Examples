module mxtest_21_top_tb;

    logic clk, rst, btnu, btnd;
    logic [5:0] sw;
    logic txd, txen, rdy, rdy_led;

    mxtest_21_top #(.BIT_RATE(10_000)) MXTOP (.clk, .rst, .btnu, .btnd, .sw, .txd, .txen, .rdy, .rdy_led);

    parameter CLK_PD = 10;
    
    always begin
        clk = 0; #(CLK_PD/2);
        clk = 1; #(CLK_PD/2);
    end

    initial begin
        rst = 1;
        btnu = 0;
        btnd = 1;
        sw = 1;
        @(posedge clk) #1;
        rst = 0;
        @(posedge clk) #1;
        #(1_000_000*CLK_PD);
        sw = 2;
        #(1_000_000*CLK_PD);
        $stop;
        sw=31;
        #(2_000_000*CLK_PD);
        $stop;
    end
endmodule
    
