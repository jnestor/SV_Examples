module shift_arith #parameter(W=32) (
    input  signed logic [W-1:0] a,
    input logic dir,
    input logic [$clog2(W)-1:0] shamt,
    output signed logic [W-1:0] y
    );

    always_comb begin
        if (dir) y = a << shamt;
        else y = a >>> shamt; // arithmetic shift copies sign?
    end
