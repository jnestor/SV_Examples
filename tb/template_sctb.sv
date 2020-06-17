//-----------------------------------------------------------------------------
// Module Name   : template_sctb
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Template file for a self-checking testbench
// Customize as appropriate for your design
//-----------------------------------------------------------------------------

module template_sctb ( input logic clk, rst /* , add connections */  );

    int errcount = 0;

    // tasks for common functions including checking

    task check( exp_v1 /* add expected values to test */ );
        if (v1 != exp_v1) begin
             $display("%t error: %0d expected v1=%h actual v1=%h",
                      $time, exp_v1, v1);
             errcount++;
        end
        // place additional tests here
    endtask: check

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors");
    endtask: report_errors

    // transaction tasks

    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
    endtask: reset_duv

    // place additional transaction tasks here

    initial begin
        $timeformat(-9, 0, "ns", 6);
        $monitor( /* add signals to monitor in console */ );
        reset_duv;

       // call transaction tasks here

        report_errors;
        $stop;  // suspend simulation (use $finish to exit)
    end

endmodule
