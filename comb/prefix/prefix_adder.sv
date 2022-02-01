//-----------------------------------------------------------------------------
// Module Name   : prefix_adder - 16-bit prefix adder
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2022
//-----------------------------------------------------------------------------
// Description   : Structural description of a 16-bit prefix adder
// as described in Ch. 5 of Harris & Harris DDCA
//-----------------------------------------------------------------------------

module prefix_adder(
    input logic [15:0] a, b,
    input logic cin,
    output logic [15:0] sum
    );

    logic [15:0] p, g;

    assign p = a | b;
    assign g = a & b;



    logic p_14_13, p_12_11, p_10_9, p_8_7, p_6_5, p_4_3, p_2_1, p_0_m1;
    logic g_14_13, g_12_11, g_10_9, g_8_7, p_6_5, g_4_3, g_2_1, g_0_m1;
    logic p_14_11, p_13_11, p_10_7, p_9_7, p_6_3, p_5_3, p_2_m1, p_1_m1;
    logic g_14_11, g_13_11, g_10_7, g_9_7, g_6_3, g_5_3, g_2_m1, g_1_m1;
    logic p_14_7, p_13_7, p_12_7, p_11_7, p_6_m1, p_5_m1, p_4_m1, p_3_m1;
    logic g_14_7, g_13_7, g_12_7, g_11_7, g_6_m1, g_5_m1, g_4_m1, g_3_m1;
    logic p_14_m1, p_13_m1, p_12_m1, p_11_m1, p_10_m1, p_9_m1, p_8_m1, p_7_m1;
    logic g_14_m1, g_13_m1, g_12_m1, g_11_m1, g_10_m1, g_9_m1, g_8_m1, g_7_m1;

    // first tier of black cells
    black U_14_13(.pl(p[14]), .gl(g[14]), .pr(p[13]), .gr(g[13]), .po(p_14_13), .go(g_14_13));
    black U_12_11(.pl(p[12]), .gl(g[12]), .pr(p[11]), .gr(g[11]), .po(p_12_11), .go(g_12_11));
    black U_10_9(.pl(p[10]), .gl(g[10]), .pr(p[9]), .gr(g[9]), .po(p_10_9), .go(g_10_9));
    black U_8_7(.pl(p[8]), .gl(g[8]), .pr(p[7]), .gr(g[7]), .po(p_8_7), .go(g_8_7));
    black U_6_5(.pl(p[6]), .gl(g[6]), .pr(p[5]), .gr(g[5]), .po(p_6_5), .go(g_6_5));
    black U_4_3(.pl(p[4]), .gl(g[4]), .pr(p[3]), .gr(g[3]), .po(p_4_3), .go(g_4_3));
    black U_2_1(.pl(p[2]), .gl(g[2]), .pr(p[1]), .gr(g[1]), .po(p_2_1), .go(g_2_1));
    black U_0_m1(.pl(p[0]), .gl(g[0]), .pr(1'b0), .gr(cin), .po(p_0_m1), .go(g_0_m1));

    // second tier of black cells
    black U_14_11(.pl(p_14_13), .gl(g_14_13), .pr(p_12_11), .gr(g_12_11), .po(p_14_11),.go(g_14_11));
    black U_13_11(.pl(p[13]), .gl(g[13]), .pr(p_12_11), .gr(g_12_11), .po(p_13_11), .go(g_13_11));

    black U_10_7(.pl(p_10_9), .gl(g_10_9), .pr(p_8_7), .gr(g_8_7), .po(p_10_7), .go(g_10_7));
    black U_9_7(.pl(p[9]), .gl(g[9]), .pr(p_8_7), .gr(g_8_7), .po(p_9_7), .go(g_9_7));

    black U_6_3(.pl(p_6_5), .gl(g_6_5), .pr(p_4_3), .gr(g_4_3), .po(p_6_3), .go(g_6_3));
    black U_5_3(.pl(p[5]), .gl(g[9]), .pr(p_4_3), .gr(g_4_3), .po(p_5_3), .go(g_5_3));

    black U_2_m1(.pl(p_2_1), .gl(g_2_1), .pr(p_0_m1), .gr(g_0_m1), .po(p_2_m1), .go(g_2_m1));
    black U_1_m1(.pl(p[1]), .gl(g[1]), .pr(p_0_m1), .gr(g_0_m1), .po(p_1_m1), .go(g_1_m1));

    // third tier of black cells
    black U_14_7(.pl(p_14_11), .gl(g_14_11), .pr(p_10_7), .gr(g_10_7), .po(p_14_7), .go(g_14_7));
    black U_13_7(.pl(p_13_11), .gl(g_13_11), .pr(p_10_7), .gr(g_10_7), .po(p_13_7), .go(g_13_7));
    black U_12_7(.pl(p_12_11), .gl(g_12_11), .pr(p_10_7), .gr(g_10_7), .po(p_12_7), .go(g_12_7));
    black U_11_7(.pl(p[11]), .gl(g[11]), .pr(p_10_7), .gr(g_10_7), .po(p_11_7), .go(g_11_7));

    black U_6_m1(.pl(p_6_3), .gl(g_6_3), .pr(p_2_m1), .gr(g_2_m1), .po(p_6_m1), .go(g_6_m1));
    black U_5_m1(.pl(p_5_3), .gl(g_5_3), .pr(p_2_m1), .gr(g_2_m1), .po(p_5_m1), .go(g_5_m1));
    black U_4_m1(.pl(p_4_3), .gl(g_4_3), .pr(p_2_m1), .gr(g_2_m1), .po(p_4_m1), .go(g_4_m1));
    black U_3_m1(.pl(p[3]), .gl(g[3]), .pr(p_2_m1), .gr(g_2_m1), .po(p_3_m1), .go(g_3_m1));

    // fourth tier of black cells
    black U_14_m1(.pl(p_14_7), .gl(g_14_7), .pr(p_6_m1), .gr(g_6_m1), .po(p_14_m1), .go(g_14_m1));
    black U_13_m1(.pl(p_13_7), .gl(g_13_7), .pr(p_6_m1), .gr(g_6_m1), .po(p_13_m1), .go(g_13_m1));
    black U_12_m1(.pl(p_12_7), .gl(g_12_7), .pr(p_6_m1), .gr(g_6_m1), .po(p_12_m1), .go(g_12_m1));
    black U_11_m1(.pl(p_11_7), .gl(g_11_7), .pr(p_6_m1), .gr(g_6_m1), .po(p_11_m1), .go(g_11_m1));
    black U_10_m1(.pl(p_10_7), .gl(g_10_7), .pr(p_6_m1), .gr(g_6_m1), .po(p_10_m1), .go(g_10_m1));
    black U_9_m1(.pl(p_9_7), .gl(g_9_7), .pr(p_6_m1), .gr(g_6_m1), .po(p_9_m1), .go(g_9_m1));
    black U_8_m1(.pl(p_8_7), .gl(g_8_7), .pr(p_6_m1), .gr(g_6_m1), .po(p_8_m1), .go(g_8_m1));
    black U_7_m1(.pl(p[7]), .gl(g[7]), .pr(p_6_m1), .gr(g_6_m1), .po(p_7_m1), .go(g_7_m1));

    // final stage of xors to generate sum
    summer U_SUM15(.a(a[15]), .b(b[15]), .c(g_14_m1), .sum(sum[15]));
    summer U_SUM14(.a(a[14]), .b(b[14]), .c(g_13_m1), .sum(sum[14]));
    summer U_SUM13(.a(a[13]), .b(b[13]), .c(g_12_m1), .sum(sum[13]));
    summer U_SUM12(.a(a[12]), .b(b[12]), .c(g_11_m1), .sum(sum[12]));
    summer U_SUM11(.a(a[11]), .b(b[11]), .c(g_10_m1), .sum(sum[11]));
    summer U_SUM10(.a(a[10]), .b(b[10]), .c(g_9_m1), .sum(sum[10]));
    summer U_SUM9(.a(a[9]), .b(b[9]), .c(g_8_m1), .sum(sum[9]));
    summer U_SUM8(.a(a[8]), .b(b[8]), .c(g_7_m1), .sum(sum[8]));
    summer U_SUM7(.a(a[7]), .b(b[7]), .c(g_6_m1), .sum(sum[7]));
    summer U_SUM6(.a(a[6]), .b(b[6]), .c(g_5_m1), .sum(sum[6]));
    summer U_SUM5(.a(a[5]), .b(b[5]), .c(g_4_m1), .sum(sum[5]));
    summer U_SUM4(.a(a[4]), .b(b[4]), .c(g_3_m1), .sum(sum[4]));
    summer U_SUM3(.a(a[3]), .b(b[3]), .c(g_2_m1), .sum(sum[3]));
    summer U_SUM2(.a(a[2]), .b(b[2]), .c(g_1_m1), .sum(sum[2]));
    summer U_SUM1(.a(a[1]), .b(b[1]), .c(g_0_m1), .sum(sum[1]));
    summer U_SUM0(.a(a[0]), .b(b[0]), .c(cin), .sum(sum[0]));

endmodule
