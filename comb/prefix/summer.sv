module summer(
    input logic a, b, c,
    output logic sum
    );

    assign sum = a ^ b ^ c;

endmodule
