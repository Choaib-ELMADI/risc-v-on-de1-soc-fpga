module pc_next_mux (PCNext, PCSrc, PCNext1, PCNext2);
    output [31:0] PCNext;
    input         PCSrc;
    input  [31:0] PCNext1, PCNext2;

    assign PCNext = PCSrc ? PCNext2 : PCNext1;

endmodule // pc_next_mux
