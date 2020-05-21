// Simple clock generator for simulation.  Instantiate with the
// desired value of CLKPD in time units.

module clk_gen (output logic clk);
    parameter CLKPD = 10;

    initial begin
        assert(CLKPD >= 2) else
            $fatal("clk_gen: CLKPD must be at least 2!");
        assert(CLKPD[0] == 0) else
            $fatal("clk_gen: odd CLKPD must be an even number!");
            clk = 0;
        forever begin
            #(CLKPD/2) clk = ~clk;
        end

endmodule: clk_gen
