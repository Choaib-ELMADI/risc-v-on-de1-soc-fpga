module control_unit (PCSrc, ResultSrc, ALUSrc, ImmSrc, MemWrite, RegWrite, ALUControl, OP, funct3, funct7, Zero);
    output         PCSrc, ResultSrc, ALUSrc;
    output   [1:0] ImmSrc;
    output         MemWrite, RegWrite;
    output   [2:0] ALUControl;
    input    [6:0] OP;
    input  [14:12] funct3;
    input          funct7, Zero;

    // DO THE WORK HERE!

endmodule // control_unit
