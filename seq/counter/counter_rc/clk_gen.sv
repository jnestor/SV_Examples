//-----------------------------------------------------------------------------
// Module Name   : clk_gen
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Clock generator for simulation with a testbench
// Instantiate with the desired clock period (must be multiple of 2)
//-----------------------------------------------------------------------------

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
    end

endmodule: clk_gen
