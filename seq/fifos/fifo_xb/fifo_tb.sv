module fifo_tb
  #(parameter CLKPD=10, WIDTH=8, DEPTH=4)
   (output logic clk, rst,
    output logic enqueue, dequeue,
    output logic [WIDTH-1:0] din,
    input  logic [WIDTH-1:0] dout,
    input logic  full, empty);

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

    task check(input logic [WIDTH-1:0] exp_dout, input logic exp_empty, input logic exp_full);
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

    // testcase tasks

    // enqueue and then dequeue a single data item
    task single_enqueue_dequeue;
        $display("testcase: single_enqueue_dequeue");
        reset_duv;
        check_empty(1);
        check_full(0);
        @(posedge clk) #1;
        // insert one item, then remove
        enqueue_fifo(8'h01);
        check(8'h01, 0, 0);
        dequeue_fifo();
        check_empty(1);
    endtask: single_enqueue_dequeue

    // enqueue the FIFO up to its depth, then dequeue each item
    task fill_and_empty;
        int i;
        automatic int stval= 8'h41;
        $display("testcase: fill_and_empty");
        while (!empty) dequeue_fifo();
        // fill queue with increasing integers one short of full
        for (i=stval; i<stval+DEPTH-1; i++) begin
            enqueue_fifo(i);
            check(stval,0,0);
        end
        enqueue_fifo(i);  // this should fill it u!
        check(stval, 0, 1);
        // remove DEPTH-1 items
        for (i=stval; i < stval+DEPTH-1; i++) begin
            dequeue_fifo;
            check(i+1,0,0);
        end
        dequeue_fifo;  // should be the last item!
        check_empty(1);
    endtask: fill_and_empty

    // fill the queue, then attempt to enqueue additional data
    // then empty the queue checking the contents are still correct
    task overfill_and_empty;
        int i;
        automatic int stval= 8'h51;
         $display("testcase: overfill_and_empty");
        while (!empty) dequeue_fifo();
        // add DEPTH-1 increasing integers to queue
        for (i=stval; i<stval+DEPTH-1; i++) begin
            enqueue_fifo(i);
            check(stval,0,0);
        end
        enqueue_fifo(i++);  // add last item
        check (stval,0,1); 
        // now try to enqueue two more values
        enqueue_fifo(i++);
        check(stval,0,1);
        enqueue_fifo(i);
        check(stval,0,1);
        // now remove DEPTH-1 items
        for (i=stval; i < stval+DEPTH-1; i++) begin
            dequeue_fifo;
            check(i+1,0,0);
        end
        dequeue_fifo;  // remove last item
        check_empty(1);
    endtask: overfill_and_empty

    task overempty;
        $display("testcase: overempty");
        while (!empty) dequeue_fifo;  // makesure it's empty
        dequeue_fifo;
        check_empty(1);
        dequeue_fifo;
        check_empty(1);
        fill_and_empty;  // make sure it still works
    endtask: overempty

    // partially fill the queue, then remove an item and add an
    // item before dequeuing everything
    task mixed_enqueue_dequeue;
        int i;
        automatic int stval = 8'h71;
        automatic int lastval = stval + DEPTH/2 + 1;
        $display("testcase: mixed_enqueue_dequeue");
        while (!empty) dequeue_fifo;  // make sure it's empty
        for (i=stval; i<stval+DEPTH/2; i++) begin
            enqueue_fifo(i);
            check(stval,0,0);
        end
        enqueue_dequeue_fifo(lastval);
        check(stval+1,0,0);
        for (i=stval; i<stval+DEPTH/2-1; i++) begin
            dequeue_fifo;
            check(i,0,0);
        end
        dequeue_fifo;
        check(lastval,1,0);
    endtask: mixed_enqueue_dequeue


    // testbench body

    initial begin
        $timeformat(-9, 0, "ns", 6);
        reset_duv;
        check_empty(1);
        check_full(0);
        single_enqueue_dequeue;
        fill_and_empty;
        // call additional testcases here
        overfill_and_empty;
        overempty;
        report_errors;
        $stop;
    end
endmodule: fifo_tb
