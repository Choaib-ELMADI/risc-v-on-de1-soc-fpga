module cpu ();
    /* ---- . ---- */

    control_unit control (
        .PCSrc(),
        .ResultSrc(),
        .ALUSrc(),
        .ImmSrc(),
        .MemWrite(),
        .RegWrite(),
        .ALUControl(),  /*  ↑ OUTPUTS  */
        .OP(),          /*  ↓ INPUTS   */
        .funct3(),
        .funct7(),
        .Zero()
    );

    datapath dp (
        .OP(),
        .funct3(),
        .funct7(),
        .Zero(),    /*  ↑ OUTPUTS  */
        .RESET(),   /*  ↓ INPUTS   */
        .CLK(),
        .EN(),
        .PCSrc(),
        .ResultSrc(),
        .ALUSrc(),
        .ImmSrc(),
        .MemWrite(),
        .RegWrite(),
        .ALUControl()
    );

endmodule // cpu
