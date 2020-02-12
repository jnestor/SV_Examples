module mux4 (input logic d0, d1, d2, d3,
             input logic [1:0] sel,
             output logic      y );
   
   always_comb
     case (sel)
       2'd0 : y = d0;
       2'd1 : y = d1;
       2'd2 : y = d2;
       2'd3 : y = d3;
       default : y = 0;
     endcase
   
endmodule
