module cmp_eq #(parameter W=8)
   (input logic [W-1:0] a, b,
    output logic a_eq_b);
   
   assign a_eq_b (a == b);
   
endmodule
