module pwm_generator (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  duty,
    output reg         pwm_out
);
    // Simple example; ensure pwm_out is 0 on reset
    reg [7:0] counter;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 8'h00;
            pwm_out <= 1'b0;
        end else begin
            counter <= counter + 1'b1;
            pwm_out <= (counter < duty) ? 1'b1 : 1'b0;
        end
    end
endmodule
