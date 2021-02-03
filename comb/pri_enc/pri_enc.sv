module pri_enc(input logic [7:0] a,
               output logic [3:0] y,
               output logic idle);

always_comb begin
    idle = 0;
    y = 3'd0; // default output value
    if (y[7]) y = 3'd7;
    else if (y[6]) y = 3'd6;
    else if (y[5]) y = 3'd5;
    else if (y[4]) y = 3'd4;
    else if (y[3]) y = 3'd3;
    else if (y[2]) y = 3'd2;
    else if (y[1]) y = 3'd1;
    else if (y[0]) y = 3'd0;
    else idle = 1;
end
