module control_unit (ALUSrcA, ALUSrcB, ImmSrc, ResultSrc, ALUControl, AdrSrc, PCWrite, MemWrite, RegWrite, IRWrite, OP, funct3, funct7, Zero);
    output   [1:0] ALUSrcA, ALUSrcB, ImmSrc, ResultSrc;
    output   [2:0] ALUControl;
    output         AdrSrc;
    output         PCWrite, MemWrite, RegWrite, IRWrite;
    input    [6:0] OP;
    input  [14:12] funct3;
    input          funct7, Zero;

    // DO THE WORK HERE!

endmodule // control_unit
