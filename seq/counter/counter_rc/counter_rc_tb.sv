// stimulus-only testbench for ripple counter

module #(parameter CLKPD=100) counter_rc_tb
        (input logic clk,
         output logic rst, enb,
         input logic [3:0] q,    // not used in stimulus-only
         input logic       cy);  // not used in stimulus-only

  initial begin
    rst = 1;  // initial reset
    enb = 0;
    #(CLKPD+1);  // resume 1 time unit after clock edge
    rst = 0;
    #(CLKPD);
    enb = 1;  // observe counting 0-15
    #(CLKPD*15);
    enb = 0;  // observe ripple carry
    #(CLKPD/2);
    enb = 1;  // observe rollover
    #(CLKPD/2 + CLKPD*5);
    rst = 1;  // observe reset
    #(CLKPD*2);
    $stop;
  end

endmodule: counter_rc_tb
