module fifo_ram #(parameter W=8, D=4, localparam DW=$clog2(D))
  (input logic clk, we,
   input logic [W-1:0] din,
   input logic [DW-1:0] rdaddr, wraddr,
   output logic [W-1:0] dout);

  logic [W-1:0] ram_array [D-1:0];
  
  always_ff @(posedge clk)
    if (we) ram_array[wraddr] = din;
  
  assign dout = ram_array[rdaddr];
  
endmodule
                                       
                                        
                                        
