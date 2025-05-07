module five_to_one_mux (out, selectBits, in1, in2, in3, in4, in5);
    output reg [31:0] out;
    input       [2:0] selectBits;
    input      [31:0] in1, in2, in3, in4, in5;

    always @(*)
        begin
            case (selectBits)
                3'b000  : out <= in1;
                3'b001  : out <= in2;
                3'b010  : out <= in3;
                3'b011  : out <= in4;
                3'b100  : out <= in5;
                default : out <= 3'bzzz;
            endcase
        end

endmodule // five_to_one_mux
