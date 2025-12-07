// Generate 1 MHz from 50 MHz input clock
module clk_1mhz (
    input  wire clk_in,     // 50 MHz
    input  wire rst,
    output reg  clk_out     // 1 MHz
);

    reg [5:0] count;  // 50 MHz / 1 MHz = 50 cycles → need 25 for toggle

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count   <= 0;
            clk_out <= 0;
        end else begin
            if (count == 24) begin   // toggle every 25 cycles → 1/2 period
                clk_out <= ~clk_out;
                count   <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule


