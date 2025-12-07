module mux16to1(
    input [0:3]sel,
    input [0:15]dataIn,
    output muxOut
);
    assign muxOut = dataIn[sel];
    endmodule

module top;
    reg [0:3]sel1 = 0;
    reg [0:15]dataIn1 = 16'h0000;//2'b00
    wire out;
    
    mux16to1 m1(sel1,dataIn1,out);

    initial begin
        $monitor("select = %b, data = %b, out = %b", sel1, dataIn1,out);
        #1 sel1 = 0;
        #1 dataIn1 = 16'hffff;
        $finish;
    end 

endmodule
