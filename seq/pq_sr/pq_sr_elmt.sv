module pq_sr_elmt #(parameter KW=4, DW=8, DEPTH=4)
    (input logic clk, rst, enqueue, dequeue,
     input logic [KW-1:0] kg, kl, kr, kout,
     input logic [DW-1:0] dg, dl, dr, dout,
     input logic gtl,
     output logic gto
    );

    parameter logic [KW-1:0] KINF  = '1;

    assign gtr = kg > kout;

    always_ff @(posedge clk) begin
        if (rst) begin
            kout <= KINF;
            dout <= '0;
        end
        else if (enqueue && !dequeue)
            begin
                unique case ({gtl, gtr})
                    2'b00: begin  // both leq -> shift right
                        kout <= kl;
                        dout <= dl;
                    end
                    2'b10: begin // prev stage gt, current stage le1 -> load stage
                        kout <= kg;
                        dout <= dg;
                    end
                endcase
            end
        else if (enqueue && dequeue ) // need to look forward in this case?
            begin
                unique case({gtl, gtr})
                    2'b11: begin
                        kout <= kr;
                        dout <= dr;
                    end
                    2'b10: begin
                        kout <= kg;
                        dout <= dg;
                    end

            end
        else if (!enqueue && dequeue )
            begin
                kout <= kr;
                dout <= dr;
            end
    end
    
endmodule: pq_sr_elmt
