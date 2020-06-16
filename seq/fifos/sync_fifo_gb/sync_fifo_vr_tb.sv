// Code your testbench here
// or browse Examples
module sync_fifo_bench;
  parameter W=8, D=4;
  logic clk, rst, ivalid, oready;
  logic [W-1:0] din;
  logic [W-1:0] dout;
  logic iready, ovalid;
  
  sync_fifo #(.W(W), .D(D)) DUV (.clk, .rst, .ivalid, .oready,
           .din, .dout, .iready, .ovalid);
   
  always begin
    clk = 0; #10;
    clk = 1; #10;
  end
  
  initial begin
    $monitor("time=%t ivalid=%b iready=%b din=%h ovalid=%b oready=%b dout=%h",
             $time, ivalid, iready, din, ovalid, oready, dout);
    din = 8'd0;
    rst = 1;
    ivalid = 0;
    oready = 0;
    @(posedge clk); #1;
    rst = 0;
    assert(iready==1 && ovalid==0);
    // write and read a single value
    @(posedge clk); #1;
    din = 8'h11;
    ivalid = 1;
    @(posedge clk); #1;
    ivalid = 0;
    @(posedge clk); #1;
        $display("din=%h ram_array[0]=%h", DUV.U_RAM.din, DUV.U_RAM.ram_array[0]);
    assert(ovalid==1);
    ivalid = 0;
    @(posedge clk); #1;
    oready = 1;
    @(posedge clk) #1;
    oready = 0;
    assert(ovalid==0);
    // now write four values
    din = 8'h21;
    ivalid = 1;
    @(posedge clk) #1;
    din = 8'h22;
    @(posedge clk) #1;
    din = 8'h33;
    @(posedge clk) #1;
    din = 8'h44;
    @(posedge clk) #1
    assert (iready==1);
    ivalid = 0;
    assert(iready==1);
    ivalid = 0;
    // now read them back out
    oready = 1;
    repeat (2) @(posedge clk); #1;
    assert(iready==1 && ovalid==1);
    repeat(2) @(posedge clk) #1;
    oready = 0;
    @(posedge clk) #1;
    // write another single value and read it back out
    din = 8'h55;
    ivalid = 1;
    @(posedge clk) #1;
    ivalid = 0;
    @(posedge clk) #1;
    oready = 1;
    @(posedge clk) #1;
    oready = 0;
    assert(ovalid == 0); // should be empty
    // now try to read and write during the same cycle
    din = 8'h66;
    ivalid = 1;  // write '66'
    oready = 1;  // try to read
    while (iready)  // look for iready to drop after we read it
      begin
        @(posedge clk) #1;
      end
    ivalid = 0;
    repeat (5) @(posedge clk); #1;
    $display("din=%h ram_array[0]=%h", DUV.U_RAM.din, DUV.U_RAM.ram_array[0]);
    $stop;
    
  end
endmodule
    