module cmp_mag #(parameter W=8)
  (input logic [W-1:0] a, b,
   output logic a_gt_b);

  assign a_gt_b = (a > b);

endmodule
