//-----------------------------------------------------------------------------
// Module Name   : edge_det_enb - edge detect with enable
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : Detect rising and falling edges - susceptible to noise
//                 this version only samples when enb=1
//-----------------------------------------------------------------------------

module edge_det_enb(
    input logic clk, enb, d_in,
    output logic r_edge, f_edge
    );

    logic q1, q2;

    always_ff @(posedge clk) begin
        if (enb) begin
            q1 <= d_in;
            q2 <= q1;
        end
    end

    assign r_edge = !q2 && q1;
    assign f_edge = q2 && !q1;

endmodule: edge_det_enb
