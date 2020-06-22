// self-checking testbench for ripple counter

module counter_rc_sctb #(parameter CLKPD=100)
        (input logic clk,
         output logic rst, enb,
         input logic [3:0] q,
         input logic       cy);

    int errcount = 0;

    task check(logic [3:0] exp_q, logic exp_cy);
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

    // transaction tasks

    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
    endtask: reset_duv

    task run_counter(int cycles)
        enb = 1;
        repeat (cycles) @(posedge clk);
        #1;
    endtask: counter

    task test_cy;
        enb = 1;
        while (q != 15) run_counter(1);
        check(15, 1);
        #1;
        enb = 0;
        #1;
        check (15, 0);
        #1;
        enb = 1;
        #1;
        check (15, 1);
        @(posedge clk) #1;  // test rollover
        check(0, 0);
        enb = 0;
    endtask: test_cy

    task test_disabled;
        logic [3:0] q_start = q;
        enb = 0;
        @(posedge clk) #1;
        check (q_start, 0);
    endtask

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors");
    endtask: report_errors

    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        check(0, 0);
        check_disabled;
        run_counter(1);
        check(1, 0);
        run_counter(5);
        check(6, 0);
        run_counter(9);
        check(15, 1);
        run_counter(2);
        check(1, 0);
        test_disabled;
        test_cy;
        report_errors;
        $stop;
    end

endmodule: counter_rc_sctb
