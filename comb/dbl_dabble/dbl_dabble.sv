module dbl_dabble(input logic [7:0] b,
                  output logic [3:0] hundreds, tens, ones);

logic [7:0] bs;

always_comb
    begin
        bs = b;
        {hundreds, tens, ones} = 12'h0;
        for (int i=0; i<8; i++)
            begin
                if (ones >= 4'd5) ones = ones + 3;
                if (tens >= 4'd5) tens = tens + 3;
                if (hundreds >= 4'd5) hundreds = hundreds + 3;
                {hundreds, tens, ones, bs} = {hundreds, tens, ones, bs} << 1;
            end
    end

endmodule: dbl_dabble
