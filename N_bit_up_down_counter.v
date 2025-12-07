`timescale 1ns/1ps

// Parameterized N-bit synchronous up/down counter with asynchronous reset.
module counter #
(
    parameter N_bits = 4 // Defines the width of the counter
)
(
    input clk,                          // Clock input
    input rst,                          // Asynchronous reset input
    input [N_bits-1:0] initial_state,   // Value to load on reset
    input up_down,                      // Control for counting direction: 1 for up, 0 for down
    output reg [N_bits-1:0] count       // Counter output
);

    // This block describes the counter's behavior.
    always @(posedge clk or posedge rst) begin
        // On positive edge of reset, load the initial state.
        if (rst) begin
            count <= initial_state;
        end 
        // If not in reset and up_down is high, increment the count.
        else if (up_down) begin
            count <= count + 1;
        end 
        // If not in reset and up_down is low, decrement the count.
        else begin
            count <= count - 1;
        end
    end

endmodule

// Simple clock generator module.
module clk_gen(output reg clkOut);
    parameter half_time = 10; // Defines half the clock period (e.g., 10ns for a 20ns period).

    // Initialize clock to 0 at the start of the simulation.
    initial clkOut = 0;

    // Continuously toggle the clock signal every 'half_time'.
    always #half_time clkOut = ~clkOut;
endmodule

// Testbench for the N-bit counter.
module tb_counter;

    wire clk;
    reg rst, up_down;
    reg [3:0] initial_state;
    wire [3:0] counterOut;

    // Instantiate the clock generator.
    clk_gen clk0(.clkOut(clk));
    // Instantiate the counter (Device Under Test), with N_bits set to 4.
    counter #(4) c0(clk, rst, initial_state, up_down, counterOut);

    initial begin
        // Monitor and display the counter's output whenever it changes.
        $monitor("%0t : count = %b", $time, counterOut);
        // Set up VCD file for waveform dumping.
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_counter);

        // Start
        rst = 0;
        up_down = 1;        // Set to count up.
        initial_state = 4'b1100;

        // Apply and release reset to load the initial state.
        #5 rst = 1;
        #5 rst = 0;

        // Let it count up for 300 time units.
        # 300;

        // Down count
        up_down = 0;        // Switch to count down.
        initial_state = 4'b1111;

        // Apply and release reset to load the new initial state.
        #5 rst = 1;
        #5 rst = 0;

        // Let it count down for 300 time units.
        # 300;

        // End the simulation.
        $finish;
    end

endmodule
