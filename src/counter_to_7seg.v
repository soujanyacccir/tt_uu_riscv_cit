module counter_to_7seg (
    input  wire [3:0] val,
    output reg  [6:0] seg
);
    always @(*) begin
        // default all segments off
        seg = 7'b111_1111; // depends on common anode/cathode; choose a defined default
        case (val)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            // ... all cases ...
            default: seg = 7'b1111111;
        endcase
    end
endmodule
