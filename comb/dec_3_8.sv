//-----------------------------------------------------------------------------
// Module Name   : dec_3_8 - 3-8 binary decoder
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : 3-8 binary decoder with active high output
//-----------------------------------------------------------------------------

module dec_3_8(
    input logic [2:0] a,
    output logic [7:0] y
    );

    always_comb begin
        case (a)
            3'd0: y = 8'b00000001;
            3'd1: y = 8'b00000010;
            3'd2: y = 8'b00000100;
            3'd3: y = 8'b00001000;
            3'd4: y = 8'b00010000;
            3'd5: y = 8'b00100000;
            3'd6: y = 8'b01000000;
            3'd7: y = 8'b10000000;
            default: y = 4'b00000000;
        endcase
    end

endmodule: dec_3_8
