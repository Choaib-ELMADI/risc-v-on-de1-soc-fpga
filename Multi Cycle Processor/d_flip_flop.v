module d_flip_flop (out, CLK, in);
    output reg [31:0] out;
    input             CLK;
    input      [31:0] in;

    always @(posedge CLK)
        begin
            out <= in;
        end

endmodule // d_flip_flop
