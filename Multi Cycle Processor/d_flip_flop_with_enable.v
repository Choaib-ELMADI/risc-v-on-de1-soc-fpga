module d_flip_flop_with_enable (out, CLK, EN, in);
    output reg [31:0] out;
    input             CLK, EN;
    input      [31:0] in;

    always @(posedge CLK)
        begin
            if (EN)
                out <= in;
        end

endmodule // d_flip_flop_with_enable
