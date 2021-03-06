//-----------------------------------------------------------------------------
// Module Name   : pri_enc_4_2
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 4-2 Priority Encoder
//-----------------------------------------------------------------------------

module pri_enc(input logic a3, a2, a1, a0,
               output logic [1:0] y,
               output logic none);
  always_comb
    begin
      none = 0;
      y = 2'd0;
      if (a3) y = 2'd3;
      else if (a2) y = 2'd2;
      else if (a1) y = 2'd1;
      else if (a0) y = 2'd0;
      else none = 1;
    end

endmodule
