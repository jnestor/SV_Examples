module sync_fifo_tb;
  parameter WIDTH=8, DEPTH=4;
  logic clk, rst, enqueue, dequeue;
  logic [WIDTH-1:0] din;
  logic [WIDTH-1:0] dout;
  logic full, empty;

  sync_fifo_xb #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUV 
      (.clk, .rst, .enqueue, .dequeue,
       .din, .dout, .full, .empty);

  always begin
    clk = 0; #5;
    clk = 1; #5;
  end

  task idle_fifo;
    din = 0;
    enqueue = 0;
    dequeue = 0;
  endtask: idle_fifo

  task enqueue_fifo(input logic [WIDTH-1:0] data);
    din = data;
    enqueue = 1;
    @(posedge clk) #1
    din = 0;
    enqueue = 0;
  endtask: enqueue_fifo

  task dequeue_fifo();
    dequeue = 1;
    @(posedge clk) #1;
    dequeue = 0;
  endtask: dequeue_fifo

  task enqueue_dequeue_fifo(input logic [WIDTH-1:0] data);
    din = data;
    enqueue = 1;
    dequeue = 1;
    @(posedge clk) #1;
    enqueue = 0;
    dequeue = 0;
  endtask: enqueue_dequeue_fifo

  initial begin
    rst = 1;
    idle_fifo();
    @(posedge clk) #1;
    rst = 0;
    enqueue_fifo(8'h1);
    dequeue_fifo();
    @(posedge clk) #1;
    enqueue_fifo(8'h11);
    enqueue_fifo(8'h22);
    dequeue_fifo();
    dequeue_fifo();
    @(posedge clk) #1;
    enqueue_fifo(8'h31);
    enqueue_fifo(8'h32);
    enqueue_fifo(8'h33);
    dequeue_fifo();
    dequeue_fifo();
    dequeue_fifo();
    @(posedge clk) #1;
    enqueue_fifo(8'h41);
    enqueue_fifo(8'h42);
    enqueue_fifo(8'h43);
    enqueue_fifo(8'h44);
    enqueue_fifo(8'h45);
    dequeue_fifo();
    dequeue_fifo();
    dequeue_fifo();
    dequeue_fifo();
    @(posedge clk) #1;
    dequeue_fifo();  // try to read an empty fifo
    @(posedge clk) #1;
    enqueue_fifo(8'h51);
    dequeue_fifo();
    @(posedge clk) #1;
    $stop;
  end
endmodule: sync_fifo_tb
