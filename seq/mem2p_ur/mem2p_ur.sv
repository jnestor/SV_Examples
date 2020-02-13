//-----------------------------------------------------------------------------
// Title         : <title>
// Project       : <project>
//-----------------------------------------------------------------------------
// File          : mem2p_ur.sv
// Author        : John Nestor  <nestorj@nestorj-mbpro-15.home>
// Created       : 13.02.2020
// Last modified : 13.02.2020
//-----------------------------------------------------------------------------
// Description :
// <description>
//-----------------------------------------------------------------------------
// Copyright (c) 2020 by <company> This model is the confidential and
// proprietary property of <company> and the possession or use of this
// file requires a written license from <company>.
//------------------------------------------------------------------------------
// Modification history :
// 13.02.2020 : created
//-----------------------------------------------------------------------------

module fifo_ram #(parameter W=8, D=4, localparam DW=$clog2(D))
  (input logic clk, we,
   input logic [W-1:0] din,
   input logic [DW-1:0] rdaddr, wraddr,
   output logic [W-1:0] dout);

  logic [W-1:0] ram_array [D-1:0];
  
  always_ff @(posedge clk)
    if (we) ram_array[wraddr] = din;
  
  assign dout = ram_array[rdaddr];
  
endmodule
                                       
                                        
                                        
