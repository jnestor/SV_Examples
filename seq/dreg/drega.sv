//-----------------------------------------------------------------------------
// Module Name   : dregra
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : d register with asynchronous reset
//-----------------------------------------------------------------------------

module drega #(parameter W=4)
              (input logic clk, rst,
               input logic [W-1:0] d,
               output logic [W-1:0] q);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) q <= '0;
        else q <= d;
    end

endmodule: dregra
