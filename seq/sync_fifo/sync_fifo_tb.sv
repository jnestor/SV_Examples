// Code your testbench here
// or browse Examples
module sync_fifo_tb;
  parameter W=8, D=4;
  logic clk, rst, ivalid, oready;
  logic [W-1:0] din;
  logic [W-1:0] dout;
  logic iready, ovalid;

  sync_fifo #(.W(W), .D(D)) DUV (.clk, .rst, .ivalid, .full,
           .din, .dout, .iready, .ovalid);

  always begin
    clk = 0; #10;
    clk = 1; #10;
  end

  task do_push (input logic [W-1:0] d)
    begin
      assert (!full) else $warning("writing to full FIFO");
      din = d;
      push = 1'b1;
      @(posedge clk) #1;
      push = 1'b0;
    end

    task do_pop;
      begin
        assert (!empty) else $warning("reading from empty FIFO");
        q = dout;
        pop = 1'd1;
        @(posedge clk) #1;
        pop = 0;
      end

  initial begin
    int i;
    $monitor("time=%t ivalid=%b iready=%b din=%h ovalid=%b oready=%b dout=%h",
             $time, ivalid, iready, din, ovalid, oready, dout);
    din = 8'd0;
    rst = 1;
    push = 0;
    pop = 0;
    @(posedge clk); #1;
    rst = 0;
    for (i=1; i<=5; i++)
        do_push(i);
    for (i = i <= 5; i++)
        do_pop;
    for (i=1; i <= 4; i++)
        do_push(10+i);
    for (i=1; i <= 3; i++)
        do_pop;
    $stop;
  end
endmodule
