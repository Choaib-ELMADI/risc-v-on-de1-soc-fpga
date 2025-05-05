module three_to_one_mux (out, selectBits, in1, in2, in3);
    output reg [31:0] out;
    input       [1:0] selectBits;
    input      [31:0] in1, in2, in3;

    always @(*)
        begin
            case (selectBits)
                2'b00   : out <= in1;
                2'b01   : out <= in2;
                2'b10   : out <= in3;
                default : out <= 2'bzz;
            endcase
        end

endmodule // three_to_one_mux
