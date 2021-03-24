//-----------------------------------------------------------------------------
// Module Name   : edge_det - edge detector with enable
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Mar 2021
//-----------------------------------------------------------------------------
// Description   : Detect rising and falling edges - susceptible to noise
//-----------------------------------------------------------------------------

module edge_det(
    input logic clk, d_in,
    output logic r_edge, f_edge
    );

    logic q1, q2;

    always_ff @(posedge clk) begin
        q1 <= d_in;
        q2 <= q1;
    end

    assign r_edge = !q2 && q1;
    assign f_edge = q2 && !q1;

endmodule: edge_det
