//-----------------------------------------------------------------------------
// Title         : fifo_sr - Synchronous shift register FIFO
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// File          : sync_fifo.sv
// Author        : John Nestor
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description :
// A synchronous FIFO using a traditional interface with full and empty
// status outputs.  DEPTH can be any arbitrary integer
//-----------------------------------------------------------------------------

module fifo_sr #(parameter WIDTH=8, DEPTH=4)
  (input logic clk, rst, enqueue, dequeue,
   input logic [WIDTH-1:0] di,
   output logic [WIDTH-1:0] dout,
   output logic full, empty);

    logic [0:DEPTH][WIDTH-1:0] data;
    logic [0:DEPTH] elmt_full;

    assign data[0]] = di;
    assign elmt_full[0] = 0;
    assign full = elmt_full[1];
    assign empty = !elmt_full[DEPTH];

    genvar i;
    generate
        for (i=0; i < DEPTH; i++) begin
            sr_fifo_elmt #(.WIDTH(WIDTH)) U_ELMT
                (.clk, .rst, .enqueue, .dequeue,
                         .di_global(.di), .di_l(data[i]),
                         .dout(data[i+1]), .full(elmt_full[i+1])
                        );
        end
    endgenerate

endmodule: fifo_sr
