module mux2x1(
    input [1:0] dataIn,
    input sel,
    output muxOut
);
    assign  muxOut = (dataIn[0] & ~sel) | (dataIn[1] & sel);
endmodule

module top;
    reg  [3:0] data;      
    reg  [1:0] select;    
    wire t1, t2, t3;

    mux2x1 m1(data[1:0], select[0], t1);
    mux2x1 m2(data[3:2], select[0], t2);
    mux2x1 m3({t2, t1}, select[1], t3);
    integer count;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top);
        $monitor("data = %b, select = %b, out  = %b",data,select,t3);
        #1 select = 2'b00;
           data   = 4'b0001;
        for (count = 1; count <=3; count  = count +1)
            begin
              #1 data =  data << 1;
              select = count;
            end
        #5 $finish;
    end
endmodule
