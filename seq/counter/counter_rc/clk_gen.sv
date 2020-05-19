// Simple clock generator for simulation.  Instantiate with the
// desired value of CLKPD in time units.

module clk_gen (output logic clk);
  parameter CLKPD = 10;
  initial begin
    assert(CLKPD >= 2) else
      $fatal("clk_gen: CLKPD must be at least 2!");
    assert((CLKPD & 0x1) == 0) else
      $warning("clk_gen: odd CLKPD will give uneven waveform");
  end
  always begin      // clock generator
    clk = 0; #(CLKPD/2);
    clk = 1; #(CLKPD/2);
  end

endmodule: clk_gen
