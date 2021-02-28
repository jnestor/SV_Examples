//-----------------------------------------------------------------------------
// Module Name   : uart_xmit_sctb
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Self-checking testbench for UART transmitter
//-----------------------------------------------------------------------------

module uart_xmit_sctb (
    input logic clk, rdy,
    output logic rst,
    output logic [7:0] data,
    output logic valid, txd
    );

    parameter CLOCK_PD = 10;
    parameter BAUD_RATE = 9600;
    localparam BITPD_NS = 1_000_000_000 / BAUD_RATE;  // bit period in ns

    int errcount = 0;

    // tasks for common functions including checking

    task check( exp_txd, txd );
        if (txd != exp_txd) begin
             $display("%t error: expected txd=%h actual txd=%h",
                      $time, exp_txd, txd);
             errcount++;
        end
        // place additional tests here
    endtask: check

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors

    // transaction tasks

    task reset_duv;
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
    endtask: reset_duv

    task transmit(logic [7:0] d);
        // transfer data via ready-valid
       data = d;
       valid = 1;
       do begin
           @(posedge clk);
       end while (rdy == 0);
       #1 valid = 0;
        do begin
            @(posedge clk) #1;  // delay till just *after* next clock edge
        end while (rdy == 1);
        valid = 0;
        wait(txd == 0);  // falling edge of start bit_range
        # (BITPD_NS/2);  // delay to middle of bit period
        check(txd, 0);
        for (int i=0; i <= 7; i++) begin
            # (BITPD_NS);
            check(txd, d[i]);
        end
        # (BITPD_NS);
        check(txd, 1); // check stop bit
    endtask

    // place additional transaction tasks here

    initial begin
        $timeformat(-9, 0, "ns", 6);
        $monitor( /* add signals to monitor in console */ );
        reset_duv;

        // call transaction tasks here
        transmit(8'h55);
        transmit(8'h47);
        # (BITPD_NS*3);  // just wait a little while...
        transmit(8'h00);
        report_errors;
        $stop;  // suspend simulation (use $finish to exit)
    end

endmodule
