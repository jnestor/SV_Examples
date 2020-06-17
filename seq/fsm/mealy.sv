//-----------------------------------------------------------------------------
// Module Name   : mealy
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Mealy FSM that recognizes the input sequence '1011'
//-----------------------------------------------------------------------------

module mealy( input logic clk, rst, sd,
              output logic pf );

    typedef enum logic [1:0] {
      A=2'b00, F1=2'b01, F10=2'b10, F101=2'b11
    } states_t;

  states_t state, next;

  always_ff @(posedge clk)
    if (rst) state <= R;
    else     state <= ns;

  always_comb
    begin
      pf = 1'b0;  // default output value
      next = R;   // default ns: return to R on error
      unique case (state)
        R:
          if (sd==1)  next = F1;
          else        next = R;
        F1:
          if (sd==0)  next = F10;
          else        next = F1;
        F10:
          if (sd==1)  next = F101;
          else        next = R;
        F101:
          if (sd==1) begin
            pf = 1'b1;
            next = R;
          end
          else next = F10;
      endcase
    end
endmodule
