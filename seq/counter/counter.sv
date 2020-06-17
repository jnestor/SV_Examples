//-----------------------------------------------------------------------------
// Module Name   : counter
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Basic binary counter with enable & sync. reset
//-----------------------------------------------------------------------------


// counter - basic binary counter

module  counter (#parameter W=4)
                (input logic clk, rst, enb,
                 output logic [W-1:0] q);

    always_ff @(posedge clk)
        if (rst)      q <= '0;
        else if (enb) q <= q + 1;

endmodule: counter
