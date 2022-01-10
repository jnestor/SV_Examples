//-----------------------------------------------------------------------------
// Module Name   : clock_example_f - functional coded digital clock
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jan 2022
//-----------------------------------------------------------------------------
// Description   : Simple digital clock for an FPGA board.  This design is built
// functionally using an always_ff block
//-----------------------------------------------------------------------------
module clock_example_f (
    input logic clk, rst, adv_hr, adv_min,
    output logic [3:0] h1, h0, m1, m0, s1, s0,
    output logic pm
    );

    logic s_enb;  // seconds enable

    rate_enb #(.RATE_HZ(1)) (.clk, .rst, .clr(1'b0), .enb_out(s_enb));

    always_ff @(posedge clk) begin
        if (rst) begin
            {h1,h0,m1,m0,s1,s0} <= 24'd00_00_00_00;
            pm <= 0;
        end
        else if (s_enb) begin
            if (s0 == 4'd9) begin
                s0 <= 4'd0;
                if (s1 == 4'd5) begin
                    s1 <= 4'd0;
                    if (m0 == 4'd9) begin
                        m0 <= 0;
                        if (m1 == 4'd5) begin
                            m1 <= 4'd0;
                            if ({h1,h0} == 8'd12) begin
                                {h1,h0} <= 8'd10;
                                pm <= !pm;
                            end
                            else if (h0 == 4'd9) begin
                                h0 <= 0;
                                h1 <= h1 + 4'd1;
                            end
                            else h0 <= h0 + 4'd1;
                        end
                        else m1 <= m1 + 4'd1;
                    end
                    else m0 <= m0 + 4'd1;
                end
                else s1 <= s1 + 4'd1;
            end
            else s0 <= s0 + 4'd1;
        end
    end

endmodule
