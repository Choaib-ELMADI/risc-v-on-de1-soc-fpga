module src_b_mux (SrcB, ALUSrc, SrcB1, SrcB2);
    output [31:0] SrcB;
    input         ALUSrc;
    input  [31:0] SrcB1, SrcB2;

    assign SrcB = ALUSrc ? SrcB2 : SrcB1;

endmodule // src_b_mux
