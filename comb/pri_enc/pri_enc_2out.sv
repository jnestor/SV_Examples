// alternative approach: use a loop

module pri_enc_2(input  logic [7:0] a,
    output logic [3:0] y1, y2,
    output logic idle1, idle2);

    always_comb begin
        idle1 = 1;
        idle2 = 1;
        y = 3'd0; // default output value
        for (int i = 7; i >=0; i--)
        begin
            if (a[i])
            begin
                if (idle1)
                begin
                    y1 = i;
                    idle1 = 0;
                end
                else if (idle2)
                begin
                    y2 = i;
                    idle2 = 0;
                    break;  // no need to look further
                end
            end
        end
    end

endmodule
