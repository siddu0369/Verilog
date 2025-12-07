`timescale 1ns/1ps

// D-type Flip-Flop with asynchronous active-high reset.
module d_ff (
    input  wire clk, // Clock input
    input  wire rst, // Asynchronous reset input
    input  wire d,   // Data input
    output reg  q    // Data output
);
    // This block triggers on the positive edge of the clock or the positive edge of the reset.
    always @(posedge clk or posedge rst) begin
        // If reset is asserted, the output 'q' is cleared to 0.
        if (rst)
            q <= 0;
        // Otherwise, on the clock edge, the input 'd' is captured by 'q'.
        else
            q <= d;
    end
endmodule


// 2-bit synchronous binary counter built using D-type flip-flops.
module counter_2bit (
    input  wire clk,       // Clock input
    input  wire rst,       // Asynchronous reset input for the flip-flops
    output wire [1:0] q  // 2-bit counter output
);
    wire d0, d1;

    // Next state logic for the counter.
    // This implements a T-FlipFlop behavior.
    // The LSB (q[0]) toggles on every clock cycle.
    assign d0 = ~q[0];
    // The MSB (q[1]) toggles only when the LSB (q[0]) is 1.
    assign d1 = q[1] ^ q[0];

    // Instantiate two D-type flip-flops to create the 2-bit counter.
    d_ff ff0(clk, rst, d0, q[0]);
    d_ff ff1(clk, rst, d1, q[1]);

endmodule



// Testbench for the 2-bit counter module.
module tb_counter_2bit;
    parameter delay = 200; // Defines the total simulation run time.
    reg clk, rst;          // Testbench registers to drive clock and reset.
    wire [1:0] q;          // Wire to capture the counter's output.

    // Instantiate the Device Under Test (DUT).
    counter_2bit dut(clk, rst, q);

    // Generate a clock signal with a period of 10ns (5ns high, 5ns low).
    always #5 clk = ~clk;

    // This block provides the stimulus for the test.
    initial begin
        // Set up VCD file for waveform dumping.
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_counter_2bit);

        // Initialize signals at the beginning of the simulation.
        clk = 0;
        rst = 1; // Start with reset asserted.

        // De-assert reset after 20ns to let the counter start.
        #20 rst = 0;

        // run for some time
    end

    // This block monitors the output and controls the simulation duration.
    initial begin
        // Display the simulation time and the counter value whenever 'q' changes.
        $monitor("%0t : Q = %b", $time, q);
        // Wait for the specified 'delay' time.
        # delay
        // Terminate the simulation.
        $finish;

    end

endmodule
