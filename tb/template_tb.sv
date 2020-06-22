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

        // add assignment statements to initialize DUV inupts

        // reset DUV
        rst = 1;
        @(posedge clk) #1;
        rst = 0;

       // add assignment statements to update DUV inputs

       // add timing control statements to delay

       // add assignment statements to update DUV inputs

       //  add timing control to delay, etc.

       $display("Simulation complete");
       $stop;  // suspend simulation (use $finish to exit)
    end

endmodule: template_tb
