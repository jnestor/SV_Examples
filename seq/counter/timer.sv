//-----------------------------------------------------------------------------
// Module Name   : timer
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : timer - counts down to a parameterized deadline
// in clock cycles and asserts done when DEADLINE has elapsed
//-----------------------------------------------------------------------------

module timer(input logic clk, rst, start,
             output logic done);

    parameter DEADLINE = 100;  // in clock cycles
    localparam DW = $clog2(DEADLINE);

    logic [W-1:0] q;

    assign done = (q == '0);

    always_ff @(posedge clk) begin
        if (rst)        q <= '0;
        else if (start) q <= DEADLINE - 1;
        else if (!done) q <= q - 1;
    end

endmodule: timer
