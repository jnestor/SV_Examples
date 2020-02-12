module alu_funct(input logic [2:0] f, 
		 input logic [31:0]  a, b, 
		 output logic [31:0] result, 
		 output logic 	     zero);
   
   always_comb
     begin
	case (f)
	  3'b000 : result = a & b; // AND
	  3'b001 : result = a | b; // OR
	  3'b010 : result = a + b; // ADD
	  3'b110 : result = a - b; // SUBTRACT
	  3'b111 : if (a < b) result = 32'd1; 
          else result = 32'd0; //SLT      
	  default : result = 32'h0;
	endcase
	zero = (result == 32'd0);
     end
endmodule
