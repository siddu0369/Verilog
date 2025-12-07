`timescale 1ns/1ps

module tb_clk_1mhz;

    reg clk_in;
    reg rst;
    wire clk_out;

    // // Instantiate DUT
    clk_1mhz uut (
        .clk_in(clk_in),
        .rst(rst),
        .clk_out(clk_out)
    );

    // ---------------------------
    // 50 MHz clock generation
    // Period = 20 ns
    // ---------------------------
    always #10 clk_in = ~clk_in;

    initial begin
        // Dump wavs
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_clk_1mhz);

        // Init
        clk_in = 0;
        rst    = 1;

        // Release reset
        #50 rst = 0;

        // Run simulation
        #50000;   // 50 us → enough to observe 1MHz
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("%0t ns : clk_out = %b", $time, clk_out);
    end

endmodule
