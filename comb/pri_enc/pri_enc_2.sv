// alternative approach: use a loop

module pri_enc_2(input  logic [7:0] a,
                 output logic [3:0] y,
                 output logic idle);

always_comb begin
    idle = 1;
    y = 3'd0; // default output value
    for (int i = 7; i >=0; i--)
      begin
          if (a[i])
            begin
                y = i;
                idle = 0;
                break;
            end
      end
end

endmodule
