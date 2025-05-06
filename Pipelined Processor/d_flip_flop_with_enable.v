module d_flip_flop_with_enable (out, CLK, CLR, EN, in);
    output reg [31:0] out;
    input             CLK, CLR, EN;
    input      [31:0] in;

    always @(posedge CLK)
        begin
            if (CLR)
                out <= 32'b00;
            else if (EN)
                out <= in;
        end

endmodule // d_flip_flop_with_enable
