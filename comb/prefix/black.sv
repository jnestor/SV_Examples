module black(
    input logic pl, pr, gl, gr
    output logic po, go
    );

    assign po = pl & pr;
    assign go = gl | (pl & gr);

endmodule
