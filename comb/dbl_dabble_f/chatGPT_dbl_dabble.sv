module double_dabble_converter(
    input logic [7:0] binary_input,
    output logic [11:0] bcd_output
);

logic [3:0] dabble_reg [8:0];

// Initialize dabble register with binary input
always_comb begin
    dabble_reg[0] = binary_input;
end

// Double dabble algorithm
for (int i = 1; i < 9; i++) begin
    for (int j = 0; j < 4; j++) begin
        if (dabble_reg[i-1][3] == 1 || (j > 0 && dabble_reg[i][j-1] == 1)) begin
            dabble_reg[i][j] = 1;
        end
    end
end

// Convert to BCD
always_comb begin
    bcd_output[11:8] = {dabble_reg[8][3], dabble_reg[8][2], dabble_reg[8][1], dabble_reg[8][0]};
    bcd_output[7:4] = {dabble_reg[7][3], dabble_reg[7][2], dabble_reg[7][1], dabble_reg[7][0]};
    bcd_output[3:0] = {dabble_reg[6][3], dabble_reg[6][2], dabble_reg[6][1], dabble_reg[6][0]};
end

endmodule