//-----------------------------------------------------------------------------
// Module Name   : seven_seg_n: Seven-segment decoder with active low outputs
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : BCD seven-segment decoder with active low outputs.
// Segments are ordered as follows: segs_n[6]=g, segs_n[0]=a
//-----------------------------------------------------------------------------

module seven_seg_n(
		 input logic [3:0]  data,
		 output logic [6:0] segs_n;  // ordered g(6) - a(0)
		 );

   always_comb
     case (data)     //  gfedcba
       4'd0: segs_n = 7'b1000000;
       4'd1: segs_n = 7'b1111001;
       4'd2: segs_n = 7'b0100100;
       4'd3: segs_n = 7'b0110000;
       4'd4: segs_n = 7'b0011001;
       4'd5: segs_n = 7'b0010010;
       4'd6: segs_n = 7'b0000010;
       4'd7: segs_n = 7'b1111000;
       4'd8: segs_n = 7'b0000000;
       4'd9: segs_n = 7'b0010000;
       default: segs_n = 7'b1111111;
     endcase
endmodule: seven_seg_n
+-
