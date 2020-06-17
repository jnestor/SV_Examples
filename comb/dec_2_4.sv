//-----------------------------------------------------------------------------
// Module Name   : dec_2_4
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : 2-4 binary decoder
//-----------------------------------------------------------------------------

module dec_2_4 (input logic [1:0] a,
                output logic y0, y1, y2, y3);
    always_comb begin
        y0 = 0;
	    y1 = 0;
	    y2 = 0;
	    y3 = 0;
	    case (a)
            2'd0 : y0 = 1;
            2'd1 : y1 = 1;
            2'd2 : y2 = 1;
            2'd3 : y3 = 1;
	    endcase // case (a)
    end
endmodule: dec_2_4
