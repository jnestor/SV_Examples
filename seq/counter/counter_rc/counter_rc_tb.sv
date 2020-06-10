// stimulus-only testbench for ripple counter

module counter_rc_tb #(parameter CLKPD=100)
        (input logic clk,
         output logic rst, enb,
         input logic [3:0] q,
         input logic       cy);

    initial begin
        $timeformat(-9, 0, "ns", 6);
        $monitor("time=%t rst=%b enb=%b q=%h cy=%b",
                  $time, rst, enb, q, cy);
        rst = 1;  // initial reset
        enb = 0;
        @(posedge clk) #1;  // resume 1 time unit after clock edge
        rst = 0;
        #(CLKPD);
        enb = 1;  // observe counting 0-15
        #(CLKPD*15);
        enb = 0;  // observe ripple carry disabled
        #(CLKPD/2);
        enb = 1;  // observe ripple carry enabled and rollover
        #(CLKPD/2);
        #(CLKPD*2);
        enb = 0;  // observe counting disabled
        #(CLKPD*2);
        rst = 1;
        #(CLKPD);
        $display("Simulation complete");
        $stop;
    end
endmodule: counter_rc_tb
