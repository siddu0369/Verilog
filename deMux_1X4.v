module deMux_1x4(
    input dataIn,
    input [1:0] sel,
    output reg [3:0] deMuxOut
);
    always @(*) begin
        deMuxOut = 4'b0000;      // default
        deMuxOut[sel] = dataIn;  // only legal in procedural block
    end
endmodule

module top;
    reg data;
    reg [1:0]select;
    wire [3:0]out;
    deMux_1x4 m1(data,select,out);
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top);
        $monitor("data = %b, select = %b, out  = %b",data,select,out);
        #1 select = 2'b00;
            data = 1'b1;
        #5 $finish;
    end 
endmodule