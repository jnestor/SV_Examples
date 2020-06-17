//-----------------------------------------------------------------------------
// Module Name   : div
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Integer divider.  Probably this module does not
// play well with synthesis.
//-----------------------------------------------------------------------------

module div #(parameter W=4)
	        (input logic [W-1:0] 	a, b,
		     output logic [W-1:0] q, r);

    always @(posedge clk) begin
	    q = a / b;
	    r = a % b;
    end

endmodule: div
