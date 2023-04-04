//-----------------------------------------------------------------------------
// Module Name   : dregre
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d register with synchronous reset and enable
//-----------------------------------------------------------------------------

module dregre #(parameter W=4) (
    input logic clk, rst, enb,
    input logic [W-1:0] d,
    output logic [W-1:0] q
    );

    always_ff @(posedge clk) begin
        if (rst) q <= '0;
        else if (enb) q <= d;
    end

endmodule: dregre
