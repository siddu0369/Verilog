module adder(input a,
    input b,
    output s
);
    assign s =  a^b;
endmodule

module carry (
    input a,
    input b,
    output y
);
    assign y = a&b;
endmodule

// Top module

module half_adder;
    reg a = 1;
    reg b = 1;

    wire s, y;

    adder u1(a, b, s);
    carry u2(a, b, y);

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, half_adder);   // or your top module name
        #1
        $monitor("sum = %b, carry = %b", s, y);
        
        #1 a = 0;
        #1 b = 1;
        $finish;
    end
endmodule