module oneBitComp(
    input wire a,
    input  wire b,
    output wire       a_gt_b,
    output wire       a_eq_b,
    output wire       a_lt_b
);
     xnor(a_eq_b, a, b);
     and( a_lt_b , ~a , b );
     and( a_gt_b , a , ~b );
endmodule

module oneBitComp_tb;
	reg  a, b;
	wire a_gt_b0,a_eq_b0,a_lt_b0;
    oneBitComp dut (
        .a(a),
        .b(b),
        .a_gt_b(a_gt_b0),
        .a_eq_b(a_eq_b0),
        .a_lt_b(a_lt_b0)
    );
    integer i;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, oneBitComp_tb);
        $monitor("a = %b, b = %b, a_gt_b = %b, a_eq_b = %b, a_lt_b = %b",a,b,a_gt_b0,a_eq_b0,a_lt_b0);
        for(i = 0; i <=3; i = i + 1) begin
            {a,b} = i;
            #5;
        end
        #20
        $finish;
    end
	endmodule
