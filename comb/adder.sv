module adder #(parameter W=8)
   (input logic [W-1:0] a, b,
    output logic [W-1:0] y);
   
   assign y = a + b;
   
endmodule
