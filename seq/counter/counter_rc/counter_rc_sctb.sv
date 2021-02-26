// self-checking testbench for ripple counter

module counter_rc_sctb #(parameter CLKPD=100) (
    input logic       clk,
    output logic      rst, enb,
    input logic [3:0] q,
    input logic       cy
    );

    int errcount = 0;

    task check(logic [3:0] exp_q, logic exp_cy, int req);
        if (q != exp_q) begin
            $display("%t error: %0d expected q=%h actual q=%h",
                    $time, exp_q, q);
           errcount++;
        end
        if (cy != exp_cy) begin
            $display("%t error: %0d expected cy=%b actual cy=%b",
                     $time, exp_cy, cy);
            errcount++;
        end
    endtask: check

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors");
    endtask: report_errors

    initial begin
        $timeformat(-9, 0, "ns", 6);
        rst = 1;  // initial reset
        enb = 0;
        @(posedge clk) #1;  // resume 1 time unit after clock edge
        check(0, 0);
        rst = 0;
        #(CLKPD);
        enb = 1;  // observe counting 0-15
        #(CLKPD*15);
        check(15, 1);  // check if ripple carry asserted
        enb = 0;
        #(CLKPD/2);
        check(15, 0);  // check if ripple carry deasserted when enb=0
        enb = 1;
        #(CLKPD/2);
        check(0, 0); // check counter rollover
        #(CLKPD*2);
        check(2, 0); // check increment
        enb = 0;
        #(CLKPD);
        check(2, 0);  // check no count when disabled
        enb = 1;
        #(CLKPD);
        check(3, 0);  // check no count when disabled
        rst = 1;
        #(CLKPD);
        check(0, 0);  // check if reset has priority over enable
        check(15, 1); // intentional error message
        $display("Simulation complete - %0d errors", errcount);
        $stop;
    end

endmodule: counter_rc_sctb
