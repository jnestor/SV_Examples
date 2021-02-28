module shift_arith #(parameter W=32) (
    input logic signed  [W-1:0] a,
    //input logic                 dir,
    input logic [$clog2(W)-1:0] shamt,
    output logic signed [W-1:0] y
    );

    always_comb begin
        //if (dir) y = a << shamt;
        y = a >>> shamt; // arithmetic shift copies sign?
    end
endmodule : shift_arith
