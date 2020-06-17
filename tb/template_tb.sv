//-----------------------------------------------------------------------------
// Module Name   : template_tb
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : Jun 2020
//-----------------------------------------------------------------------------
// Description   : Template file for a stimulus-only testbench
// Customoize as appropriate for your design
//-----------------------------------------------------------------------------

module template_tb ( input logic clk, rst /* , add connections */  );

    initial begin
        $timeformat(-9, 0, "ns", 6);
        $monitor( /* add signals to monitor in console */ );
        rst = 1;
        @(posedge clk) #1;
        rst = 0;

       // add procedural statements here --
       //  -- assignment statemets to drive DUV inputs
       //  -- timing control statements to sequence

       $stop;  // suspend simulation (use $finish to exit)
    end

endmodule: template_tb
