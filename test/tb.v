module tb();
    reg clk = 0;
    always #5 clk = ~clk;

    reg rst_n = 0;
    reg ena   = 1;

    reg  [7:0] ui_in  = 0;
    reg  [7:0] uio_in = 0;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    tt_um_riscv_top dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        #50 rst_n = 1;
        #100 ui_in = 8'h15;
        uio_in = 8'h01;
        #50 uio_in = 0;
        #100 $finish;
    end

endmodule
