//-----------------------------------------------------------------------------
// Module Name   : counter_rc_hrs - 2 digit mod 12 bcd "hour" counter
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jan 2022
//-----------------------------------------------------------------------------
// Description   : 2-digit BCD counter mod 12 - use for counting hours
//                 using a 12-hour clock.  Includes a "PM" output that toggles
//                 each time the clock rolls over 11:59->12:00
//-----------------------------------------------------------------------------

module counter_hrs (
    input logic clk, rst, enb,
    output logic [3:0] h1, h0,
    output logic pm
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            h1 <= 4'd1;
            h0 <= 4'd2;
            pm <= 1'b0;
        end
        else if (enb) begin
            if ((h1==4'd1) && h0==4'd1) pm <= !pm;
            if ((h1==4'd1) && (h0==4'd2)) begin
                h1 <= 4'd0;
                h0 <= 4'd1;
            end
            else if ((h1==4'd0) && (h0==4'd9)) begin
                h1 <= 4'd1;
                h0 <= 4'd0;
            end
            else h0 <= h0 + 4'd1;
        end
    end

endmodule
