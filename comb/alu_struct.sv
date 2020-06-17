//-----------------------------------------------------------------------------
// Module Name   : alu_struct
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Structural description of ALU as described in
// Harris & Harris DDCA (originally in Patterson & Hennessey CoD).
// Uses a single adder with added subtraction logic
//-----------------------------------------------------------------------------

module alu_struct #(parameter W=32)
                   (input logic [2:0] ctl, input logic [W-1:0] a, b,
                    output logic  [W-1:0] result, output logic zero);

   logic [W-1:0] bx, bx_and, bx_or, s, slt_result;

   assign bx = ctl[2] ? ~b : b;
   assign bx_and = a & bx;
   assign bx_or = a | bx;
   assign s = a + b + ctl[2];
   assign slt_result = {{(W-1){1'b0}},s[W-1]};

   mux4 #(.W(W)) U_MUX4 (.d0(bx_and), .d1(bx_or), .d2(s), .d3(slt_result),
          .sel(ctl[1:0]), .y(result));

   assign zero = (result == '0);

endmodule: alu_struct
