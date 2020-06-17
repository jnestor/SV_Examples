//-----------------------------------------------------------------------------
// Module Name   : ringctr4
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 4-bit ring counter with enable & sync. reset
//-----------------------------------------------------------------------------

module ringctr4(input logic clk, rst, enb, s_in
                output logic [3:0] q);

    always_ff @(posedge clk)
        if (rst) q <= 4'b0001;
        else if (enb) q <= { s_in, q[3:1] };

endmodule
