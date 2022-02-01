module pg(
   input logic a, b,
   output logic p, g
   );

   assign p = a | b;
   assign g = a & b;

endmodule
