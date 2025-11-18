`default_nettype none

module tt_um_riscv_top(
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // -----------------------------
    // GPIO Register
    // -----------------------------
    wire [7:0] gpio_out;
    wire [7:0] unused_rdata;

    gpio_reg u_gpio (
        .clk      (clk),
        .rst_n    (rst_n),
        .we       (uio_in[0] & ena),
        .wdata    (ui_in),
        .rdata    (unused_rdata),
        .gpio_out (gpio_out)
    );

    // -----------------------------
    // PWM
    // -----------------------------
    wire pwm_sig;

    pwm_generator u_pwm (
        .clk     (clk),
        .rst_n   (rst_n),
        .duty    (gpio_out),
        .pwm_out (pwm_sig)
    );

    // -----------------------------
    // 7-segment display
    // -----------------------------
    wire [6:0] seg7;

    counter_to_7seg u_seg (
        .val (gpio_out[3:0]),
        .seg (seg7)
    );

       // -----------------------------
    // OUTPUTS (reset-safe)
    // -----------------------------
    // Ensure outputs are driven to known values during reset to avoid X propagation
    wire [7:0] uo_out_int;
    wire [7:0] uio_out_int;

    assign uo_out_int  = gpio_out;
    assign uio_out_int = {pwm_sig, seg7};

    // drive real pads low during reset to avoid X/Z during gl sim
    assign uo_out  = (rst_n) ? uo_out_int  : 8'h00;
    assign uio_out = (rst_n) ? uio_out_int : 8'h00;
    assign uio_oe  = 8'hFF;   // keep as-is (if you want outputs active during reset)

endmodule

`default_nettype wire
