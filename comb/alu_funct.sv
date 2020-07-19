//-----------------------------------------------------------------------------
// Module Name   : alu_funct
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2020
//-----------------------------------------------------------------------------
// Description   : Functional description of ALU as described in
// Harris & Harris DDCA (originally in Patterson & Hennessey CoD).
// Not suitable for synthesis due to poor resource sharing
//-----------------------------------------------------------------------------

module alu_funct #(parameter W=32])
	              (input logic [2:0]   f,
		           input logic [W-1:0] a, b,
		           output logic [31:0] result,
		           output logic 	   zero);

    always_comb begin
	    case (f)
	        3'b000 : result = a & b; // AND
	        3'b001 : result = a | b; // OR
	        3'b010 : result = a + b; // ADD
	        3'b110 : result = a - b; // SUBTRACT
	        3'b111 : if (a < b) result = { {(W-1){1'b0}}, 1'b1 };
                     else result = '0; //SLT
	        default : result = '0;
	    endcase
	    zero = (result == '0);
    end
endmodule: alu_funct
