//-----------------------------------------------------------------------------
// Module Name   : sign_xtnd - parameterized sign extension
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jan 2022
//-----------------------------------------------------------------------------
// Description   :
//-----------------------------------------------------------------------------

module sign_xtnd #(parameter W_I=16, W_O=32) (
    logic signed [W_I-1:0] a,
    logic signed [W_O-1:0] h
    );

    localparam W_X = W_O - W_I;

    logic sign;

    assign sign = a[W_I-1];

    assign y = { {W_X{sign}}, a };

endmodule
