module fifo_xb_tb
  #(parameter CLKPD=10, WIDTH=8, DEPTH=4) (
   input clk,
   output logic rst, enqueue, dequeue,
   output logic [WIDTH-1:0] din,
   input  logic [WIDTH-1:0] dout,
   input logic  full, empty
   );

   int errcount = 0;

    task check_empty(input logic exp_empty);
        if (empty !== exp_empty) begin
            $display("%t error expected empty=%b actual %b",
                     $time, exp_empty, empty);
            errcount++;
        end
    endtask: check_empty

    task check_full(input logic exp_full);
        if (full !== exp_full) begin
            $display("%t error expected full=%b actual %b",
                     $time, exp_full, full);
            errcount++;
        end
    endtask: check_full

    task check_dout(input logic [WIDTH-1:0] exp_dout);
        if (dout !== exp_dout) begin
            $display("%t error expected dout=%h actual %h",
                     $time, exp_dout, dout);
            errcount++;
        end
    endtask: check_dout

    task check(input logic [WIDTH-1:0] exp_dout, logic exp_empty, logic exp_full);
        check_empty(exp_empty);
        check_full(exp_full);
        check_dout(exp_dout);
    endtask

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors

    task reset_duv;
        enqueue <= 0;
        dequeue <= 0;
        din <= '1;
        rst <= 1;
        @(posedge clk) #1;
        rst <= 0;
    endtask

    task enqueue_fifo(input logic [WIDTH-1:0] data);
        din <= data;
        enqueue <= 1;
        dequeue <= 0;
        @(posedge clk) #1;
        din <= 0;
        enqueue <= 0;
    endtask: enqueue_fifo

    task dequeue_fifo();
        dequeue <= 1;
        enqueue <= 0;
        @(posedge clk) #1;
        dequeue <= 0;
    endtask: dequeue_fifo

    task enqueue_dequeue_fifo(input logic [WIDTH-1:0] data);
        din <= data;
        enqueue <= 1;
        dequeue <= 1;
        @(posedge clk) #1;
        enqueue <= 0;
        dequeue <= 0;
    endtask: enqueue_dequeue_fifo

    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        check_empty(1);
        check_full(0);
        @(posedge clk) #1;
        // insert one item, then remove
        enqueue_fifo(8'h1);
        check(8'h1, 0, 0);
        dequeue_fifo();
        check_empty(1);
        @(posedge clk) #1;
        // enqueue 2 items, then remove
        enqueue_fifo(8'h11);
        check(8'h11, 0, 0);
        enqueue_fifo(8'h22);
        check(8'h11, 0, 0);
        dequeue_fifo();
        check(8'h22, 0, 0);
        dequeue_fifo();
        check_empty(1);
        // enqueu 4 items to fill queue, then remove
        enqueue_fifo(8'h31);
        check(8'h31, 0, 0);
        enqueue_fifo(8'h32);
        check(8'h31, 0, 0);
        enqueue_fifo(8'h33);
        check(8'h31, 0, 0);
        enqueue_fifo(8'h34);
        check(8'h31, 0, 1);
        dequeue_fifo();
        check(8'h32, 0, 0);
        dequeue_fifo();
        check(8'h33, 0, 0);
        dequeue_fifo();
        check(8'h34, 0, 0);
        dequeue_fifo();
        check_empty(1);
        @(posedge clk) #1;
        // over-fill FIFO and make sure it still functions
        enqueue_fifo(8'h41);
        check(8'h41, 0, 0);
        enqueue_fifo(8'h42);
        check(8'h41, 0, 0);
        enqueue_fifo(8'h43);
        check(8'h41, 0, 0);
        enqueue_fifo(8'h44);
        check(8'h41, 0, 1);
        enqueue_fifo(8'h45);
        check(8'h41, 0, 1);
        dequeue_fifo();
        check(8'h42, 0, 0);
        dequeue_fifo();
        check(8'h43, 0, 0);
        dequeue_fifo();
        check(8'h44, 0, 0);
        dequeue_fifo();
        check_empty(1);
        // try to dequeue an empty FIFO
        dequeue_fifo();
        check_empty(1);
        // enqueue 1 item, then enqueue & dequeue simultaneously
        @(posedge clk) #1;
        enqueue_fifo(8'h51);
        check(8'h51, 0, 0);
        enqueue_dequeue_fifo(8'h61);
        check(8'h61, 0, 0);
        dequeue_fifo();
        check_empty(1);
        @(posedge clk) #1;
        // try simultaneous enqueue/dequeue on an empty FIFO
        enqueue_dequeue_fifo(8'h71);
        check(8'h71, 0, 0);
        dequeue_fifo();
        check_empty(1);
        // try simultaneous enqueue/dequeue on a full FIFO
        enqueue_fifo(8'h81);
        enqueue_fifo(8'h82);
        enqueue_fifo(8'h83);
        enqueue_fifo(8'h84);
        check(8'h81, 0, 1);
        enqueue_dequeue_fifo(8'h85);
        check(8'h82, 0, 1);
        dequeue_fifo;
        check(8'h83, 0, 0);
        dequeue_fifo;
        check(8'h84, 0, 0);
        dequeue_fifo;
        check(8'h85, 0, 0);
        dequeue_fifo;
        check_empty(1);
        @(posedge clk) #1;
        report_errors;
        $stop;
    end
endmodule: fifo_xb_tb
