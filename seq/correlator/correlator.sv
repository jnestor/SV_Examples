//-----------------------------------------------------------------------------
// Module Name   : correlator
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : Mar 4 2021
//-----------------------------------------------------------------------------
// Description :
// Inputs a sequence of bits of length LEN on d_in and computes the number
// matching bits when compared to a PATTERN of the same length.
// Asserts h_out true when the number of matching bits equals or exceeds
// threshold value HTHRESH.
// Asserts l_out true when the number of matching equals or is less than LTHRESH.
//-----------------------------------------------------------------------------

module correlator #(
    parameter LEN=64, PATTERN=64'b11110000_00001111_11110000_00001111_11110000_00001111_11110000_00001111,
              HTHRESH=54, LTHRESH=10, W=$clog2(LEN)+1
    )
    (
    input logic 	     clk,
    input logic 	     rst,
    input logic 	     enb,
    input logic 	     d_in,
    output logic [W-1:0] csum,
    output logic 	     h_out,
    output logic 	     l_out
    );

   logic [LEN-1:0] 		   shreg, matchv;
   logic [W-1:0] csum_c;

   function [W-1:0] countones ( input logic [LEN-1:0] v );
       logic [W-1:0] count;
       count = 0;
       for (int i=0; i < LEN; i++)
           count = count + v[i];
       return count;
   endfunction


   // shift register shifts from right to left so that oldest data is on
   // the left and newest data is on the right
    always_ff  @(posedge clk) begin
        if (rst) shreg <= '0;
        else if (enb) shreg <= { shreg[LEN-2:0], d_in };
     end


    // register status outputs but don't wait for enb to change
    always_ff @(posedge clk) begin
        if (rst) begin
            csum <= '0;
            h_out <= 0;
            l_out <= 0;
         end
         else begin
             csum <= csum_c;
             h_out <= (csum_c >= HTHRESH);
             l_out <= (csum_c <= LTHRESH);         
         end
      end

   assign csum_c = countones(matchv);

   assign matchv = shreg ^~ PATTERN;

endmodule
