module two_to_one_mux (out, selectBit, in1, in2);
    output [31:0] out;
    input         selectBit;
    input  [31:0] in1, in2;

    assign out = selectBit ? in2 : in1;

endmodule // two_to_one_mux
