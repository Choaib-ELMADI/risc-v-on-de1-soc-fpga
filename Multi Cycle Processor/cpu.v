module cpu ();
    /* ---- . ---- */

    control_unit control (
        .ALUSrcA(),
        .ALUSrcB(),
        .ImmSrc(),
        .ResultSrc(),
        .ALUControl(),
        .AdrSrc(),
        .PCWrite(),
        .MemWrite(),
        .RegWrite(),
        .IRWrite(),     /*  ↑ OUTPUTS  */
        .OP(),          /*  ↓ INPUTS   */
        .funct3(),
        .funct7(),
        .Zero()
    );

    datapath dp (
        .OP(),
        .funct3(),
        .funct7(),
        .Zero(),        /*  ↑ OUTPUTS  */
        .RESET(),       /*  ↓ INPUTS   */
        .CLK(),
        .ALUSrcA(),
        .ALUSrcB(),
        .ImmSrc(),
        .ResultSrc(),
        .ALUControl(),
        .AdrSrc(),
        .PCWrite(),
        .MemWrite(),
        .RegWrite(),
        .IRWrite()
    );

endmodule // cpu
