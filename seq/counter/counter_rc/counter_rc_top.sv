module counter_rc_top;

  logic clk, rst, enb;
  logic [3:0] q;
  logic       cy;

  paramter CLKPD = 100;
  always begin      // clock generator
    clk = 0; #(CLKPD/2);
    clk = 1; #(CLKPD/2);
  end

  counter_rc DUV (.clk, .rst, .enb, .q, .cy);

  counter_rc_tb TB (.clk, .rst, .enb, .q, .cy);

endmodule: counter_rc_top