module fifo_sr_elmt #(parameter WIDTH=8)
    ( input logic clk, rst, enqueue, dequeue, full_l, full_r,
      input logic [WIDTH-1:0] di_global, di_l,
      output logic [WIDTH-1:0] dout,
      output logic full
    );

    always_ff @(posedge clk)
        if (rst) begin
            dout <= '0;
            full <= 0;
        end
        else if ((enqueue && !dequeue && !full && full_r) ||
                 (enqueue && dequeue && full && !full_l )) begin
            dout <= di_global;
            full <= 1;
        end
        else if (dequeue && full) begin
            dout <= di_l;
            full <= full_l;
        end

endmodule: fifo_sr_elmt
