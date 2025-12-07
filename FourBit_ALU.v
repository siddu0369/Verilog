module adder_4bit(input [3:0] A, B, output [3:0] Sum, output Cout);
    assign {Cout, Sum} = A + B;
endmodule

module subtractor_4bit(input [3:0] A, B, output [3:0] Diff, output Bout);
    assign {Bout, Diff} = A - B;
endmodule

module and_4bit(input [3:0] A, B, output [3:0] Out);
    assign Out = A & B;
endmodule

module or_4bit(input [3:0] A, B, output [3:0] Out);
    assign Out = A | B;
endmodule

module not_4bit(input [3:0] A, output [3:0] Out);
    assign Out = ~A;
endmodule

module xor_4bit(input [3:0] A, B, output [3:0] Out);
    assign Out = A ^ B;
endmodule

module shift_4bit(input [3:0] A, input shift, input [1:0] pos, output [3:0] Out);
    assign Out = shift ? (A << pos) : (A >> pos);
endmodule

module ALU0(
    input  [3:0] A, B,
    input  [2:0] Sel,
    output reg [3:0] Out,
    output reg Cout,
    output reg zeroFlg,
    output reg signFlg, 
    output reg overflowFlg,
    output reg carryFlg,
    output reg ParityFlg
);

    wire [3:0] Sum, Diff, andOut, orOut, notOut, xorOut, shiftOut;
    wire Carry, Borrow;

    adder_4bit     a1(A, B, Sum, Carry);
    subtractor_4bit s1(A, B, Diff, Borrow);
    and_4bit       an1(A, B, andOut);
    or_4bit        o1(A, B, orOut);
    not_4bit       n1(A, notOut);
    xor_4bit       x1(A, B, xorOut);
    shift_4bit     sh1(A, 1'b1, 2'b01, shiftOut);

    always @(*) begin
        case (Sel)
            3'b000: begin Out = Sum;   Cout = Carry;  end
            3'b001: begin Out = Diff;  Cout = Borrow; end
            3'b010: begin Out = andOut; Cout = 0; end
            3'b011: begin Out = orOut;  Cout = 0; end
            3'b100: begin Out = notOut; Cout = 0; end
            3'b101: begin Out = xorOut; Cout = 0; end
            3'b110: begin Out = shiftOut; Cout = 0; end
            default: begin Out = 4'b0; Cout = 0; end
        endcase
    end
    always @(*) begin
        zeroFlg = ~(|Out);
        signFlg = Out[3];
        overflowFlg = (Sel == 3'b000) ? ((A[3] == B[3]) && (Out[3] != A[3])) :
                       (Sel == 3'b001) ? ((A[3] != B[3]) && (Out[3] != A[3])) : 0;
        carryFlg = Cout;
        ParityFlg = ~(^Out);
        end

endmodule


`timescale 1ns/1ps

module ALU_tb;

    reg [3:0] A, B;
    reg [2:0] Sel;

    wire [3:0] Out;
    wire Cout;
    wire zeroFlg, signFlg, overflowFlg, carryFlg, ParityFlg;
    // Instantiate ALU
    ALU0 alu0 (
        .A(A),
        .B(B),
        .Sel(Sel),
        .Out(Out),
        .Cout(Cout),
        .zeroFlg(zeroFlg),
        .signFlg(signFlg),
        .overflowFlg(overflowFlg),
        .carryFlg(carryFlg),
        .ParityFlg(ParityFlg)   
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ALU_tb);

        $monitor("%0t | A=%b  B=%b  Sel=%b  => Out=%b  Cout=%b  zeroFlg=%b  signFlg=%b  overflowFlg=%b  carryFlg=%b  ParityFlg=%b",
                 $time, A, B, Sel, Out, Cout, zeroFlg, signFlg, overflowFlg, carryFlg, ParityFlg);

        // Inputs
        A = 4'b1100; 
        B = 4'b1010;

        Sel = 3'b000; // ADD
        #10;

        Sel = 3'b001; // SUB
        #10;

        Sel = 3'b010; // AND
        #10;

        Sel = 3'b011; // OR
        #10;

        Sel = 3'b100; // NOT
        #10;

        Sel = 3'b101; // XOR
        #10;

        Sel = 3'b110; // SHIFT
        #10;

        $finish;
    end

endmodule
