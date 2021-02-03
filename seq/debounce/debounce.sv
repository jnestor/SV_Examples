
//-----------------------------------------------------------------------------
// Module Name   : debounce
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Feb 2021
//-----------------------------------------------------------------------------
// Description   : Debouncer patterned after "Debounce Logic Circuit
// (with VHDL example)" on the Digikey EEWiki
//-----------------------------------------------------------------------------

module debounce(input logic clk, pb, rst, output logic pb_debounced);
   parameter CLKPD_NS = 10;
   parameter CLKFREQ = 1_000_000_000 / CLKPD_NS;    // clock frequency in Hertz
   parameter DEBOUNCE_MS = 10;  // desired debounce delay in milliseconds
   localparam CTRBITS = $clog2(DEBOUNCE_MS*CLKFREQ/1000);

   logic pb_q1, pb_q2, pb_edge, carry;
   logic [CTRBITS:0] count;  // use extra bit as carry out

   assign carry = count[CTRBITS];

   always_ff @(posedge clk)
     begin
       if (rst)
         begin
           pb_q1 <= 0;
           pb_q2 <= 0;
           pb_debounced <= 0;
         end
       else
         begin
           pb_q1 <= pb;
           pb_q2 <= pb_q1;
           if (carry) pb_debounced <= pb_q2;
        end
    end

   assign pb_edge = pb_q1 ^ pb_q2;  // rising or falling edge on pb

   always_ff @(posedge clk)
     if (pb_edge) count <= '0;
     else if (!carry) count <= count + 1;

endmodule: debounce
