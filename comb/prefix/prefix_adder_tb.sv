module prefix_adder_tb;
    logic [15:0] a, b;
    logic cin;
    logic [15:0] sum;

    prefix_adder DUV(.a, .b, .cin, .sum);

    initial begin
        a = 16'b0000_0000_0000_0000;
        b = 16'b0000_0000_0000_0000;
        cin = 0; #10;
        //a = 16'b0000_0000_0000_0001;
        #10;
        cin = 1; #10

        b = 16'b0000_0000_0000_0001;

        #10;
        b = 16'b0000_0000_0000_0011;
        #10;
        b = 16'b0000_0000_0000_0111;
        #10;
        b = 16'b0000_0000_0000_1111;
        #10;
        b = 16'b0000_0000_0001_1111;
        #10;
        b = 16'b0000_0000_0011_1111;
        #10;
        b = 16'b0000_0000_0111_1111;
        #10;
        b = 16'b0000_0000_1111_1111;
        #10;
        b = 16'b0000_0001_1111_1111;
        #10;
        b = 16'b0000_0011_1111_1111;
        #10;
        b = 16'b0000_0111_1111_1111;
        #10;
        b = 16'b0000_1111_1111_1111;
        #10;
        b = 16'b0001_1111_1111_1111;
        #10;
        b = 16'b0011_1111_1111_1111;
        #10;
        b = 16'b0111_1111_1111_1111;
        #10;
        b = 16'b1111_1111_1111_1111;
        #10;
        a=16'h1234;
        b=16'h4321;
        #10;
        a=16'hafde;
        b=16'h0005;
        #10;
        $stop;
    end

endmodule
